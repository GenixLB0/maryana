import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

import 'app/modules/onboarding/bindings/onboarding_binding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConstants.loadUserFromCache();
  fontFamilyBoldGlobal = GoogleFonts.bebasNeue().fontFamily;
  fontFamilyPrimaryGlobal = GoogleFonts.lato().fontFamily;
  fontFamilySecondaryGlobal = GoogleFonts.nunito().fontFamily;
  fontCormoantFont = GoogleFonts.cormorant().fontFamily;

  // GoogleFonts.cormorant
  Get.put(ApiService());
  ;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
        child: Observer(
            builder: (_) => FutureBuilder<Color>(
                future: getMaterialYouData(),
                builder: (_, snap) {
                  return ScreenUtilInit(
                      designSize: const Size(375, 812),
                      minTextAdapt: true,
                      splitScreenMode: true,
                      // Use builder only if you need to use library outside ScreenUtilInit context
                      builder: (_, child) {
                        return Observer(
                            builder: (_) => GetMaterialApp(
                                  title: APP_NAME,
                                  theme: AppTheme.lightTheme(color: snap.data),
                                  initialRoute: Routes.HOME,
                                  getPages: AppPages.routes,
                                ));
                      });
                })));
  }
}
