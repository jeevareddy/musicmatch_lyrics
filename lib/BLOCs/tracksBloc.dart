import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:musicmatch_lyrics/DataModels/trackModel.dart';
import 'package:musicmatch_lyrics/constants.dart';

class TracksBloc {
  final _trackListStreamController = StreamController<List<Track>>.broadcast();
  StreamController<List<Track>> get tracksController =>
      _trackListStreamController;
  List<Track> tracks = [];
  TracksBloc() {
    getTracks();
    _trackListStreamController.stream.listen((event) async {
      if (tracks.isEmpty) {
        await fetchTracks();
      }
    });
  }
  getTracks() async {
    await fetchTracks();
    print(tracks);
    _trackListStreamController.add(tracks);
  }

  fetchTracks() async {
    Response response = await get(
      'https://api.musixmatch.com/ws/1.1/chart.tracks.get?&apikey=$apiKey',
    );
    Map<String, dynamic> responseBody = json.decode(response.body);
    if (responseBody['message']['body']['track_list'] != null) {
      List tracks = responseBody['message']['body']['track_list'];
      for (var element in tracks) {
        addTrack(element);
      }
    }

    _trackListStreamController.add(tracks);
  }

  addTrack(Map<String, dynamic> element) {
    tracks.add(Track(
      name: element['track']['track_name'],
      album: element['track']['album_name'],
      artist: element['track']['artist_name'],
      id: element['track']['track_id'],
    ));
  }

  void dispose() {
    _trackListStreamController.close();
  }
}
