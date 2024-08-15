import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/auth/views/login_view.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/main/views/main_view.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/main.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as authTest;

import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var isGuest = false.obs;
  var confirmPasswordError = ''.obs;
  var isLoading = false.obs;
  var socialView = false.obs;
  var user = Rxn<User>();
  var firstNameError = ''.obs;
  var lastNameError = ''.obs;
  var googleSignIn = GoogleSignIn();

  authTest.FirebaseAuth auth = authTest.FirebaseAuth.instance;

  // Existing methods...

  Future<void> googleLogin() async {
    try {
      isLoading.value = true;

      // Step 1: Initiate the Google Sign-In process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in process
        isLoading.value = false;
        print('User canceled the Google Sign-In process');
        return;
      }

      // Step 2: Retrieve the authentication details
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Step 3: Retry authentication if idToken is null
      if (googleAuth.idToken == null) {
        googleAuth = await googleUser.authentication;
      }

      // Step 4: Check if idToken is available
      if (googleAuth.idToken != null) {
        final providerToken = googleAuth.idToken;

        // Step 5: Create a credential with the Google auth details
        final authTest.OAuthCredential credential =
            authTest.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Step 6: Sign in with the credential
        final authTest.UserCredential userCredential =
            await auth.signInWithCredential(credential);

        // Step 7: Extract user information
        email.value = userCredential.user!.email ?? '';
        firstName.value = userCredential.user!.displayName ?? '';
        lastName.value = ''; // Adjust as needed

        // Step 8: Call the loginWithGoogle method with the provider token
        loginWithGoogle(providerToken!);
      } else {
        // Step 9: Handle the error when idToken is null
        print(
            'Failed to retrieve idToken. The Google Sign-In might have failed.');
        // You can also show a Snackbar or AlertDialog to inform the user
        Get.snackbar(
            'Error', 'Failed to sign in with Google. Please try again.');
      }
    } catch (e, stackTrace) {
      // Step 10: Catch and handle any errors during the process
      isLoading.value = false;
      print("Google Login Failed: $e\n$stackTrace");
      // You can also show a Snackbar or AlertDialog to inform the user
      Get.snackbar('Error',
          'An error occurred during Google Sign-In. Please try again.');
    } finally {
      // Ensure that isLoading is set to false when the process is complete
      isLoading.value = false;
    }
  }

  static const String emptyFirstNameError = 'First name required!';
  static const String emptyLastNameError = 'Last name required!';
  static const String invalidEmailError = 'Enter a valid email';
  static const String shortPasswordError =
      'Password must be at least 6 characters';
  static const String passwordMismatchError = 'Passwords do not match';

  ApiService apiService = Get.find();

  Future<void> RequestIOSNotifications() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        messaging = FirebaseMessaging.instance;
        messaging!.getToken().then((value) {
          print('token fcm ' + value.toString());
          fcmToken = value.toString();
          //PushToken(value!);
          // addTokenToDatabase(userData!.fullName ?? '', value!);
        });
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  String fcmToken = '';

  FirebaseMessaging? messaging;

  @override
  void onInit() {
    super.onInit();
    RequestIOSNotifications();
    messaging = FirebaseMessaging.instance;
    messaging!.getToken().then((value) {
      print('token fcm ' + value.toString());
      fcmToken = value.toString();
      //PushToken(value!);
      // addTokenToDatabase(userData!.fullName ?? '', value!);
    });
    socialView.value = true;
  }

  bool validateEmail() {
    if (!GetUtils.isEmail(email.value)) {
      emailError.value = invalidEmailError;
      return false;
    }
    emailError.value = '';
    return true;
  }

  bool validatePassword() {
    if (password.value.length < 6) {
      passwordError.value = shortPasswordError;
      return false;
    }
    passwordError.value = '';
    return true;
  }

  bool validateConfirmPassword() {
    if (confirmPassword.value != password.value) {
      confirmPasswordError.value = passwordMismatchError;
      return false;
    }
    confirmPasswordError.value = '';
    return true;
  }

  bool validateFirstName() {
    if (firstName.value.isEmpty) {
      firstNameError.value = emptyFirstNameError;
      return false;
    }
    firstNameError.value = '';
    return true;
  }

  bool validateLastName() {
    if (lastName.value.isEmpty) {
      lastNameError.value = emptyLastNameError;
      return false;
    }
    lastNameError.value = '';
    return true;
  }

  void loginWithGoogle(String providerToken) async {
    // Validate that all required data is available
    if (validateEmail()) {
      isLoading.value = true;
      globalController.errorMessage.value = '';

      var formData = dio.FormData.fromMap({
        'provider_token': providerToken,
        'email': email.value,
        'first_name': firstName.value,
        'last_name': lastName.value,
        'imei': '1234', // Example IMEI, adjust as needed
        'device_token': fcmToken, // FCM token for push notifications
        'device_type': 'ios', // Change to 'android' if applicable
      });

      try {
        final response = await apiConsumer.post(
          'login/google', // Adjust the endpoint as needed
          formDataIsEnabled: true,
          formData: formData,
        );

        final apiResponse = ApiResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Login successful');
          isGuest.value = false;

          await cacheUserData(apiResponse.data!);
          AppConstants.userData = apiResponse.data!;
          user.value = apiResponse.data!.user;
          userToken = AppConstants.userData!.token;

          Get.offNamedUntil(Routes.MAIN, (Route) => false);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Login failed: ${response.statusMessage}');
        }
        isLoading.value = false;
      } catch (e, stackTrace) {
        isGuest.value = false;
        isLoading.value = false;

        print('Login failed: $e $stackTrace');
        final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));
        handleApiErrorUser(apiResponse.message);
        print(e.toString() + stackTrace.toString());
      }
    }
  }

  void clearFields() {
    email.value = '';
    password.value = '';
    confirmPassword.value = '';
    firstName.value = '';
    lastName.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    firstNameError.value = '';
    lastNameError.value = '';
  }

  void register() async {
    bool isValid = validateFirstName() &
        validateLastName() &
        validateEmail() &
        validatePassword() &
        validateConfirmPassword();
    if (isValid) {
      isLoading.value = true;
      globalController.errorMessage.value = '';
      var formData = dio.FormData.fromMap({
        'first_name': firstName.value,
        'last_name': lastName.value,
        'email': email.value,
        'password': password.value,
        'password_confirmation': confirmPassword.value,
        'imei': '1234',
        'token': fcmToken,
        'device_type': 'ios',
      });
      try {
        final response = await apiConsumer.post(
          'register',
          formDataIsEnabled: true,
          formData: formData,
        );

        final apiResponse = ApiResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Registration successful');
          // Handle successful registration
          isGuest.value = false;

          await cacheUserData(apiResponse.data!);
          AppConstants.userData = apiResponse.data!;
          user.value = apiResponse.data!.user;
          userToken = AppConstants.userData!.token;
          // Get.off(() => MainView());
          Get.offNamedUntil(Routes.MAIN, (Route) => false);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Registration failed: ${response.statusMessage}');
        }
        isLoading.value = false;
      } catch (e, stackTrace) {
        isGuest.value = false;

        isLoading.value = false;
        print('Registration failed:  ${e} $stackTrace');

        final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));

        handleApiErrorUser(apiResponse.message);
        print(e.toString() + stackTrace.toString());
      }
    }
  }

  void login() async {
    if (validateEmail() && validatePassword()) {
      isLoading.value = true;
      globalController.errorMessage.value = '';
      var formData = dio.FormData.fromMap({
        'email': email.value,
        'password': password.value,
        'token': fcmToken,
        'imei': '1234',
        'device_type': 'ios',
      });
      try {
        final response = await apiConsumer.post(
          'login',
          formDataIsEnabled: true,
          formData: formData,
        );

        isLoading.value = false;
        final apiResponse = ApiResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print("is fcm token is sent? ${fcmToken}");
          print("my sent form data ${formData.fields}");
          print('Login successful');
          // Handle successful login
          isGuest.value = false;

          await cacheUserData(apiResponse.data!);
          AppConstants.userData = apiResponse.data!;
          user.value = apiResponse.data!.user;
          userToken = AppConstants.userData!.token;
          // Get.off(() => MainView());
          Get.offNamedUntil(Routes.MAIN, (Route) => false);
        } else {
          isGuest.value = false;

          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
        }
        // Handle successful login
      } catch (e, stackTrace) {
        isLoading.value = false;
        isGuest.value = false;

        print('Login failed: ${e}');
        print(e.toString() + stackTrace.toString());

        final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));

        handleApiErrorUser(apiResponse.message);
      }
    }
  }

  Future<void> cacheUserData(UserData data) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = jsonEncode(data.toJson()); // Use jsonEncode
    await prefs.setString('user_data', userDataString);
    print('User data cached: $userDataString');
  }
}
