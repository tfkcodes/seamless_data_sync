import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Small network monitor that emits boolean online status.
/// For simplicity: online when connectivity != none.
class NetworkMonitor {
  final Connectivity _connectivity;
  final StreamController<bool> _controller = StreamController.broadcast();
  StreamSubscription<ConnectivityResult>? _sub;

  NetworkMonitor({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  Stream<bool> get onStatusChanged => _controller.stream;

  Future<void> start() async {
    // initial status
    final result = await _connectivity.checkConnectivity();
    _controller.add(_isOnline(result as ConnectivityResult));

    _sub = _connectivity.onConnectivityChanged.listen((res) {
      _controller.add(_isOnline(res as ConnectivityResult));
    }) as StreamSubscription<ConnectivityResult>?;
  }

  bool _isOnline(ConnectivityResult r) {
    return r != ConnectivityResult.none;
  }

  Future<void> stop() async {
    await _sub?.cancel();
    await _controller.close();
  }
}
