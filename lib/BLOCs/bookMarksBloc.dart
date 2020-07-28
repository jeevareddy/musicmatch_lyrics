import 'dart:async';
import 'dart:convert';

import 'package:musicmatch_lyrics/DataModels/trackModel.dart';
import 'package:musicmatch_lyrics/constants.dart';
import 'package:musicmatch_lyrics/services/bookmarks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class BookMarksBloc {
  BookMarkService _bookMarkService;
  List<Track> bookMarkTracks;
  SharedPreferences spi;

  final bookmarkTracksController = StreamController<List<Track>>.broadcast();
  final bookmarkController = StreamController<Track>.broadcast();

  BookMarksBloc(this._bookMarkService) {
    getSavedBookMarks();
    bookmarkTracksController.stream.listen((event) async {
      if (bookMarkTracks == null) await getSavedBookMarks();
    });
    bookmarkController.stream.listen((event) {
      bookMark(event);
    });
  }

  getSavedBookMarks() async {
    if (_bookMarkService.bookMarks != null ||
        _bookMarkService.bookMarks.isNotEmpty) {
      for (var i = 0; i < _bookMarkService.bookMarks.length; i++) {
        await fetchTracks(_bookMarkService.bookMarks[i]);
      }
      print("BM\n\n" + bookMarkTracks.toString());
      if (bookMarkTracks == null || bookMarkTracks.isEmpty) {
        bookMarkTracks = [];
        bookmarkTracksController.add([]);
      } else
        bookmarkTracksController.add(bookMarkTracks);
    }
  }

  fetchTracks(String id) async {
    Response response = await get(
      'https://api.musixmatch.com/ws/1.1/track.get?track_id=$id&apikey=$apiKey',
    );
    Map<String, dynamic> responseBody = json.decode(response.body);
    if (responseBody['message']['body']['track'] != null) {
      Map tracks = responseBody['message']['body']['track'];
      addTrack(tracks);
    }
  }

  addTrack(Map<String, dynamic> element) {
    if (bookMarkTracks == null) bookMarkTracks = [];
    bookMarkTracks.add(Track(
      id: element['track_id'],
      name: element['track_name'],
      album: element['album_name'],
      artist: element['artist_name'],
    ));
  }

  bookMark(Track track) {
    int index = bookMarkTracks.indexWhere((element) => element.id == track.id);
    print(index.toString());

    bookMarkTracks[index].marked = !bookMarkTracks[index].bookMarked;
    bookMarkTracks.removeWhere((element) => element.bookMarked == false);
  }
}
