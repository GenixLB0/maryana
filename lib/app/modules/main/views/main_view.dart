import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/cart/views/cart_view.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/home/views/home_view.dart';
import 'package:maryana/app/modules/main/controllers/tab_controller.dart';

import 'package:maryana/app/modules/profile/views/profile_view.dart';
import 'package:maryana/app/modules/shop/views/shop_view.dart';
import 'package:maryana/app/modules/wishlist/views/wishlist_view.dart';

class MainView extends StatelessWidget {
  final NavigationsBarController _tabController =
      Get.put(NavigationsBarController());

  final List<Widget> _screens = [
    const HomeView(),
    const ShopView(),
    CartPage(),
    const WishlistView(),
    ProfileView(),
    // WishlistView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[_tabController.selectedIndex.value]),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
