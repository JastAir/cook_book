import 'dart:io';

enum ExceptionType {
  all,
  bad_responce,
}

class LogManager {
  static Exception exception(String message,
      {ExceptionType type = ExceptionType.all}) {
    return Exception(
        "[${type.toString()}] $pid:[${StackTrace.current}] $message");
  }
}
