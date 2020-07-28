import 'package:flutter/material.dart';
import 'package:musicmatch_lyrics/constants.dart';
import 'package:musicmatch_lyrics/services/bookmarks.dart';
import 'package:musicmatch_lyrics/services/networkService.dart';
import 'package:musicmatch_lyrics/services/routeService.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => NetworkService(),
    ),
    ChangeNotifierProvider(
      create: (context) => BookMarkService(),
    )
  ], builder: (context, child) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicMatch Lyrics',
      theme: themeData,
      onGenerateRoute: (settings) => RouteService().onGenerateRoute(settings),
      debugShowCheckedModeBanner: false,
    );
  }
}
