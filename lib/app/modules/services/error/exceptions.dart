 
class ServerException   implements Exception {
  final String? message;
  final String? prefix;

  const ServerException([this.message, this.prefix]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return '$message';
  }
}

class FetchDataException extends ServerException {
  const FetchDataException([message]) : super(message, "FetchDataException");
}

class BadRequestException extends ServerException {
  const BadRequestException([message]) : super("BadRequestException");
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException([message])
      : super(message, "UnauthorizedException");
}

class NotFoundException extends ServerException {
  const NotFoundException([message]) : super("NotFoundException");
}

class ConflictException extends ServerException {
  const ConflictException([message]) : super("ConflictException");
}

class DataInputException extends ServerException {
  const DataInputException([message]) : super(message, "DataInputException");
}

class InternalServerErrorException extends ServerException {
  const InternalServerErrorException([message])
      : super("InternalServerErrorException");
}

class NoInternetConnectionException extends ServerException {
  const NoInternetConnectionException([message])
      : super(message, "NoInternetConnectionException");
}

class CacheException implements Exception {}
