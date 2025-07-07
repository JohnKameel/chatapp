abstract class Failure {
  final String message;

  Failure(this.message);
}

class DataBaseFailure extends Failure {
  DataBaseFailure(super.message);

  // factory ServerFailure.fromDioException(DioException e) {
  //   switch (e.type) {
  //     case DioExceptionType.connectionTimeout:
  //       return ServerFailure('Connection timeout, please try again later.');
  //     case DioExceptionType.sendTimeout:
  //       return ServerFailure('Send timeout, please try again later.');
  //     case DioExceptionType.receiveTimeout:
  //       return ServerFailure('Receive timeout, please try again later.');
  //     case DioExceptionType.badResponse:
  //       return ServerFailure('Received an invalid response from the server.');
  //     case DioExceptionType.cancel:
  //       return ServerFailure('Request was cancelled.');
  //     case DioExceptionType.unknown:
  //     default:
  //       return ServerFailure('An unknown error occurred: ${e.message}');
  //   }
  // }
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}