import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../seamless_data_sync.dart';

class NetworkMonitor {
  final Connectivity _connectivity = Connectivity();
  final SeamlessDataManager seamlessDataManager;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  NetworkMonitor(this.seamlessDataManager) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      // ignore: unrelated_type_equality_checks
      if (result != ConnectivityResult.none) {
        seamlessDataManager.sync();
      }
    });
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }
}
