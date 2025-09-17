import 'package:lib17000ft/models/dash/dash_model.dart';

abstract class DashState {}

class DashInitial extends DashState {}

class DashLoading extends DashState {}

class DashSuccess extends DashState {
  
  final DashModel data;

  DashSuccess(this.data);
 
}

class DashFailure extends DashState {
  final String message;

  DashFailure(this.message);
}
