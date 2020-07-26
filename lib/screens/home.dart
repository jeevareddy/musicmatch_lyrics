import 'package:flutter/material.dart';
import 'package:musicmatch_lyrics/BLOCs/tracksBloc.dart';
import 'package:musicmatch_lyrics/DataModels/trackModel.dart';
import 'package:musicmatch_lyrics/services/networkService.dart';
import 'package:musicmatch_lyrics/widgets/trackCard.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TracksBloc _tracksBloc;
  Size size;
  @override
  void initState() {
    _tracksBloc = TracksBloc();
    super.initState();
  }

  @override
  void dispose() {
    _tracksBloc.dispose();
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
      ),
      body: Consumer<NetworkService>(
        builder: (context, network, child) => Container(
          height: size.height,
          width: size.width,
          child: StreamBuilder<List<Track>>(
            stream: _tracksBloc.tracksController.stream,
            builder: (context, snapshot) {
              print(snapshot.data.toString());
              if (network.available) {
                if (snapshot.data == null &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  _tracksBloc.getTracks();
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.length == 0)
                  return Center(
                    child: Text("Error, try again"),
                  );
                return SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                        snapshot.data.length,
                        (index) => TrackCard(
                              track: snapshot.data[index],
                            )),
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
