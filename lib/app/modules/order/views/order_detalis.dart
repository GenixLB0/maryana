import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';

import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/main/controllers/tab_controller.dart';
import 'package:maryana/app/modules/order/controllers/orders_controller.dart';
import 'package:maryana/app/modules/order/views/add_rate_product.dart';
import 'package:maryana/app/modules/services/dio_consumer.dart';
import 'package:maryana/app/routes/app_pages.dart';

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
        InkWell(
            onTap: () {
              Get.toNamed(Routes.ADDRESS);
            },
            child: Text(
              value is double
                  ? "\$${value.toStringAsFixed(2)}"
                  : GetMaxChar(value, 30),
              style: primaryTextStyle(
                color: Color(0xFF22262E),
                size: 12.round(),
                weight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            )),
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

class OrderDetailsScreen extends StatefulWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrdersController controller = Get.find<OrdersController>();

  @override
  void initState() {
    super.initState();

    controller.fetchSingelOrder(widget.order.code);
  }

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
            itemCount: controller.singelOrder.value!.items.length,
            itemBuilder: (context, index) {
              final item = controller.singelOrder.value!.items[index];
              return _buildOrderItem(item.product!.name ?? '', item.quantity,
                  double.parse(item.total.toString()), item.product?.id);
            },
          ),
          SizedBox(height: 10.h),
          _buildSummaryRow("Subtotal",
              double.parse(controller.singelOrder.value!.subTotal.toString())),
          _buildSummaryRow("Shipping Fee",
              double.parse(controller.singelOrder.value!.shipping.toString())),
          _buildSummaryRow("Discount Applied",
              -double.parse(controller.singelOrder.value!.discount.toString())),
          // _buildSummaryRow("Gift Card Discount",
          //     -double.parse(order.giftCardValue.value.toString())),
          // _buildSummaryRow("Coupon Discount",
          //     -double.parse(cartController.couponValue.value.toString())),
          Divider(),
          _buildSummaryRow("Total",
              double.parse(controller.singelOrder.value!.total.toString()),
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

  Widget _buildOrderItem(
    String itemName,
    int quantity,
    double price,
    id,
  ) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$itemName x$quantity",
                      style: primaryTextStyle(size: 14.sp.round()),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    InkResponse(
                        onTap: () {
                          controller.productId = id;
                          Get.toNamed(Routes.AddReview);
                        },
                        child: Container(
                          width: 80.w,
                          height: 30.h,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF21034F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                Text(
                                  'Rate',
                                  textAlign: TextAlign.center,
                                  style: secondaryTextStyle(
                                    color: Colors.white,
                                    size: 12.sp.round(),
                                    weight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Icon(
                                  Icons.star_border,
                                  size: 14.sp,
                                )
                              ])),
                        )),
                  ]),

              Text(
                "\$$price",
                style: primaryTextStyle(size: 14.sp.round()),
              ),

              // IconButton(
              //   icon: Icon(Icons.star_border, color: Colors.amber),
              //   onPressed: () {
              //     _showRatingDialog(id);
              //   },
              // ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Divider(),
        ]));
  }

  void _showRatingDialog(int productId) {
    // Assuming you have an OrdersController that handles the rating logic

    double rating = 3.0;
    String comment = "";

    Get.defaultDialog(
      title: "Rate Product",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (newRating) {
              rating = newRating;
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Would you like to write anything about this product?",
            ),
            maxLines: 3,
            onChanged: (value) {
              comment = value;
            },
          ),
        ],
      ),
      textCancel: "Cancel",
      textConfirm: "Submit",
      onCancel: () {
        Get.back(); // Closes the dialog
      },
      onConfirm: () {
        controller.submitRating(productId, rating, comment);
        Get.back(); // Closes the dialog after submission
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Obx(() => Scaffold(
              appBar: CustomAppBar(
                title: 'Order #${controller.singelOrder.value?.id}',
              ),
              body: controller.singelLoading.value
                  ? SizedBox(
                      height: 812.h,
                      child: Center(
                        child: LoadingAnimationWidget.flickr(
                          leftDotColor: primaryColor,
                          rightDotColor: const Color(0xFFFF0084),
                          size: 50,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 375.w,
                      height: 812.h,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                  tag: 'gift',
                                  child: Container(
                                      width: 327.w,
                                      height: 92.h,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFE7D3FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 35.w, end: 25.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  ShowUp(
                                                      child: Text(
                                                          'Your order is ${controller.singelOrder.value!.status.capitalizeFirst}',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF370269),
                                                            fontSize: 16.sp,
                                                            fontFamily:
                                                                GoogleFonts
                                                                        .nunito()
                                                                    .fontFamily,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing:
                                                                -0.08,
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
                                                        color:
                                                            Color(0xFF370269),
                                                        fontSize: 10.sp,
                                                        fontFamily:
                                                            GoogleFonts.nunito()
                                                                .fontFamily,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                      ))),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildOrderRow(
                                          'Order number',
                                          controller.singelOrder.value!.id
                                              .toString()),
                                      SizedBox(height: 10.h),
                                      _buildOrderRow('Tracking Number',
                                          controller.singelOrder.value!.code),
                                      SizedBox(height: 10.h),
                                      _buildOrderRow(
                                          'Delivery address',
                                          controller.singelOrder.value!
                                                      .address ==
                                                  null
                                              ? 'address'
                                              : controller.singelOrder.value!
                                                  .address?.address),
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
                                              Get.offNamedUntil(Routes.MAIN,
                                                  (Route) => false);
                                            },
                                            child: Container(
                                                width: 168.w,
                                                height: 44.h,
                                                decoration: ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        width: 1,
                                                        color: const Color(
                                                            0xFF777E90)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Return home',
                                                    textAlign: TextAlign.center,
                                                    style: secondaryTextStyle(
                                                      color: const Color(
                                                          0xFF777E90),
                                                      size: 16.sp.round(),
                                                      fontFamily:
                                                          'Product Sans',
                                                      weight: FontWeight.w700,
                                                    ),
                                                  ),
                                                )))),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              if (controller.singelOrder.value!.readyToPay)
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
                                              width: 1,
                                              color: const Color(0xFF777E90)),
                                          borderRadius:
                                              BorderRadius.circular(24),
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
            )));
  }
}
