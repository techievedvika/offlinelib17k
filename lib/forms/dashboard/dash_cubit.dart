import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/forms/dashboard/dash_state.dart';
import 'package:lib17000ft/login/repository/dash_repository.dart';

import '../../configs/app_urls.dart';

class DashCubit extends Cubit<DashState> {
  DashCubit() : super(DashInitial());

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  Future<String?> fetchLibVersion() async {
    try {
      final response = await http.post(
        Uri.parse(AppUrls.getAppVersionApi),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // if (data['error'] == false) {
        //   // If response is list: [{lib_version: "1.0.5"}]
        //   final list = data['message'];
        //
        //   if (list != null && list.isNotEmpty) {
        //     return list[0]['lib_version'];
        //   }
        // }
        if (data['error'] == false) {
          return data['message']?.toString();
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

      final online = await _isOnline();

      final value = online
          ? await _dashRepository.fetchDashData(adminId, from, to, stateName, block, school)
          : await _dashRepository.fetchDashDataOffline(); // NEW — offline branch
      
      // final value = await _dashRepository.fetchDashData(
      //     adminId, from, to, stateName, block, school);

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

  //To fetch form logs
  Future<List<dynamic>?> fetchFormLogs({required String adminId}) async {
    try {
      final online = await _isOnline();
      final logs = online
          ? await _dashRepository.fetchFormLogs(adminId)
          : await _dashRepository.fetchFormLogsOffline(adminId); // NEW
      // final logs = await _dashRepository.fetchFormLogs(adminId);
      return logs;
    } catch (e) {
      print('Cubit Error: $e');
      return null;
    }
  }
}
