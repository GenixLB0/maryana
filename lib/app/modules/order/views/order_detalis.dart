import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';

import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/main/controllers/tab_controller.dart';
import 'package:maryana/app/modules/order/controllers/orders_controller.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

Widget _buildOrderRow(String label, dynamic value, {bool isTotal = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: primaryTextStyle(
            size: isTotal ? 14.sp.round() : 12.sp.round(),
            color: Color(0x7F121420),
            weight: isTotal ? FontWeight.bold : FontWeight.w400,
          ),
        ),
        Text(
          value is double ? "\$${value.toStringAsFixed(2)}" : value,
          style: primaryTextStyle(
            color: Color(0xFF22262E),
            size: 12.round(),
            weight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSummaryRow(String label, dynamic value, {bool isTotal = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: primaryTextStyle(
            size: isTotal ? 16.sp.round() : 14.sp.round(),
            color: Colors.black,
            weight: isTotal ? FontWeight.bold : FontWeight.w400,
          ),
        ),
        Text(
          value is double ? "\$${value.toStringAsFixed(2)}" : value,
          style: primaryTextStyle(
            size: isTotal ? 18.sp.round() : 16.sp.round(),
            color: Colors.black,
            weight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

final NavigationsBarController _tabController =
    Get.put(NavigationsBarController());

class OrderDetailsScreen extends GetView<OrdersController> {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  Widget orderSummary() {
    return Container(
      width: 0.9.sw,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: order.items.length,
            itemBuilder: (context, index) {
              final item = order.items[index];
              return _buildOrderItem('Items 1', item.quantity,
                  double.parse(item.total.toString()));
            },
          ),
          SizedBox(height: 10.h),
          _buildSummaryRow("Subtotal", double.parse(order.subTotal.toString())),
          _buildSummaryRow(
              "Shipping Fee", double.parse(order.shipping.toString())),
          _buildSummaryRow(
              "Discount Applied", -double.parse(order.discount.toString())),
          // _buildSummaryRow("Gift Card Discount",
          //     -double.parse(order.giftCardValue.value.toString())),
          // _buildSummaryRow("Coupon Discount",
          //     -double.parse(cartController.couponValue.value.toString())),
          Divider(),
          _buildSummaryRow("Total", double.parse(order.total.toString()),
              isTotal: true),
          SizedBox(height: 10.h),
          // if (double.parse(cartController.giftCardValue.value.toString()) <
          //     double.parse(cartController.total.value.toString()))
          //   _buildCouponInput(),
          // _buildGiftCardDropdown(),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String itemName, int quantity, double price) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$itemName x$quantity",
            style: TextStyle(fontSize: 14.sp),
          ),
          Text(
            "\$$price",
            style: TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order #${order.id}',
      ),
      body: SizedBox(
          width: 375.w,
          height: 812.h,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 327.w,
                      height: 92.h,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFE7D3FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 35.w, end: 25.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  ShowUp(
                                      child: Text(
                                          'Your order is ${order.status.capitalizeFirst}',
                                          style: TextStyle(
                                            color: Color(0xFF370269),
                                            fontSize: 16.sp,
                                            fontFamily:
                                                GoogleFonts.nunito().fontFamily,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.08,
                                          ))),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  SizedBox(
                                    width: 193.w,
                                    height: 31.h,
                                    child: Text(
                                      'Rate product to get 5 points for collect.',
                                      style: TextStyle(
                                        color: Color(0xFF370269),
                                        fontSize: 10.sp,
                                        fontFamily:
                                            GoogleFonts.nunito().fontFamily,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.05,
                                      ),
                                    ),
                                  ),
                                ])),
                            ShowUp(
                                child: SvgPicture.asset(
                                    'assets/images/profile/orderStatus.svg'))
                          ],
                        ),
                      )),
                  SizedBox(height: 26.h),
                  Container(
                      width: 327.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x330E0E0E),
                            blurRadius: 13,
                            offset: Offset(0, 4),
                            spreadRadius: -8,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderRow('Order number', order.id.toString()),
                          SizedBox(height: 10.h),
                          _buildOrderRow('Tracking Number', order.code),
                          SizedBox(height: 10.h),
                          _buildOrderRow(
                              'Delivery address',
                              order.address == null
                                  ? 'address'
                                  : order.address?.address),
                        ],
                      )),
                  SizedBox(height: 41.h),
                  orderSummary(),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: 327.w,
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                                onTap: () {
                                  _tabController.changeIndex(1);
                                  // _tabController.selectedIndex.value = 1;
                                  // Get.offAndToNamed(Routes.MAIN);
                                  Get.offNamedUntil(
                                      Routes.MAIN, (Route) => false);
                                },
                                child: Container(
                                    width: 168.w,
                                    height: 44.h,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 1,
                                            color: const Color(0xFF777E90)),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Return home',
                                        textAlign: TextAlign.center,
                                        style: secondaryTextStyle(
                                          color: const Color(0xFF777E90),
                                          size: 16.sp.round(),
                                          fontFamily: 'Product Sans',
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                    )))),
                        SizedBox(width: 24.w),
                        InkResponse(
                          onTap: () {},
                          child: Container(
                              width: 119.w,
                              height: 44.h,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF21034F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Center(
                                  child: Text(
                                'Rate',
                                textAlign: TextAlign.center,
                                style: secondaryTextStyle(
                                  color: Colors.white,
                                  size: 16.sp.round(),
                                  weight: FontWeight.w700,
                                ),
                              ))),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  if (order.readyToPay)
                    InkWell(
                      onTap: () {
                        // payroute
                      },
                      child: Container(
                          width: 327.w,
                          height: 44.h,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: const Color(0xFF777E90)),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Pay Now',
                              textAlign: TextAlign.center,
                              style: secondaryTextStyle(
                                color: const Color(0xFF777E90),
                                size: 16.sp.round(),
                                fontFamily: 'Product Sans',
                                weight: FontWeight.w700,
                              ),
                            ),
                          )),
                    ),
                ],
              ),
            ),
          )),
    );
  }
}
