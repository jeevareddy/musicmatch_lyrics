import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class NetworkService extends ChangeNotifier {
  NetworkService() {
    // checkConnectivity(null);
    initState();
  }
  bool available = true;

  void updateStatus(bool val) {
    available = val;
    notifyListeners();
    // if (val) TracksBloc().getTracks();
  }

  checkConnectivity(ConnectivityResult result) async {
    // if (result == null) result = await Connectivity().checkConnectivity();
    print("Checking Connectivity");
    if (result != ConnectivityResult.none) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          updateStatus(true);
          print("Connected");
        }
      } on SocketException catch (e) {
        updateStatus(false);
        print("No Connectivity" + e.message.toString());
      }
    } else {
      updateStatus(false);
    }
  }

  void initState() async {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      checkConnectivity(result);
    });
  }
}
