import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';

import 'package:maryana/app/modules/onboarding/views/onboarding_view.dart';
import 'package:maryana/app/modules/services/api_consumer.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/app/modules/services/app_interceptors.dart';
import 'package:maryana/app/modules/services/dio_consumer.dart';
import 'package:maryana/app/modules/splash/bindings/splash_binding.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app/modules/onboarding/controllers/onboarding_controller.dart';

import 'package:flutter/services.dart';

final sl = GetIt.instance;
ApiConsumer apiConsumer = sl();
bool isFlutterLocalNotificationsInitialized = false;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  showFlutterNotification(message!);

  if (message.data != null) {
    print('Message also contained a notification: ${message.data}');
  }
  // showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

Future<void> setupFlutterNotifications() async {
  print("teasdsadsa initialize ");
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: primaryColor,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        enableVibration: true,
        playSound: true,
        channelShowBadge: true,
        defaultRingtoneType: DefaultRingtoneType.Ringtone,
      ),
    ],
  );

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
}

Future<void> init() async {
  try {
    //Core injections
    await Firebase.initializeApp();
    setupFlutterNotifications();
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

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      showFlutterNotification(message);
    } as void Function(RemoteMessage event)?);
  } catch (error, stackTrace) {
    print('test error $stackTrace ');
  }
}

void showFlutterNotification(RemoteMessage message) {
  var notification = message.data;

  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');
  if (message.notification != null) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: message.notification!.title, // title
      displayOnForeground: true,
      displayOnBackground: true,
      color: primaryColor,
      body: message.notification!.body.toString(), // body
    ));
    print(" test notification2" + message.notification!.title.toString());
  }

  if (message.data != null) {
    print('Message also contained a notification: ${message.data}');
  }
}

void navigateToOnboarding() {
  Get.lazyPut(() => OnboardingController());
  Get.off(() => OnboardingView());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  await AppConstants.loadUserFromCache();

  // GoogleFonts.cormorant().fontFamily = GoogleFonts.cormorant().fontFamily;

  // GoogleFonts.cormorant
  Get.put(ApiService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
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
                              initialRoute: Routes.SPLASH,
                              initialBinding: SplashBinding(),
                              getPages: AppPages.routes,
                            ));
                  });
            }));
  }
}
