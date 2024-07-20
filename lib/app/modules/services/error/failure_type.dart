import 'package:maryana/app/modules/global/config/log_utils.dart';

 import 'exceptions.dart';
import 'failures.dart';

class FailureType {
  static dynamic type(ServerException error) {
    Log.e("error ---- ${error.runtimeType} ---- ${error.message.toString() } ------ ${error.prefix.toString() }" );
    switch (error.runtimeType) {
      case DataInputException:
        return DataInputFailure(error.message);
      case UnauthorizedException:
        return UnauthorizedFailure(error.message);
      case CacheException:
        return CacheFailure();
      case NoInternetConnectionException:
        return NetworkFailure();
      case InternalServerErrorException:
        return const ServerFailure();
      default:
        return ServerFailure(error);
    }
  }
}
