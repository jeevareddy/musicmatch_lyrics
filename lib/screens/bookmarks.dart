import 'package:flutter/material.dart';
import 'package:musicmatch_lyrics/BLOCs/bookMarksBloc.dart';
import 'package:musicmatch_lyrics/DataModels/trackModel.dart';
import 'package:musicmatch_lyrics/services/bookmarks.dart';
import 'package:musicmatch_lyrics/services/networkService.dart';
import 'package:musicmatch_lyrics/widgets/trackCard.dart';
import 'package:provider/provider.dart';

class BookMarks extends StatefulWidget {
  BookMarks({Key key}) : super(key: key);

  @override
  _BookMarksState createState() => _BookMarksState();
}

class _BookMarksState extends State<BookMarks> {
  Size size;
  BookMarksBloc _bookMarkBloc;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarks"),
      ),
      body: Consumer2<NetworkService, BookMarkService>(
        builder: (context, network, bookmark, child) {
          _bookMarkBloc = BookMarksBloc(bookmark);
          return Container(
            height: size.height,
            width: size.width,
            child: StreamBuilder<List<Track>>(
              stream: _bookMarkBloc.bookmarkTracksController.stream,
              builder: (context, snapshot) {
                print(bookmark.bookMarks.toString());

                if (network.available) {
                  if (_bookMarkBloc.bookMarkTracks == null) {
                    // _bookMarkBloc.getSavedBookMarks();
                    return Center(child: CircularProgressIndicator());
                  }

                  if (_bookMarkBloc.bookMarkTracks.length == 0)
                    return Center(
                      child: Text("No Bookmarks"),
                    );
                  return SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                          _bookMarkBloc.bookMarkTracks.length, (index) {
                        _bookMarkBloc.bookMarkTracks[index].marked = bookmark
                            .bookMarks
                            .contains(_bookMarkBloc.bookMarkTracks[index].id
                                .toString());
                        print(_bookMarkBloc.bookMarkTracks[index].bookMarked
                            .toString());
                        return TrackCard(
                          track: _bookMarkBloc.bookMarkTracks[index],
                          bookmark: bookmark,
                          bookMark: _bookMarkBloc,
                        );
                      }),
                    ),
                  );
                } else
                  return Center(child: Text("No Internet Connection"));
              },
            ),
          );
        },
      ),
    );
  }
}
