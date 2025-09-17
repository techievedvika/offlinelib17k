// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:recce/repository/auth/login_repository.dart';
// import 'package:recce/utils/enums.dart';

// part 'login_event.dart';

// class LoginBloc extends Bloc<LoginEvents, LoginState> {
//   final LoginRepository _loginRepository = LoginRepository();

//   LoginBloc() : super(const LoginState()) {
//     on<UsernameChanged>(_onUsernameChanged);
//     on<PasswordChanged>(_onPasswordChanged);
//     on<LoginButtonPressed>(_onLoginApi);
//   }

//   void _onUsernameChanged(UsernameChanged event, Emitter<LoginState> emit) {
//     emit(state.copyWith(username: event.username));
//   }

//   void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
//     emit(state.copyWith(password: event.password));
//   }

//   void _onLoginApi(LoginButtonPressed event, Emitter<LoginState> emit) async {
//     emit(state.copyWith(postApiStatus: PostApiStatus.loading));

//     try {
//       final value = await _loginRepository.loginApi({"username": state.username, "password": state.password});
//       if (value!.status == 0) {
//         emit(state.copyWith(
//           message: value.message.toString(),
//           postApiStatus: PostApiStatus.error,
//         ));
//       } else if(value.status == 1) {
//         emit(state.copyWith(
//           message: value.message.toString(),
//           postApiStatus: PostApiStatus.success,
//         ));
//       }
//     } catch (error) {
//       emit(state.copyWith(
//         message: error.toString(),
//         postApiStatus: PostApiStatus.error,
//       ));
//     }
//   }
// }
