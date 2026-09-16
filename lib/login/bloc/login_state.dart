import '../../models/license.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
   final String message;
   LoginSuccess(this.message);
}

class LoginFailure extends LoginState {
  final String message;
  final String? code;
  final License? license;

  LoginFailure(this.message, {this.code, this.license});
}
