import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/forms/dashboard/dash_state.dart';
import 'package:lib17000ft/login/repository/dash_repository.dart';

import '../../configs/app_urls.dart';

class DashCubit extends Cubit<DashState> {
  DashCubit() : super(DashInitial());


  Future<String?> fetchLibVersion() async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.getAppVersionApi),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['error'] == false) {
          // If response is list: [{lib_version: "1.0.5"}]
          final list = data['message'];

          if (list != null && list.isNotEmpty) {
            return list[0]['lib_version'];
          }
        }
      } else {
        print('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }

    return null;
  }

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
