import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/home/views/home_view.dart';
import 'package:maryana/app/modules/main/controllers/tab_controller.dart';

import 'package:maryana/app/modules/profile/views/profile_view.dart';
import 'package:maryana/app/modules/search/views/result_view.dart';
import 'package:maryana/app/modules/shop/views/shop_view.dart';
import 'package:maryana/app/modules/wishlist/views/wishlist_view.dart';

final bucketGlobal = PageStorageBucket();

class MainView extends StatelessWidget {
  final NavigationsBarController _tabController =
      Get.put(NavigationsBarController());

  final List<Widget> _screens = [
    HomeView(),
    ShopView(),
    SizedBox(),
    WishlistView(),
    ProfileView(),

    // WishlistView(),
  ];

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: PageStorageBucket(),
      child: Scaffold(
        body: Obx(() => _screens[_tabController.selectedIndex.value]),
        bottomNavigationBar: CustomNavBar(),
      ),
    );
  }
}
