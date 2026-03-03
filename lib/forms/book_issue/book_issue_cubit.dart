import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/forms/book_issue/book_issue_state.dart';
import 'package:lib17000ft/models/book_issue/book_issue_model.dart';
import 'package:lib17000ft/models/book_return_model.dart/book_return_model.dart';

import '../../configs/app_urls.dart';
import 'book_issue_repository.dart';



class BookIssueCubit extends Cubit<BookIssueState> {
  BookIssueCubit() : super(BookIssueInitial());
  final BookIssueRepository _bookIssueRepository = BookIssueRepository();
  bool _isLoading = false;  // Flag to prevent multiple simultaneous requests
  int _page = 1; // For pagination, assuming 1 as the starting page
  bool _hasMoreData = true; // Flag to check if there's more data


  // MODIFICATION 1: Update the method signature to accept 'status'
  void bookIssue(dynamic bookIssue, String status) async {
    emit(BookIssueLoading());
    // The Future.delayed is for simulation and can be removed if not needed.
    await Future.delayed(const Duration(seconds: 1));
    try {
      final value = await _bookIssueRepository.bookIssue(bookIssue);

      if (value!['error'] == true || value['error'] == 1) {
        print('this is value message ${value['message']}');

        emit(BookIssueFailure(message: value['message'].toString()));
      } else if(value['error'] == false || value['error'] == 0  ) {
        print('sucess for ${value!['error']}' );
        // MODIFICATION 2: Pass the 'status' to the success state
        emit(BookIssueSuccess(message: value['message'].toString(), status: status));
      }
    } catch (error) {
      emit(BookIssueFailure(message: error.toString()));
      print(error);
    }
    // This emit seems redundant and might cause issues in the UI.
    // Consider removing it if it's not handled specifically in your BlocConsumer.
    // emit(BookIssueRegistered());
  }

  Future<void> fetchBookReturned({
    required dynamic adminId,
    String? stateName,
    String? district,
    String? block,
    String? school,
    String? from,
    String? to,
    String? level,
    String? language
  }) async {
    if (_isLoading || !_hasMoreData) return;  // Prevent multiple simultaneous requests
    _isLoading = true;
    emit(BookIssueLoading()); // Show loading state

    await Future.delayed(const Duration(seconds: 1)); // Simulating API call

    try {
      final value = await _bookIssueRepository.getBookReturn(adminId,stateName,district,block,school,from,to,level,language, page: _page,);  // Pass page number to API

      if (value is Map<String, dynamic>) {
        if (value['error'] == 1) {
          print('this is failed for fetch return ${value['error']}');
          emit(BookIssueFailure(message: value['message'].toString()));
        } else if (value['error'] == 0) {
          print('this is success for fetch return ${value['error']}');
          List<BookReturnModel> bookReturn = (value['data'] as List)
              .map((student) => BookReturnModel.fromJson(student))
              .toList();

          _hasMoreData = value['data'].length > 0;

          if (_hasMoreData) {
            _page++;
          }

          emit(BookReturnListSuccess(bookReturnedList: bookReturn, message: value['message'].toString()));
        }
      } else {
        emit(BookIssueFailure(message: 'Unexpected response format'));
      }
    } catch (error) {
      emit(BookIssueFailure(message: error.toString()));
    } finally {
      _isLoading = false; // Reset loading flag
    }
  }

  Future<void> fetchBookIssued({
    required dynamic adminId,
    String? stateName,
    String? district,
    String? block,
    String? school,
    String? from,
    String? to,
    String? level,
    String? language
  }) async {
    if (_isLoading || !_hasMoreData) return;  // Prevent multiple simultaneous requests
    _isLoading = true;
    emit(BookIssueLoading()); // Show loading state

    await Future.delayed(const Duration(seconds: 1)); // Simulating API call

    try {
      final value = await _bookIssueRepository.getIssuedBook(adminId,stateName,district,block,school,from,to,level,language, page: _page) ;  // Pass page number to API

      if (value is Map<String, dynamic>) {
        if (value['error'] == 1) {
          emit(BookIssueFailure(message: value['message'].toString()));
        } else if (value['error'] == 0) {
          List<BookIssueModel> bookReturn = (value['data'] as List)
              .map((student) => BookIssueModel.fromJson(student))
              .toList();

          _hasMoreData = value['data'].length > 0;

          if (_hasMoreData) {
            _page++;
          }

          emit(BookIssuedListSuccess(bookIssuedList: bookReturn, message: value['message'].toString()));
        }
      } else {
        emit(BookIssueFailure(message: 'Unexpected response format'));
      }
    } catch (error) {
      emit(BookIssueFailure(message: error.toString()));
    } finally {
      _isLoading = false; // Reset loading flag
    }
  }

}
