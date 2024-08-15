import 'package:get/get.dart';
import 'package:maryana/app/modules/cart/controllers/cart_controller.dart';
import 'package:maryana/app/modules/main/views/main_view.dart';
import 'package:maryana/app/modules/onboarding/views/onboarding_view.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/services/api_service.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  var isLoading = true.obs;
  final CartController cartController = Get.put(CartController());

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    // if (!cartController.loadCartItems()) {
    //   cartController.fetchCartDetailsFromAPI();
    // }
  }

  Future<void> loadUserData() async {
    try {
      await AppConstants.loadUserFromCache();
      if (userToken != null) {
        // If the user token exists, navigate to the main screen.
        print("userToken retrived user data: ");
        await Future.delayed(const Duration(seconds: 3));

        Get.offNamedUntil(Routes.MAIN, (route) => false);
      } else {
        // If no user token is found, navigate to the onboarding screen.
        await Future.delayed(const Duration(seconds: 3));

        navigateToOnboarding();
      }
    } catch (e) {
      // Handle any exceptions that may occur during loading
      print("Error loading user data: $e");
      await Future.delayed(const Duration(seconds: 3));
      navigateToOnboarding();

      // Consider navigating to an error screen or showing a retry option
    } finally {
      // Set loading to false when done
      isLoading.value = false;
    }
  }

  void navigateToOnboarding() {
    Get.offNamedUntil(Routes.ONBOARDING, (route) => false);

    //  Get.offAll(() => const OnboardingView());
  }
}
