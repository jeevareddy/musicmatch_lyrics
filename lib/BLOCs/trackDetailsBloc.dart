import 'dart:async';
import 'dart:convert';
import 'package:musicmatch_lyrics/DataModels/trackModel.dart';
import 'package:http/http.dart';
import 'package:musicmatch_lyrics/constants.dart';

class TrackDetailsBloc {
  final trackDetailsController = StreamController<Track>.broadcast();
  final lyricsController = StreamController<Track>.broadcast();
  final Track track;
  TrackDetailsBloc(this.track) {
    fetchTracks(this.track.id);
    trackDetailsController.stream.listen((event) async {
      if (this.track.explicit == null) {
        await fetchTracks(this.track.id);
        lyricsController.add(this.track);
      }
    });
    lyricsController.stream.listen((event) async {
      if (event.lyrics == null) await getLyrics(event);
    });
  }
  getLyrics(Track track) async {
    Response response = await get(
      'https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=${track.id}&apikey=$apiKey',
    );
    Map<String, dynamic> responseBody = json.decode(response.body);
    if (responseBody['message']['body']['lyrics'] != null) {
      Map<String, dynamic> lyrics = responseBody['message']['body']['lyrics'];
      track.setlyrics = lyrics['lyrics_body'];
      lyricsController.add(track);
    }
  }

  fetchTracks(int id) async {
    Response response = await get(
      'https://api.musixmatch.com/ws/1.1/track.get?track_id=$id&apikey=$apiKey',
    );
    Map<String, dynamic> responseBody = json.decode(response.body);
    if (responseBody['message']['body']['track'] != null) {
      Map<String, dynamic> track = responseBody['message']['body']['track'];
      this.track.setrating = track['track_rating'];
      this.track.setexplicit = track['explicit'];
      trackDetailsController.add(this.track);
    }
  }
}
