import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/forms/book_issue/book_issue_state.dart';
import 'package:lib17000ft/models/book_issue/book_issue_model.dart';
import 'package:lib17000ft/models/book_return_model.dart/book_return_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../configs/app_urls.dart';
import '../../models/student_registration/student_model.dart';
import 'book_issue_repository.dart';



class BookIssueCubit extends Cubit<BookIssueState> {
  BookIssueCubit() : super(BookIssueInitial());
  final BookIssueRepository _bookIssueRepository = BookIssueRepository();
  bool _isLoading = false;  // Flag to prevent multiple simultaneous requests
  int _page = 1; // For pagination, assuming 1 as the starting page
  bool _hasMoreData = true; // Flag to check if there's more data

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }


  // MODIFICATION 1: Update the method signature to accept 'status'
  // void bookIssueReturn(dynamic bookIssueReturn, String status) async {
  //   emit(BookIssueLoading());
  //   // The Future.delayed is for simulation and can be removed if not needed.
  //   await Future.delayed(const Duration(seconds: 1));
  //   try {
  //     final value = await _bookIssueRepository.bookIssueReturn(bookIssueReturn);
  //
  //     // 1. Check if the response itself is null
  //     if (value == null) {
  //       emit(BookIssueFailure(message: "Invalid response from server"));
  //       return;
  //     }
  //
  //     // 2. Handle Error cases (Check for true or 1)
  //     if (value['error'] == true || value['error'] == 1 || value['error'] == "true") {
  //       print('API Error: ${value['message']}');
  //       emit(BookIssueFailure(message: value['message']?.toString() ?? "Unknown error occurred"));
  //     }
  //     // 3. Handle Success cases (Check for false or 0)
  //     else if (value['error'] == false || value['error'] == 0 || value['error'] == "false") {
  //       print('API Success');
  //       emit(BookIssueSuccess(
  //           message: value['message']?.toString() ?? "Operation successful",
  //           status: status
  //       ));
  //     } else {
  //       emit(BookIssueFailure(message: "Unexpected response status"));
  //     }
  //   } catch (error) {
  //     print("Cubit Catch Error: $error");
  //
  //     // Clean up the error message (remove "Exception: " or "Custom Error: ")
  //     String errorMessage = error.toString()
  //         .replaceAll("Exception:", "")
  //         .replaceAll("Custom Error:", "")
  //         .trim();
  //
  //     emit(BookIssueFailure(message: errorMessage));
  //   }
  //   // try {
  //   //   final value = await _bookIssueRepository.bookIssueReturn(bookIssueReturn);
  //   //
  //   //   if (value!['error'] == true || value['error'] == 1) {
  //   //     print('this is value message ${value['message']}');
  //   //
  //   //     emit(BookIssueFailure(message: value['message'].toString()));
  //   //   } else if(value['error'] == false || value['error'] == 0  ) {
  //   //     print('sucess for ${value!['error']}' );
  //   //     // MODIFICATION 2: Pass the 'status' to the success state
  //   //     emit(BookIssueSuccess(message: value['message'].toString(), status: status));
  //   //   }
  //   // } catch (error) {
  //   //   emit(BookIssueFailure(message: error.toString()));
  //   //   print(error);
  //   // }
  //   // This emit seems redundant and might cause issues in the UI.
  //   // Consider removing it if it's not handled specifically in your BlocConsumer.
  //   // emit(BookIssueRegistered());
  // }

  void bookIssueReturn(dynamic bookIssueReturn, String status) async {
    emit(BookIssueLoading());
    try {
      final online = await _isOnline();

      final Map<String, dynamic> value;
      if (online) {
        final apiResult = await _bookIssueRepository.bookIssueReturn(bookIssueReturn);
        value = {"error": apiResult['error'], "message": apiResult['message']};
      } else {
        // NEW — offline path expects a Map, not multipart form data
        final data = bookIssueReturn as Map<String, dynamic>;
        value = await _bookIssueRepository.bookIssueReturnOffline(
          isbn: data['isbn'].toString(),
          title: data['title'].toString(),
          rollno: data['student_id'].toString(),
          status: status,
          createdBy: int.tryParse(data['created_by']?.toString() ?? '') ?? 0,
          level: data['level']?.toString(),
          language: data['language']?.toString(),
          localCoverPagePath: data['cover_page']?.toString(),
        );
      }

      if (value['error'] == true || value['error'] == 1) {
        emit(BookIssueFailure(message: value['message'].toString()));
      } else {
        emit(BookIssueSuccess(message: value['message'].toString(), status: status));
      }
    } catch (error) {
      emit(BookIssueFailure(message: error.toString()));
    }
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
        if (value['error'] == true || value['error'] == 1) {
          print('this is failed for fetch return ${value['error']}');
          emit(BookIssueFailure(message: value['message'].toString()));
        } else if (value['error'] == false || value['error'] == 0) {
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

  // Future<void> fetchBookIssued({
  //   required dynamic adminId,
  //   String? stateName,
  //   String? district,
  //   String? block,
  //   String? school,
  //   String? from,
  //   String? to,
  //   String? level,
  //   String? language
  // }) async {
  //   if (_isLoading || !_hasMoreData) return;  // Prevent multiple simultaneous requests
  //   _isLoading = true;
  //   emit(BookIssueLoading()); // Show loading state
  //
  //   await Future.delayed(const Duration(seconds: 1)); // Simulating API call
  //
  //   try {
  //     final value = await _bookIssueRepository.getIssuedBook(adminId,stateName,district,block,school,from,to,level,language, page: _page) ;  // Pass page number to API
  //
  //     if (value is Map<String, dynamic>) {
  //       if (value['error'] == true) {
  //         emit(BookIssueFailure(message: value['message'].toString()));
  //       } else if (value['error'] == false) {
  //         List<BookIssueModel> bookReturn = (value['data'] as List)
  //             .map((student) => BookIssueModel.fromJson(student))
  //             .toList();
  //
  //         _hasMoreData = value['data'].length > 0;
  //
  //         if (_hasMoreData) {
  //           _page++;
  //         }
  //
  //         emit(BookIssuedListSuccess(bookIssuedList: bookReturn, message: value['message'].toString()));
  //       }
  //     } else {
  //       emit(BookIssueFailure(message: 'Unexpected response format'));
  //     }
  //   } catch (error) {
  //     emit(BookIssueFailure(message: error.toString()));
  //   } finally {
  //     _isLoading = false; // Reset loading flag
  //   }
  // }
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
    // Prevent multiple requests
    if (_isLoading) return;

    _isLoading = true;
    emit(BookIssueLoading());

    try {
      final value = await _bookIssueRepository.getIssuedBook(
          adminId,
          stateName,
          district,
          block,
          school,
          from,
          to,
          level,
          language,
          page: _page
      );

      if (value == null) {
        emit(BookIssueFailure(message: "Empty response from server"));
        return;
      }

      // Check for Error status (matching your response: "error": false)
      if (value['error'] == true || value['error'] == 1) {
        _hasMoreData = false;
        emit(BookIssueFailure(message: (value['message'] ?? "No Record Found").toString()));
      }
      else if (value['error'] == false || value['error'] == 0) {
        final dynamic rawData = value['data'];

        if (rawData is List) {
          List<BookIssueModel> parsedList = [];

          for (var item in rawData) {
            try {
              // Parse each individual item using the model
              parsedList.add(BookIssueModel.fromJson(item as Map<String, dynamic?>));
            } catch (e) {
              print("Error parsing individual record: $e");
              continue; // Skip bad records
            }
          }

          // Update pagination status based on whether we got data
          _hasMoreData = rawData.isNotEmpty;
          if (_hasMoreData) {
            _page++;
          }

          // Emit success ONCE after the loop is finished
          emit(BookIssuedListSuccess(
              bookIssuedList: parsedList,
              message: (value['message'] ?? "Success").toString()
          ));
        } else {
          emit(BookIssueFailure(message: "Invalid data format received"));
        }
      }
    } catch (error) {
      print("Cubit Error: $error");
      emit(BookIssueFailure(message: "Data formatting error: $error"));
    } finally {
      _isLoading = false;
    }
  }

  Future<List<StudentModel>> fetchStudentByRollno(String rollno) async {
    try {
      final url = Uri.parse(AppUrls.studentDetailApi);

      final response = await http.post(
        url,
        body: {
          "action": 'get',
          "rollno": rollno

        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['error'] == false) {
          List dataList = jsonData['student'];

          return dataList
              .map((e) => StudentModel.fromJson(e))
              .toList();
        } else {
          throw Exception(jsonData['message']);
        }
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error: $e");
    }
  }
  // Future<List<StudentModel>> fetchStudentByRollno(String rollno) async {
  //   try {
  //     final url = Uri.parse(AppUrls.studentDetailApi);
  //
  //     final response = await http.post(
  //       url,
  //       body: {
  //         "action": "get",
  //         "rollno": rollno
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);
  //
  //       if (jsonData['error'] == "false") {
  //         List dataList = jsonData['student'] ?? [];
  //
  //         // ✅ CHECK FOR THE "NA" RECORD FROM YOUR PHP
  //         // If the first record has id == 'NA', it means no student was found.
  //         if (dataList.isNotEmpty && dataList[0]['id'] == 'NA') {
  //           return []; // Return empty list to signify no real student found
  //         }
  //
  //         return dataList
  //             .map((e) => StudentModel.fromJson(e))
  //             .toList();
  //       } else {
  //         throw Exception(jsonData['message'] ?? "API Error");
  //       }
  //     } else {
  //       throw Exception("Server Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     // Re-throw the error so the UI catch block handles it
  //     throw Exception(e.toString());
  //   }
  // }

  // Future<http.Response> insertBook(
  //     Map<String, dynamic> payload,
  //     ) async {
  //   try {
  //
  //     final url = Uri.parse(AppUrls.bookAdd);
  //
  //     final response = await http.post(
  //       url,
  //       body: payload,
  //     );
  //
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<void> insertBook(
  //     Map<String, dynamic> bookData,
  //     ) async {
  //   emit(BookIssueLoading());
  //
  //   try {
  //     // final url = Uri.parse(
  //     //   'https://demo.library.17000ft.org/api/library/insert_book',
  //     // );
  //     final url = Uri.parse(AppUrls.bookAdd);
  //
  //     debugPrint('================================');
  //     debugPrint('INSERT BOOK URL: $url');
  //     debugPrint('INSERT BOOK DATA: $bookData');
  //     debugPrint('================================');
  //
  //     final response = await http.post(
  //       url,
  //       body: bookData.map(
  //             (key, value) => MapEntry(key, value.toString()),
  //       ),
  //     );
  //
  //     debugPrint('STATUS CODE: ${response.statusCode}');
  //     debugPrint('RESPONSE: ${response.body}');
  //
  //     // Your existing success/failure handling...
  //   } catch (e, stackTrace) {
  //     debugPrint('INSERT BOOK ERROR: $e');
  //     debugPrint('$stackTrace');
  //
  //     emit(
  //       BookIssueFailure(
  //         message: e.toString(),
  //       ),
  //     );
  //   }
  // }


  Future<void> insertBook(
      Map<String, dynamic> bookData,
      ) async {
    emit(BookIssueLoading());

    try {
      final url = Uri.parse(AppUrls.bookAdd);

      debugPrint('================================');
      debugPrint('INSERT BOOK URL: $url');
      debugPrint('INSERT BOOK DATA: $bookData');
      debugPrint('================================');

      final response = await http.post(
        url,
        body: bookData.map(
              (key, value) => MapEntry(
            key,
            value.toString(),
          ),
        ),
      );

      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE: ${response.body}');

      // HTTP error
      if (response.statusCode < 200 || response.statusCode >= 300) {
        emit(
          BookIssueFailure(
            message: 'Server error: ${response.statusCode}',
          ),
        );
        return;
      }

      // Decode API response
      final responseData = jsonDecode(response.body);

      debugPrint('DECODED RESPONSE: $responseData');

      // API error
      if (responseData['error'] == true ||
          responseData['error'] == 1 ||
          responseData['error'] == 'true') {
        emit(
          BookIssueFailure(
            message: responseData['message']?.toString() ??
                'Failed to insert book',
          ),
        );
        return;
      }

      // API success
      if (responseData['error'] == false ||
          responseData['error'] == 0 ||
          responseData['error'] == 'false') {
        emit(
          BookIssueSuccess(
            message: responseData['message']?.toString() ??
                'Book inserted successfully',
            status: 'Inserted',
          ),
        );
        return;
      }

      // Unexpected response
      emit(
        BookIssueFailure(
          message: 'Unexpected response from server',
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('INSERT BOOK ERROR: $e');
      debugPrint('$stackTrace');

      emit(
        BookIssueFailure(
          message: e.toString(),
        ),
      );
    }
  }

}
