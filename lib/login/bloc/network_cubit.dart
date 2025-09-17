import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final Connectivity _connectivity;

  NetworkCubit(this._connectivity) : super(NetworkLoading()) {
    _checkInitialConnectivity();
    _monitorConnectivity();
  }

  void _checkInitialConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _emitNetworkStatus(result);
  }

  void _monitorConnectivity() {
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      _emitNetworkStatus(connectivityResult);
    });
  }

  void _emitNetworkStatus(List<ConnectivityResult> result) {
    print('this is result $result');
    if (result[0] == ConnectivityResult.mobile) {
      emit(NetworkConnected(connectionType: ConnectionType.Mobile));
    } else if (result[0] == ConnectivityResult.wifi) {
      emit(NetworkConnected(connectionType: ConnectionType.Wifi));
    } else {
      emit(NetworkDisconnected());
    }
  }
}
