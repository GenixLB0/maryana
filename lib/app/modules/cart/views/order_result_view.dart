import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:maryana/app/modules/cart/controllers/cart_controller.dart';
import 'package:maryana/app/modules/cart/views/checkout_view.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';

import '../../global/theme/app_theme.dart';
import '../../global/theme/colors.dart';
import '../../main/controllers/tab_controller.dart';
import '../../main/views/main_view.dart';

class OrderResultView extends GetView<CartController> {
  const OrderResultView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:
      CustomAppBar(title:'Payment Result', back: false, ),

      body: Obx(() {
        return
          controller.isGettingOrderLoading.value?

              Center(child: loadingIndicatorWidget(),)
          :

          Center(
          child:
          controller.isOrderSuccess.value ?
         // Column(
         //   crossAxisAlignment: CrossAxisAlignment.start,
         //   children: [
         //     SizedBox(height: 40.h,),
         //    Icon(Icons.check_circle, color: Colors.green, size: 200.sp,).animate().
         //    slideX(duration: const Duration(milliseconds: 400)).fade(duration: const Duration(milliseconds: 200)),
         //     SizedBox(height: 50.h,),
         //     Row(
         //       children: [
         //         Text(
         //           'Order Payment Success',
         //           style: primaryTextStyle(size: 20.sp.round()),
         //         ),
         //         SizedBox(width: 30.w,),
         //         CachedNetworkImage(imageUrl: 'https://cdn-icons-png.flaticon.com/512/6963/6963703.png', height: 50.h, width: 50.w,
         //           placeholder: (context, url) => const Center(child: CircularProgressIndicator(),),
         //         )
         //       ],
         //     ),
         //
         //     SizedBox(height: 15.h,),
         //
         //     Text(
         //       'You can check your order details at orders section',
         //       style: primaryTextStyle(size: 20.sp.round()),
         //     ),
         //     Text(
         //       'Order Id : ${controller.orderId.value}',
         //       style: primaryTextStyle(size: 20.sp.round()),
         //     ),
         //     SizedBox(height: 20.h,),
         //
         //     MyDefaultButton(onPressed: (){
         //       Get.off(() => MainView());
         //     }, isloading: false,
         //       btnText: 'Home',
         //     )
         //   ],
         // )
          stepThree()
          :

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h,),
              Icon(Icons.cancel, color: Colors.red, size: 200.sp,).animate().
              slideX(duration: const Duration(milliseconds: 400)).fade(duration: const Duration(milliseconds: 200)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Order Payment Failed',
                    style: primaryTextStyle(size: 15.sp.round()),
                  ),
                  SizedBox(width: 30.w,),
                  CachedNetworkImage(imageUrl: 'https://cdn-icons-png.flaticon.com/512/6963/6963703.png', height: 50.h, width: 50.w,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(),),
                  )
                ],
              ),
              SizedBox(height: 15.h,),
              Text(
                'Order Cancelled By The User or Payment Failed',
                style: primaryTextStyle(size: 13.sp.round()),
              ),
              SizedBox(height: 50.h,),
              MyDefaultButton(onPressed: (){
                final NavigationsBarController _tabController =
                Get.find<NavigationsBarController>();
                _tabController.selectedIndex.value = 0;
                Get.offAll(() => MainView());
              }, isloading: false,
              btnText: 'Home',
              )
            ],
          ),
        );
      }),
    );
  }

  void showCustomBottomSheet(BuildContext context) {
    int pageIndex = 1;
CartController cartController = Get.find<CartController>();
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled:
      true, // Allow the bottom sheet to adjust with the keyboard
      backgroundColor:
      Colors.transparent, // Transparent background for rounded corners
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.4, // Initial height of the bottom sheet
              minChildSize: 0.2,
              maxChildSize: 0.6, // Allow expanding
              builder: (context, scrollController) {
                return BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 10, sigmaY: 10), // Apply blur effect
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.1), // Transparent container
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 5,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: pageIndex == 1
                                ? Column(
                              key: ValueKey(1),
                              children: [
                                Text(
                                  "Due to the current situation in Lebanon and since all flights from Lebanon to China have been cancelled, kindly note that your orders will be delayed more than expected.\n\nYou can follow your order status via WhatsApp only: +9613950235.",
                                  style: primaryTextStyle(
                                    size: 16.sp.round(),
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      pageIndex = 2;
                                    });
                                  },
                                  child: Text("Next"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            )
                                : Column(
                              key: ValueKey(2),
                              children: [
                                Text(
                                  "Estimated Delivery Time:\nArrives between 18-25 business days after we confirm your order.",
                                  style: primaryTextStyle(
                                    size: 16.sp.round(),
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 24),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        cartController
                                            .confirmCheckout(
                                            cartController
                                                .selectedMethod.value)
                                            .then((value) {
                                          if (value == 'true') {
                                            cartController.step.value =
                                            '3';
                                          }
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Confirm",
                                        style: primaryTextStyle(
                                            color: Colors.white,
                                            size: 16.sp.round()),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 24),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Skip",
                                        style: primaryTextStyle(
                                            color: Colors.white,
                                            size: 16.sp.round()),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            );
          },
        );
      },
    );
  }
  Widget stepThree() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/cart/compelete_order.gif',
          width: 142.w,
          height: 142.h,
        ),
        SizedBox(
          height: 62.h,
        ),
        ShowUp(
            delay: 200,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Thank you',
                    style: primaryTextStyle(
                      color: Colors.black,
                      size: 42.round(),
                      weight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: primaryTextStyle(
                      color: Colors.black,
                      size: 26,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            )),
        SizedBox(
          height: 10.h,
        ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Order id : ${controller.orderId.value}',
                  style: primaryTextStyle(size: 15.sp.round()),
                ),
                SizedBox(width: 20.w,),
                CachedNetworkImage(imageUrl: 'https://cdn-icons-png.flaticon.com/512/6963/6963703.png', height: 50.h, width: 50.w,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(),),
                )
              ],
            ),
        ShowUp(
          delay: 400,
          child: SizedBox(
              width: 272.w,
              child: Text(
                'Thank you for your purchase.\nYou can view your order in ‘My Orders’ section.',
                textAlign: TextAlign.center,
                style: primaryTextStyle(
                  color: const Color(0xFF33302E),
                  size: 14,
                  weight: FontWeight.w400,
                ),
              )),
        ),
        SizedBox(height: 20.h,),
        MyDefaultButton(onPressed: (){
          final NavigationsBarController _tabController =
          Get.find<NavigationsBarController>();
          _tabController.selectedIndex.value = 0;
          Get.offAll(() => MainView());
        }, isloading: false,
          btnText: 'Home',
        )
      ],
    );
  }
}
