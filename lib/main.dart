import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Transparent status bar
    statusBarBrightness: Brightness.dark, // Dark text for status bar
  ));

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Maryana",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
theme: ThemeData(
  fontFamily: "Cormorant"
),

    ),


  );

}
