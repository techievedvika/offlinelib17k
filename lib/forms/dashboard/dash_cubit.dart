import 'package:bloc/bloc.dart';
import 'package:lib17000ft/forms/dashboard/dash_state.dart';
import 'package:lib17000ft/login/repository/dash_repository.dart';

class DashCubit extends Cubit<DashState> {
  DashCubit() : super(DashInitial());

  final DashRepository _dashRepository = DashRepository();

  void dashData(
      {
       required dynamic adminId,
      String? from,
      String? to,
      String? stateName,
      String? block,
      String? school}) async {
    emit(DashLoading());

    try {
      
      final value = await _dashRepository.fetchDashData(
          adminId, from, to, stateName, block, school);

      if (value == null) {
        emit(DashFailure("No data received from server"));
      } else if (value.error == true) {
        emit(DashFailure(value.message));
      } else {
        emit(DashSuccess(value));
      }
    } catch (error) {
      emit(DashFailure('Something went wrong: $error'));
    }
  }
}
