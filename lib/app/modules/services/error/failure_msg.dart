import 'dart:convert';

import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/config/log_utils.dart';

import 'error_auth.dart';
import 'failures.dart';
 

class FailureMsg {
  static String mapFailureToMsg(Failure failure) {
    print('sdasdsadsad');
    Log.e(
        "failure ---- ${failure.runtimeType} ---- ${failure.message.toString()}");
    switch (failure.runtimeType) {
      case DataInputFailure:
        final jsonError = json.decode(failure.message.toString());
        if (jsonError["errors"] == null) {
          print('test error');
          return jsonError['message'].toString();
        } else {
          print('test error2');
          AuthError authError = AuthError.fromJson(jsonError);
          String error = '';
          if (authError.errors?.email != null) {
            error = "$error${authError.errors!.email}\n";
          }
          if (authError.errors?.mobile != null) {
            error = "$error${authError.errors!.mobile}\n";
          }
          if (authError.errors?.name != null) {
            error = "$error${authError.errors!.name}\n";
          }
          if (authError.errors?.password != null) {
            error = "$error${authError.errors!.password}\n";
          }
          if (authError.errors?.image != null) {
            error = "$error${authError.errors!.image}";
          }
          if (authError.errors?.file != null) {
            error = "$error${authError.errors!.file}";
          }
          if (authError.errors?.optionId != null) {
            error = "$error${authError.errors!.optionId}";
          }
          if (authError.errors?.workingDays != null) {
            error = "$error${authError.errors!.workingDays}";
          }

          return error.toString();
        }
      case UnauthorizedFailure:
        return unAuthorizedFailure;
      case ServerFailure:
        return serverFailure;
      case CacheFailure:
        return cacheFailure;
      case NetworkFailure:
        return networkError;

      default:
        return unexpectedError;
    }
  }
}
