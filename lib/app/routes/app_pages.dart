import 'package:get/get.dart';
import 'package:maryana/app/modules/address/views/add_address_screen.dart';
import 'package:maryana/app/modules/address/views/edit_address_screen.dart';
import 'package:maryana/app/modules/cart/bindings/cart_binding.dart';
import 'package:maryana/app/modules/cart/views/cart_view.dart';
import 'package:maryana/app/modules/cart/views/checkout_view.dart';
import 'package:maryana/app/modules/coupon/bindings/coupon_binding.dart';
import 'package:maryana/app/modules/coupon/views/coupon.dart';
import 'package:maryana/app/modules/gift_card/bindings/gift_card_binding.dart';
import 'package:maryana/app/modules/gift_card/views/history.dart';
import 'package:maryana/app/modules/order/bindings/orders_binding.dart';
import 'package:maryana/app/modules/order/views/order_detalis.dart';
import 'package:maryana/app/modules/order/views/orders_view.dart';
import 'package:maryana/app/modules/wishlist/bindings/wishlist_binding.dart';
import 'package:maryana/app/modules/wishlist/views/wishlist_view.dart';

import '../modules/address/bindings/address_binding.dart';
import '../modules/address/views/address_view.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/bindings/forgot_password_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/order/views/add_rate_product.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/update_profile.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/shop/bindings/shop_binding.dart';
import '../modules/shop/views/shop_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import 'package:flutter/material.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(
      name: _Paths.MAIN,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => CartPage(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.Checkout,
      page: () => CheckoutPage(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.MYWISHLIST, 
      page: () => const WishlistView(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ADDREVIEW,
      page: () => const RateProductScreen(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ProfileUpdate,
      page: () => ProfileUpdate(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () =>   HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESS,
      page: () => AddressListScreen(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: _Paths.AddADDRESS,
      page: () => AddAddressScreen(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.SHOP,
      page: () => const ShopView(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(
      name: _Paths.GiftCard,
      page: () => TransactionHistoryScreen(),
      binding: GiftCardBinding(),
    ),
    GetPage(
      name: _Paths.COUPON,
      page: () => CouponViwe(),
      binding: CouponBinding(),
    )
  ];
}
