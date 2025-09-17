
class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return (_prefix != null ? '$_prefix: ' : '') + (_message ?? ''); //return a formatted message
  }
}

// Custom Exceptions
class NoInternetException extends AppException {
  NoInternetException([String? message]) : super(message, 'No Internet Connection');
}

class FormatException extends AppException {
  FormatException([String? message]) : super(message, 'Invalid Format');
}

class RangeErrorException extends AppException {
  RangeErrorException([String? message]) : super(message, 'Index Out of Range');
}

class ArgumentException extends AppException {
  ArgumentException([String? message]) : super(message, 'Invalid Argument');
}

class TypeException extends AppException {
  TypeException([String? message]) : super(message, 'Type Mismatch');
}

class StateException extends AppException {
  StateException([String? message]) : super(message, 'Invalid State');
}

class FlutterErrorException extends AppException {
  FlutterErrorException([String? message]) : super(message, 'Flutter Error');
}

class TimeoutException extends AppException {
  TimeoutException([String? message]) : super(message, 'Request Timed Out');
}

class SocketException extends AppException {
  SocketException([String? message]) : super(message, 'Network Error');
}

class HttpException extends AppException {
  HttpException([String? message]) : super(message, 'Error');
}

class ClientException extends AppException {
  ClientException([String? message]) : super(message, 'Client Error');
}

class PlatformException extends AppException {
  PlatformException([String? message]) : super(message, 'Error:');
}

class DatabaseException extends AppException {
  DatabaseException([String? message]) : super(message, 'Database Error');
}

class FileSystemException extends AppException {
  FileSystemException([String? message]) : super(message, 'File System Error');
}

class CustomException extends AppException {
  CustomException([String? message]) : super(message, 'Custom Error');
}

//Specifica error 401
class UnauthorizedException extends AppException {
  UnauthorizedException([String? message]) : super(message, 'Unauthorized User');
}

// Specific HttpException for 404 Not Found
class NotFoundException extends HttpException {
  NotFoundException([String? message]) : super(message ?? 'Resource Not Found',);
}
