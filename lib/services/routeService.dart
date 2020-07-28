import 'package:flutter/material.dart';
import 'package:musicmatch_lyrics/DataModels/trackModel.dart';
import 'package:musicmatch_lyrics/screens/bookmarks.dart';
import 'package:musicmatch_lyrics/screens/home.dart';
import 'package:musicmatch_lyrics/screens/trackDetails.dart';

class RouteService extends RouteSettings {
  onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => Home(),
        );
        break;
      case 'view track':
        Track track = routeSettings.arguments;
        return MaterialPageRoute(
          builder: (context) => TrackDetails(
            track: track,
          ),
        );
        break;
      case 'Bookmarks':
        return MaterialPageRoute(
          builder: (context) => BookMarks(),
        );
        break;
    }
  }
}
