import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maryana/app/modules/coupon/controllers/coupon_controller.dart';
import 'package:maryana/app/modules/gift_card/controllers/gift_card_controller.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:flutter/services.dart'; // Import the services package for clipboard

class CouponViwe extends StatelessWidget {
  final CouponController controller = Get.put(CouponController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Coupon',
        ),
        body: Container(
          width: double.infinity,
          height: 700.h,
          color: Color.fromRGBO(250, 250, 250, 1),
          child: Column(children: [
            Obx(() {
              if (controller.loading.value) {
                return SizedBox(
                    height: 650.h,
                    child: Center(
                        child: LoadingAnimationWidget.flickr(
                      leftDotColor: primaryColor,
                      rightDotColor: const Color(0xFFFF0084),
                      size: 50,
                    )));
              } else if (controller.coupons.isEmpty) {
                return SizedBox(
                  height: 650.h,
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                          tag: 'coupon',
                          child: SvgPicture.asset(
                            "assets/images/profile/coupon.svg",
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 4,
                            fit: BoxFit.fitWidth,
                            color: primaryColor,
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Text(
                          'No Coupon available',
                          style: primaryTextStyle(size: 20.sp.round()),
                        ),
                      ),
                    ],
                  )),
                );
              } else {
                return SizedBox(
                  width: 375.w,
                  height: 700.h,
                  child: ListView.builder(
                    itemCount: controller.coupons.length,
                    itemBuilder: (context, index) {
                      final coupon = controller.coupons[index];
                      return ShowUp(
                          delay: 200 * index,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: CouponCard(coupon: coupon),
                          ));
                    },
                  ),
                );
              }
            }),
          ]),
        ));
  }
}

String capitalize(String s) => s
    .split(' ')
    .map((word) => word[0].toUpperCase() + word.substring(1))
    .join(' ');

class CouponCard extends StatelessWidget {
  final Coupon coupon;

  CouponCard({required this.coupon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: coupon.code));
          // Optionally show a message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Coupon code copied to clipboard')),
          );
        },
        child: Container(
            height: 120.h,
            margin: EdgeInsets.symmetric(
              vertical: 8.h,
            ),
            child: Stack(children: [
              Container(
                height: 110.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
                decoration: const BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                        child: SizedBox(
                            height: 90.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 14.w,
                                ),
                                Container(
                                  width: 68.w,
                                  height: 68.h,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF22262E),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        coupon.amount == null
                                            ? 'Free'.toUpperCase()
                                            : '${coupon.amount?.toStringAsFixed(0) ?? 'Free'}%',
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.mulish().fontFamily,
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (coupon.amount != null)
                                        Text(
                                          'OFF',
                                          style: primaryTextStyle(
                                            color: Colors.white,
                                            size: 12.sp.round(),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        capitalize(coupon.name),
                                        style: primaryTextStyle(
                                          color: Color(0xFF42474A),
                                          size: 16.round(),
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      Text(
                                        'Sale off ${coupon.amount?.toStringAsFixed(0) ?? 'Free'}%',
                                        style: primaryTextStyle(
                                          color: Color(0xFF6D758A),
                                          size: 12.round(),
                                          weight: FontWeight.w700,
                                          letterSpacing: -0.12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      Text(
                                        'Code: ${coupon.code}',
                                        style: primaryTextStyle(
                                          color: Color(0xFF42474A),
                                          size: 10.round(),
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Column(
                  children: List.generate(
                      8,
                      (index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Container(
                              width: 11.w,
                              height: 11.h,
                              decoration: const ShapeDecoration(
                                color: Color.fromRGBO(250, 250, 250, 1),
                                shape: OvalBorder(),
                              ),
                            ),
                          )),
                ),
              ),
              // PositionedDirectional(
              //   end: 61.w,
              //   top: 0,
              //   child: Column(children: [
              //     Container(
              //       width: 11.w,
              //       height: 11.h,
              //       decoration: const ShapeDecoration(
              //         color: Color.fromRGBO(250, 250, 250, 1),
              //         shape: OvalBorder(),
              //       ),
              //     ),
              //     SvgPicture.asset(
              //       'assets/images/profile/lineCoupon.svg',
              //       width: 82.w,
              //       height: 110.h,
              //     ),
              //   ]),
              // ),
              PositionedDirectional(
                end: 61.w,
                bottom: 0,
                child: Container(
                  width: 11.w,
                  height: 11.h,
                  decoration: const ShapeDecoration(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              PositionedDirectional(
                end: 30.w,
                top: 26,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          // Text(
                          //   'Exp.',
                          //   style: primaryTextStyle(
                          //     color: Color(0xFF777E90),
                          //     size: 12.round(),
                          //     weight: FontWeight.w400,
                          //     letterSpacing: -0.12,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10.h,
                          // ),
                          // Column(
                          //   children: [
                          //     Text(
                          //       coupon.expireAt == null ||
                          //               coupon.expireAt!.month == null
                          //           ? 'N/A'
                          //           : '${_monthName(coupon.expireAt!.month!)}',
                          //       textAlign: TextAlign.center,
                          //       style: primaryTextStyle(
                          //         color: Color(0xFF131416),
                          //         size: 12.round(),
                          //         weight: FontWeight.w400,
                          //         height: 0,
                          //         letterSpacing: -0.12,
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: 4.h,
                          //     ),
                          //     Text(
                          //       coupon.expireAt == null ||
                          //               coupon.expireAt!.day == null
                          //           ? 'N/A'
                          //           : '${coupon.expireAt!.day!}',
                          //       textAlign: TextAlign.center,
                          //       style: primaryTextStyle(
                          //         color: Color(0xFF131416),
                          //         weight: FontWeight.w400,
                          //         size: 12.round(),
                          //         height: 0,
                          //         letterSpacing: -0.12,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ]),
              ),
            ])));
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
