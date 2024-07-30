import 'dart:convert';

import 'package:get/get.dart';
import 'package:maryana/app/modules/auth/views/login_view.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/main/views/main_view.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:convert';

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
  static const String emptyFirstNameError = 'First name required!';
  static const String emptyLastNameError = 'Last name required!';
  static const String invalidEmailError = 'Enter a valid email';
  static const String shortPasswordError =
      'Password must be at least 6 characters';
  static const String passwordMismatchError = 'Passwords do not match';

  ApiService apiService = Get.find();

  @override
  void onInit() {
    super.onInit();
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
        'token': 'ffff',
        'device_type': 'android',
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
