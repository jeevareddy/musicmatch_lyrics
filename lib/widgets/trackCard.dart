import 'package:flutter/material.dart';
import 'package:musicmatch_lyrics/DataModels/trackModel.dart';

class TrackCard extends StatefulWidget {
  final Track track;
  TrackCard({Key key, this.track}) : super(key: key);

  @override
  _TrackCardState createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => Navigator.pushNamed(context, 'view track',
              arguments: widget.track),
          leading: Icon(Icons.library_music),
          title: Text(widget.track.name),
          subtitle: Text(widget.track.album.toString()),
          trailing: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Text(
              widget.track.artist,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 15,
          endIndent: 15,
        )
      ],
    );
  }
}
