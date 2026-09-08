import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'sync_engine.dart';
//
// abstract class SyncStatusState {}
// class SyncInitial extends SyncStatusState {}
// class SyncOffline extends SyncStatusState {}
// class SyncInProgress extends SyncStatusState {}
// class SyncCompleted extends SyncStatusState {}
// class SyncFailed extends SyncStatusState {
//   final String message;
//   SyncFailed(this.message);
// }
//
// class SyncStatusCubit extends Cubit<SyncStatusState> {
//   final SyncEngine syncEngine;
//   StreamSubscription? _connSub;
//
//   SyncStatusCubit(this.syncEngine) : super(SyncInitial()) {
//     _connSub = Connectivity().onConnectivityChanged.listen((result) {
//       final online = result.isNotEmpty && !result.contains(ConnectivityResult.none);
//       if (online) {
//         _runSync();
//       } else {
//         emit(SyncOffline());
//       }
//     });
//   }
//
//   Future<void> _runSync() async {
//     emit(SyncInProgress());
//     try {
//       await syncEngine.runSync();
//       emit(SyncCompleted());
//     } catch (e) {
//       emit(SyncFailed(e.toString()));
//     }
//   }
//
//   Future<void> close() {
//     _connSub?.cancel();
//     return super.close();
//   }
// }

// core/sync/sync_status_cubit.dart
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
      final pending = await syncEngine.getPendingCount(); // NEW
      emit(SyncCompleted(pendingCount: pending)); // NEW — carry the count forward
    } catch (e) {
      emit(SyncFailed(e.toString()));
    }
  }

  // NEW — manual trigger for the drawer button
  Future<void> manualSync() async {
    final result = await Connectivity().checkConnectivity();
    final online = result.isNotEmpty && !result.contains(ConnectivityResult.none);
    if (!online) {
      emit(SyncOffline());
      return;
    }
    await _runSync();
  }

  Future<int> currentPendingCount() => syncEngine.getPendingCount(); // NEW — for display without triggering a sync

  @override
  Future<void> close() {
    _connSub?.cancel();
    return super.close();
  }
}

abstract class SyncStatusState {}
class SyncInitial extends SyncStatusState {}
class SyncOffline extends SyncStatusState {}
class SyncInProgress extends SyncStatusState {}
class SyncCompleted extends SyncStatusState {
  final int pendingCount; // NEW
  SyncCompleted({this.pendingCount = 0});
}
class SyncFailed extends SyncStatusState {
  final String message;
  SyncFailed(this.message);
}