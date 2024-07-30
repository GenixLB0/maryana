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
    await AppConstants.loadUserFromCache();
    await Future.delayed(const Duration(seconds: 2));
    if (userToken != null) {
      // bool cachedCart = await cartController.loadCartItems();
      // if (!cachedCart) {
      //   print('retrived cart from api');
      //   cartController.fetchCartDetailsFromAPI();
      // } else {
      //   //  fetchCartDetailsFromAPI(); // Fetch updated data in the background
      // }
      // Get.offAll(() => MainView());
      Get.offNamedUntil(Routes.MAIN, (Route) => false);
    }

    isLoading.value = false; // Set loading to false when done
  }

  void navigateToOnboarding() {
    Get.offAll(() => const OnboardingView());
  }
}
