import 'dart:convert';

import 'package:get/get.dart';
import 'package:maryana/app/modules/auth/views/login_view.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/global/controller/controller.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  var isLoading = false.obs;
  var socialView = false.obs;
  var user = Rxn<User>();
  var firstNameError = ''.obs;
  var lastNameError = ''.obs;
  static const String emptyFirstNameError = 'First name cannot be empty';
  static const String emptyLastNameError = 'Last name cannot be empty';
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

      final response = await apiService.request(
        endpoint: 'register',
        method: 'POST',
        data: {
          'first_name': firstName.value,
          'last_name': lastName.value,
          'email': email.value,
          'password': password.value,
          'password_confirmation': confirmPassword.value,
          'imei': '1234',
          'token': 'ffff',
          'device_type': 'android',
        },
      );
      isLoading.value = false;

      try {
        final apiResponse = ApiResponse.fromJson(response.data);
        if (apiResponse.status == 'success') {
          print('Registration successful');
          // Handle successful registration
          await _cacheUser(apiResponse.data!);
          AppConstants.userData = apiResponse.data!;
          user.value = apiResponse.data!.user;
          userToken = AppConstants.userData!.token;
          Get.to(() => LoginView());
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Registration failed: ${response.statusMessage}');
        }
        isLoading.value = false;
      } catch (e, stackTrace) {
        print('Registration failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
      }
    }
  }

  void login() async {
    if (validateEmail() && validatePassword()) {
      isLoading.value = true;
      globalController.errorMessage.value = '';
      try {
        final response = await apiService.request(
          endpoint: 'login',
          method: 'POST',
          data: {
            'email': email.value,
            'password': password.value,
          },
        );
        isLoading.value = false;

        final apiResponse = ApiResponse.fromJson(response.data);
        if (apiResponse.status == 'success') {
          print('Login successful');
          // Handle successful login
          await _cacheUser(apiResponse.data!);
          AppConstants.userData = apiResponse.data!;
          user.value = apiResponse.data!.user;
          userToken = AppConstants.userData!.token;
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Login failed: ${response.statusMessage}');
        }
        // Handle successful login
      } catch (e, stackTrace) {
        print('Login failed: ${e}');

        print(e.toString() + stackTrace.toString());
      }
    }
  }

  Future<void> _cacheUser(UserData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', data.toJson().toString());
    print('User data cached: ${data.toJson()}');
  }
}
