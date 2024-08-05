import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/home/views/home_view.dart';
import 'package:maryana/app/modules/main/bindings/main_binding.dart';
import 'package:maryana/app/modules/main/views/main_view.dart';
import 'package:maryana/app/modules/onboarding/views/onboarding_view.dart';
import 'package:maryana/app/modules/product/bindings/product_binding.dart';
import 'package:maryana/app/modules/product/views/product_view.dart';
import 'package:maryana/app/modules/services/api_consumer.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/app/modules/services/app_interceptors.dart';
import 'package:maryana/app/modules/services/dio_consumer.dart';
import 'package:maryana/app/modules/shop/views/shop_view.dart';
import 'package:maryana/app/modules/splash/bindings/splash_binding.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:uni_links/uni_links.dart';

import 'app/modules/onboarding/controllers/onboarding_controller.dart';

import 'app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter/services.dart';

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

void navigateToOnboarding() {
  Get.lazyPut(() => OnboardingController());
  Get.off(() => OnboardingView());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _handleUri();
  await init();

  await AppConstants.loadUserFromCache();

  fontFamilyBoldGlobal = GoogleFonts.bebasNeue().fontFamily;
  fontFamilyPrimaryGlobal = GoogleFonts.lato().fontFamily;
  fontFamilySecondaryGlobal = GoogleFonts.nunito().fontFamily;
  // GoogleFonts.cormorant().fontFamily = GoogleFonts.cormorant().fontFamily;

  // GoogleFonts.cormorant
  Get.put(ApiService());

  runApp(MyApp());
}

bool isDeepLink = false;
ViewProductData? deepLinkproduct;

_handleUri() {
  final _appLinks = AppLinks(); // AppLinks is singleton
  // Subscribe to all events (initial link and further)
  _appLinks.uriLinkStream.listen((uri) {
// Do something (navigation, ...)
    print("deep link ${uri}");
    var id = uri.queryParameters["id"];
    print("deep link ${id}");
    isDeepLink = true;
    deepLinkproduct = ViewProductData(id: id.toInt(defaultValue: 1));

    // Get.toNamed(
    //   Routes.PRODUCT,
    //   arguments: ViewProductData(
    //     id: 1,
    //   ),
    // );
  });
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
                                  debugShowCheckedModeBanner: false,
                                  title: APP_NAME,
                                  theme: AppTheme.lightTheme(color: snap.data),
                                  initialRoute: isDeepLink
                                      ? Routes.PRODUCT
                                      : Routes.SPLASH,
                                  initialBinding: isDeepLink
                                      ? ProductBinding()
                                      : SplashBinding(),
                                  getPages: AppPages.routes,
                                ));
                      });
                })));
  }
}
