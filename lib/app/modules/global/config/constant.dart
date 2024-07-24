import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConstants {
  static UserData? userData;

  static hideLoading(context) {
    Navigator.of(context).pop();
  }

  static LatLng latLng = const LatLng(30.033333, 31.233334);
  static showLoading(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5.0)),
            padding: const EdgeInsetsDirectional.all(50.0),
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          ),
        );
      },
    );
  }

  static String mapStyle = '''
  [
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#fef9e8"
        }
      ]
    },
    {
      "featureType": "landscape",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#f2f3f4"
        }
      ]
    },
      {
      "featureType": "poi",
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi.business",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "all",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#697579"
        }
      ]
    }
  ]
  ''';
  static loadUserFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      final userDataJson = jsonDecode(userDataString); // Use jsonDecode
      AppConstants.userData = UserData.fromJson(userDataJson);
      userToken = AppConstants.userData!.token;

      print('User loaded from cache: $userDataJson');
    }
  }
}
