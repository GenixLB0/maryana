import 'dart:convert';

import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:nb_utils/nb_utils.dart';

class AppConstants {
  static UserData? userData;
  static loadUserFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      final userDataJson = jsonDecode(userDataString);
      AppConstants.userData = UserData.fromJson(userDataJson);
      userToken = AppConstants.userData!.token;

      print('User loaded from cache: ${userDataJson}');
    }
  }
}
