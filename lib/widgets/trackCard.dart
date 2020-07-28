import 'package:flutter/material.dart';
import 'package:musicmatch_lyrics/BLOCs/tracksBloc.dart';
import 'package:musicmatch_lyrics/DataModels/trackModel.dart';
import 'package:musicmatch_lyrics/services/bookmarks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackCard extends StatefulWidget {
  final Track track;
  final BookMarkService bookmark;
  final bookMark;
  TrackCard({Key key, this.track, this.bookmark, this.bookMark})
      : super(key: key);

  @override
  _TrackCardState createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  SharedPreferences spi;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      widget.bookMark.bookmarkController.add(widget.track);
                      widget.bookmark.updateBookmarks(
                          widget.track.id.toString(), !widget.track.bookMarked);
                    },
                    child: Icon(widget.track.bookMarked
                        ? Icons.bookmark
                        : Icons.bookmark_border),
                  ),
                ),
                Text(
                  widget.track.artist,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
              ],
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
