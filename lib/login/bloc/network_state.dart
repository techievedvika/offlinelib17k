part of 'network_cubit.dart';

enum ConnectionType { Wifi, Mobile }

abstract class NetworkState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NetworkLoading extends NetworkState {}

class NetworkConnected extends NetworkState {
  final ConnectionType connectionType;

  NetworkConnected({required this.connectionType});

  @override
  List<Object?> get props => [connectionType];
}

class NetworkDisconnected extends NetworkState {}
