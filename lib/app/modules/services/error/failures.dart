 
abstract class Failure {
  final String? message;

  const Failure([this.message]);
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([message]) : super(message);
}

class DataInputFailure extends Failure {
  const DataInputFailure([message]) : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([message]) : super(message);
}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}
