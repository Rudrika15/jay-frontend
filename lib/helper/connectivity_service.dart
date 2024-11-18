import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  late StreamController<List<ConnectivityResult>>
      _connectivityStreamController =
      StreamController<List<ConnectivityResult>>();

  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivityStreamController.stream;
  late List<ConnectivityResult> _connectivityResult = [ConnectivityResult.none];

  List<ConnectivityResult> get connectivityResult => _connectivityResult;

  ConnectivityService() {
    _connectivityStreamController =
        StreamController<List<ConnectivityResult>>.broadcast(
            onListen: () async {
      _connectivityResult = await _connectivity.checkConnectivity();
      _connectivityStreamController.add(_connectivityResult);
    });
    _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        _connectivityResult = result;
        _connectivityStreamController.add(result);
      },
    );
  }

  void dispose() {
    _connectivityStreamController.close();
  }
}
