import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:musicmatch_lyrics/DataModels/trackModel.dart';
import 'package:musicmatch_lyrics/constants.dart';

class TracksBloc {
  final _trackListStreamController = StreamController<List<Track>>.broadcast();
  final bookmarkController = StreamController<Track>.broadcast();
  StreamController<List<Track>> get tracksController =>
      _trackListStreamController;
  List<Track> tracks;

  List<Track> get track => tracks;
  TracksBloc() {
    // getTracks();
    _trackListStreamController.stream.listen((event) async {
      if (tracks == null || tracks.isEmpty) {
        await fetchTracks();
        _trackListStreamController.add([]);
      }
      print("track listen");
      // print(tracks.toString());
    });
    bookmarkController.stream.listen((event) {
      bookMark(event);
    });
  }
  getTracks() async {
    await fetchTracks();
    // _trackListStreamController.add(tracks);
  }

  fetchTracks() async {
    print("AddCalled\n\n\n\n\n");
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

    // _trackListStreamController.add(tracks);
  }

  addTrack(Map<String, dynamic> element) {
    if (tracks == null) tracks = [];
    tracks.add(Track(
      name: element['track']['track_name'],
      album: element['track']['album_name'],
      artist: element['track']['artist_name'],
      id: element['track']['track_id'],
    ));
  }

  bookMark(Track track) {
    tracks.forEach((element) {
      if (element.id == track.id) element.marked = !element.bookMarked;
    });
  }

  void dispose() {
    _trackListStreamController.close();
  }
}
