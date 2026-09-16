import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lib17000ft/login/bloc/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/device_id_helper.dart';
import '../repository/login_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  String username = '';
  String password = '';
  String? fcmToken;
  String? userId;

  final LoginRepository _loginRepository = LoginRepository();

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
      userId = prefs.getString('userId');
    // });
    print("this is the user id $userId");
  }

Future<void> getToken() async {
 await  _loadUserId();
    fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");
    setToken(fcmToken,userId);
  }

  setToken(String? token, String?id)async{
      try {
      final value = await _loginRepository.setToken(id, token);
      print('this is valye we get from getToken $value');
      // if (value!.status == 0) {
      //  emit(LoginFailure(value.message));
      // } else if(value.status == 1) {
      //  emit(LoginSuccess(value.message));
      // }
    } catch (error) {
    emit(LoginFailure('Something went wrong'));
    }
  }

  

   void login(String username, String password, String deviceUuid, String deviceName) async {
    emit(LoginLoading());

    try {
      final value = await _loginRepository.loginApi({
        "username": username,
        "password": password,
        "device_uuid": deviceUuid,
        "device_name": deviceName,
      });

      if (value != null) {
        if (value.status == 1) {
          // Success
          userId = value.user?.id.toString();
          emit(LoginSuccess(value.message));
        } else {
          // Handled failures from Laravel (status 0)
          // Includes codes: LICENSE_REQUIRED, LICENSE_EXPIRED, DEVICE_INACTIVE, DEVICE_LIMIT_REACHED
          emit(LoginFailure(
            value.message,
            code: value.code,
            license: value.license,
          ));
        }
      } else {
        emit(LoginFailure('Invalid response from server'));
      }
    } catch (error) {
      print('Login error: $error');
      
      String errorMessage = 'Something went wrong';
      String? errorCode;
      
      if (error.toString().contains('No Internet Connection')) {
        errorMessage = 'No Internet Connection. Please check your network.';
        errorCode = 'NO_INTERNET';
      } else if (error.toString().contains('Request Timed Out')) {
        errorMessage = 'Request timed out. Please try again.';
        errorCode = 'TIMEOUT';
      } else {
        errorMessage = error.toString().replaceFirst('Custom Error: ', '');
      }
      
      emit(LoginFailure(errorMessage, code: errorCode));
    }
  }


  
}
