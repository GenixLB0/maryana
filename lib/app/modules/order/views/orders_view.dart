// lib/app/modules/order/views/orders_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/order/controllers/orders_controller.dart';
import 'package:maryana/app/modules/order/views/order_detalis.dart';
 
class OrdersView extends GetView<OrdersController> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'My Orders',
        ),
        body: Obx(() {
          return Column(
            children: [
              TabBar(
                indicator: ShapeDecoration(
                  color: const Color(0xFFE7D3FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                indicatorPadding: EdgeInsetsDirectional.symmetric(
                    horizontal: (-screenWidth * 0.05), vertical: 10.h),
                labelStyle: primaryTextStyle(
                  size: 14.sp.round(),
                  color: const Color(0xFF53178C),
                  weight: FontWeight.w400,
                ),
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: primaryTextStyle(
                  size: 14.sp.round(),
                  color: Colors.black,
                  weight: FontWeight.w400,
                ),
                padding: EdgeInsetsDirectional.only(
                  top: screenHeight * 0.001,
                  bottom: screenHeight * 0.001,
                  end: screenWidth * 0.03,
                ),
                onTap: (index) {
                  if (index == 0) {
                    controller.setStatus('pending');
                  } else if (index == 1) {
                    controller.setStatus('delivered');
                  } else if (index == 2) {
                    controller.setStatus('cancelled');
                  }
                },
                tabs: [
                  Tab(text: 'Pending'),
                  Tab(text: 'Delivered'),
                  Tab(text: 'Cancelled'),
                ],
              ),
              if (controller.loading.value)
                SizedBox(
                    height: 650.h,
                    child: Center(
                        child: LoadingAnimationWidget.flickr(
                      leftDotColor: primaryColor,
                      rightDotColor: const Color(0xFFFF0084),
                      size: 50,
                    ))),
              if (controller.loading.value) SizedBox(height: 20.h,),
              if (controller.orders.isEmpty && !controller.loading.value)
                SizedBox(
                    height: 650.h,
                    child: Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                            tag: 'gift',
                            child: SvgPicture.asset(
                              "assets/images/profile/order.svg",
                              width: MediaQuery.of(context).size.width / 3,
                              height: MediaQuery.of(context).size.height / 4,
                              fit: BoxFit.fitWidth,
                              color: primaryColor,
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: Text(
                            'No Orders available',
                            style: primaryTextStyle(size: 20.sp.round()),
                          ),
                        ),
                      ],
                    ))),
              if (controller.orders.isNotEmpty && !controller.loading.value)
                Expanded(
                    child: SizedBox(
                        width: 336.w,
                        child: ListView.builder(
                          itemCount: controller.orders.length,
                          itemBuilder: (context, index) {
                            final order = controller.orders[index];
                            return ShowUp(
                                delay: 100 * index,
                                child: Padding(
                                    padding: EdgeInsetsDirectional.symmetric(
                                        vertical: 20.h),
                                    child: InkWell(
                                        onTap: () {
                                          Get.to(() => OrderDetailsScreen(
                                                order: order,
                                              ));
                                        },
                                        child: orderCard(order))));
                          },
                        )))
            ],
          );
        }),
      ),
    );
  }
}
