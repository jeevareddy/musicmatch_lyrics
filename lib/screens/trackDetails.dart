import 'package:flutter/material.dart';
import 'package:musicmatch_lyrics/BLOCs/trackDetailsBloc.dart';
import 'package:musicmatch_lyrics/DataModels/trackModel.dart';
import 'package:musicmatch_lyrics/services/networkService.dart';
import 'package:provider/provider.dart';

class TrackDetails extends StatefulWidget {
  final Track track;
  TrackDetails({Key key, this.track}) : super(key: key);

  @override
  _TrackDetailsState createState() => _TrackDetailsState();
}

class _TrackDetailsState extends State<TrackDetails> {
  TrackDetailsBloc _trackDetailsBloc, _lyricsBloc;
  Size size;
  @override
  void initState() {
    _trackDetailsBloc = TrackDetailsBloc(widget.track);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    print("rebuild");
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Details"),
      ),
      body: Consumer<NetworkService>(
        builder: (context, network, child) => Container(
          height: size.height,
          width: size.width,
          child: StreamBuilder<Track>(
            stream: _trackDetailsBloc.trackDetailsController.stream,
            builder: (context, snapshot) {
              print(snapshot.data.toString());
              if (network.available) {
                if (snapshot.data == null &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  _trackDetailsBloc.fetchTracks(widget.track.id);
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.explicit == null)
                  return Center(
                    child: Text("Error, try again"),
                  );
                _lyricsBloc = TrackDetailsBloc(snapshot.data);
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customRow(heading: "Name", body: snapshot.data.name),
                        customRow(
                            heading: "Artist", body: snapshot.data.artist),
                        customRow(
                            heading: "Album Name", body: snapshot.data.album),
                        customRow(
                            heading: "Explicit",
                            body:
                                snapshot.data.explicit == 0 ? "False" : "True"),
                        customRow(
                            heading: "Rating",
                            body: snapshot.data.rating.toString()),
                        StreamBuilder<Track>(
                          stream: _lyricsBloc.lyricsController.stream,
                          builder: (context, lyricsSnap) {
                            if (lyricsSnap.data == null ||
                                lyricsSnap.data.lyrics == null) {
                              _lyricsBloc.lyricsController.sink
                                  .add(snapshot.data);
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else
                              return customRow(
                                  heading: "Lyrics",
                                  body: lyricsSnap.data.lyrics.toString());
                          },
                        )
                      ],
                    ),
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

  customRow({String heading, String body}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            body,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
