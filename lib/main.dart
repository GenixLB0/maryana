import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/main/views/main_view.dart';
import 'package:maryana/app/modules/onboarding/views/onboarding_view.dart';
import 'package:maryana/app/modules/services/api_consumer.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/app/modules/services/app_interceptors.dart';
import 'package:maryana/app/modules/services/dio_consumer.dart';
import 'package:maryana/app/modules/splash/bindings/splash_binding.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

final sl = GetIt.instance;
ApiConsumer apiConsumer = sl();
Future<void> init() async {
  try {
    //Core injections

    sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));

    //! External
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton(() => AppIntercepters());
    sl.registerLazySingleton(() => LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        error: true));
    sl.registerLazySingleton(() => Dio());
  } catch (error, stackTrace) {
    log('test error $stackTrace ');
  }
}

void _checkUserToken() async {
  if (userToken != null && userToken!.isNotEmpty) {
    // Navigate to the main screen
    print('test $userToken');
    Get.off(() => MainView());
  } else {
    print('test2 $userToken');

    navigateToOnboarding();
  }
}

void navigateToOnboarding() {
  Get.off(() => OnboardingView());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  await AppConstants.loadUserFromCache();
  Future.delayed(const Duration(milliseconds: 200))
      .then((_) => _checkUserToken());
  fontFamilyBoldGlobal = GoogleFonts.bebasNeue().fontFamily;
  fontFamilyPrimaryGlobal = GoogleFonts.lato().fontFamily;
  fontFamilySecondaryGlobal = GoogleFonts.nunito().fontFamily;
  // fontCormoantFont = GoogleFonts.cormorant().fontFamily;

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
                                  initialRoute: Routes.SPLASH,
                                  initialBinding: SplashBinding(),
                                  getPages: AppPages.routes,
                                ));
                      });
                })));
  }
}
