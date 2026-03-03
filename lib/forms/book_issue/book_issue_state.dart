


import 'package:equatable/equatable.dart';
import 'package:lib17000ft/models/book_issue/book_issue_model.dart';
import 'package:lib17000ft/models/book_return_model.dart/book_return_model.dart';

abstract class BookIssueState extends Equatable {
@override
  List<Object?> get props => [];
}

class BookIssueInitial extends BookIssueState {}

class BookIssueLoading extends BookIssueState {}
class BookIssueFailure extends BookIssueState {
  final String message;
  BookIssueFailure({required this.message});
}
class BookIssueSuccess extends BookIssueState {
  final String message;
  final String status;
  BookIssueSuccess({required this.message, required this.status});
}

class BookReturnListSuccess extends BookIssueState {
  final List<BookReturnModel>  bookReturnedList;
  final String? message;
  BookReturnListSuccess({required this.bookReturnedList,this.message});
}


class BookIssuedListSuccess extends BookIssueState {
  final List<BookIssueModel>  bookIssuedList;
  final String? message;
  BookIssuedListSuccess({required this.bookIssuedList,this.message});
}

class BookIssueRegistered extends BookIssueState {
  

  BookIssueRegistered();

}
