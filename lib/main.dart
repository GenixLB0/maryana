import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/src/client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:maryana/app/modules/cart/bindings/cart_binding.dart';
import 'package:maryana/app/modules/cart/controllers/cart_controller.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/product/bindings/product_binding.dart';
import 'package:maryana/app/modules/product/controllers/product_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:maryana/app/modules/onboarding/views/onboarding_view.dart';
import 'package:maryana/app/modules/services/api_consumer.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/app/modules/services/app_interceptors.dart';
import 'package:maryana/app/modules/services/dio_consumer.dart';
import 'package:maryana/app/modules/splash/bindings/splash_binding.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restart_app/restart_app.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'app/modules/global/model/test_model_response.dart';
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
      title: message.notification!.title,
      // title
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
  await Firebase.initializeApp();

  // Initialize App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );

  // GoogleFonts.cormorant().fontFamily = GoogleFonts.cormorant().fontFamily;

  // GoogleFonts.cormorant
  Get.put(ApiService());
  await _handleUri();
  if (kReleaseMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://0ac95cbdab209d9255978250ef6e9e29@o4507944885813248.ingest.us.sentry.io/4507944887123968';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 0.01;
        // The sampling rate for profiling is relative to tracesSampleRate
        // Setting to 1.0 will profile 100% of sampled transactions:
      },
      appRunner: () => runApp(MyApp()),
    );
  } else {
    runApp(MyApp());
  }
}

var clothingType = "";

bool isDeepLink = false;
bool isCart = false;
ViewProductData? deepLinkproduct;

_handleUri() {
  final _appLinks = AppLinks(); // AppLinks is singleton
  // Subscribe to all events (initial link and further)
  _appLinks.uriLinkStream.listen((uri) {
// Do something (navigation, ...)
    if (uri.path == '/cart/' && uri.queryParameters.isNotEmpty) {
      isCart = true;
      print('test code magic');
      _processDeepLink(uri);
    } else {
      print("deep link ${uri}");
      var id = uri.queryParameters["id"];
      print("deep link ${id}");
      isDeepLink = true;
      if (id == null) {
        isDeepLink = false;
      } else {
        deepLinkproduct = ViewProductData(id: int.parse(id));
      }
      isDeepLink = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offNamed(
          Routes.PRODUCT,
          arguments: deepLinkproduct,
        );
      });
    }
  });
}

List<ViewProductData> cartShareProducts = [];

void _processDeepLink(Uri deepLinkUri) async {
  String products = deepLinkUri.queryParameters['products'] ?? '';
  cartShareProducts.clear();
  // Split each product by commas
  List<String> productDetails = products.split(',');
  final CartController cartController = Get.put(CartController());
  final ProductController productController = Get.put(ProductController());
  // List to hold all the async operations
  List<Future<void>> futures = [];

  for (String productDetail in productDetails) {
    // Each productDetail contains id, size, and color, e.g., "59-XXXL-Pink"
    List<String> details = productDetail.split('-');
    if (details.length == 3) {
      String id = details[0];
      String size = details[1];
      String color = details[2];

      // Add the async operation to the list
      futures.add(productController.getProduct(id).then((_) {
        var product = productController.product.value;
        product.selectedSize = size;
        product.selectedColor = color;

        cartShareProducts.add(product);
      }));
    }
  }

  // Wait for all async operations to complete
  await Future.wait(futures);
  await Future.delayed(const Duration(milliseconds: 700));
  // After all products are added, navigate to the CART route
  if (Platform.isAndroid) {
    Get.offNamed(Routes.CART);
  } else {
    Get.toNamed(Routes.CART);
  }
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
                    return Platform.isAndroid
                        ? Observer(
                            builder: (_) => GetMaterialApp(
                                  debugShowCheckedModeBanner: false,
                                  useInheritedMediaQuery: true,
                                  title: APP_NAME,
                                  theme: AppTheme.lightTheme(color: snap.data),
                                  initialRoute: isDeepLink && isCart == false
                                      ? Routes.PRODUCT
                                      : isDeepLink == false && isCart
                                          ? Routes.CART
                                          : Routes.SPLASH,
                                  initialBinding: isDeepLink && isCart == false
                                      ? ProductBinding()
                                      : isDeepLink == false && isCart
                                          ? CartBinding()
                                          : SplashBinding(),
                                  getPages: AppPages.routes,
                                ))
                        : Observer(
                            builder: (_) => GetMaterialApp(
                                  debugShowCheckedModeBanner: false,
                                  useInheritedMediaQuery: true,
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

class NoInternetView extends StatefulWidget {
  const NoInternetView({super.key});

  @override
  State<NoInternetView> createState() => _NoInternetViewState();
}

class _NoInternetViewState extends State<NoInternetView> {
  bool isLoading = false;
  bool isTicker = true;

  @override
  void initState() {
    networkChecker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TickerMode(
      enabled: isTicker,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Lottie.asset(
                "assets/images/no_intenet.json",
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'No Internet Connection',
                style: primaryTextStyle(size: 20, weight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? CircularProgressIndicator(
                      backgroundColor: primaryColor,
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (mounted) {
                          isLoading = true;
                          setState(() {});
                        }

                        Future.delayed(const Duration(seconds: 1), () async {
                          await Connectivity()
                              .checkConnectivity()
                              .then((value) async {
                            if (value.first == ConnectivityResult.none) {
                              if (mounted) {
                                isLoading = false;
                                setState(() {});
                              }
                            } else {
                              await Get.closeCurrentSnackbar();
                              Get.offAllNamed(Routes.SPLASH);
                            }
                          });
                        });
                      },
                      child: Text(
                        'Retry',
                        style: primaryTextStyle(),
                      )),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> networkChecker() async {
    await Connectivity().checkConnectivity().then((value) async {
      if (value.first == ConnectivityResult.none) {
      } else {
        isTicker = false;
        await Get.closeCurrentSnackbar();
      }
    });
  }
}
