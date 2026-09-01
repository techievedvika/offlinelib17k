import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'sync_engine.dart';

abstract class SyncStatusState {}
class SyncInitial extends SyncStatusState {}
class SyncOffline extends SyncStatusState {}
class SyncInProgress extends SyncStatusState {}
class SyncCompleted extends SyncStatusState {}
class SyncFailed extends SyncStatusState {
  final String message;
  SyncFailed(this.message);
}

class SyncStatusCubit extends Cubit<SyncStatusState> {
  final SyncEngine syncEngine;
  StreamSubscription? _connSub;

  SyncStatusCubit(this.syncEngine) : super(SyncInitial()) {
    _connSub = Connectivity().onConnectivityChanged.listen((result) {
      final online = result.isNotEmpty && !result.contains(ConnectivityResult.none);
      if (online) {
        _runSync();
      } else {
        emit(SyncOffline());
      }
    });
  }

  Future<void> _runSync() async {
    emit(SyncInProgress());
    try {
      await syncEngine.runSync();
      emit(SyncCompleted());
    } catch (e) {
      emit(SyncFailed(e.toString()));
    }
  }

  Future<void> close() {
    _connSub?.cancel();
    return super.close();
  }
}