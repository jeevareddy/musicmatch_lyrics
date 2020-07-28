import 'package:flutter/material.dart';
import 'package:musicmatch_lyrics/BLOCs/tracksBloc.dart';
import 'package:musicmatch_lyrics/DataModels/trackModel.dart';
import 'package:musicmatch_lyrics/constants.dart';
import 'package:musicmatch_lyrics/services/bookmarks.dart';
import 'package:musicmatch_lyrics/services/networkService.dart';
import 'package:musicmatch_lyrics/widgets/trackCard.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Size size;
  @override
  void initState() {
    tracksBloc = TracksBloc();
    super.initState();
  }

  @override
  void dispose() {
    tracksBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    print("rebuild");
    return Scaffold(
      appBar: AppBar(
        title: Text("Trending"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.pushNamed(context, 'Bookmarks');
            },
          )
        ],
      ),
      body: Consumer2<NetworkService, BookMarkService>(
        builder: (context, network, bookmark, child) => Container(
          height: size.height,
          width: size.width,
          child: StreamBuilder<List<Track>>(
            stream: tracksBloc.tracksController.stream,
            builder: (context, snapshot) {
              print(snapshot.data);
              if (network.available) {
                if (snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting ||
                    bookmark.bookMarks == null ||
                    tracksBloc.track == null) {
                  // _tracksBloc.getTracks();
                  return Center(child: CircularProgressIndicator());
                }
                if (tracksBloc.track.length == 0)
                  return Center(
                    child: Text("No Tracks"),
                  );
                return SingleChildScrollView(
                  child: Column(
                    children: List.generate(tracksBloc.track.length, (index) {
                      tracksBloc.track[index].marked = bookmark.bookMarks
                          .contains(tracksBloc.track[index].id.toString());
                      return TrackCard(
                        track: tracksBloc.track[index],
                        bookmark: bookmark,
                        bookMark: tracksBloc,
                      );
                    }),
                  ),
                );
              } else
                return Center(child: Text("No Internet Connection"));
            },
          ),
        ),
      ),
    );
  }
}
