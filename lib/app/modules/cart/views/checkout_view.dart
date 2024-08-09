import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/address/controllers/address_controller.dart';
import 'package:maryana/app/modules/address/views/address_view.dart';
import 'package:maryana/app/modules/cart/controllers/cart_controller.dart';
import 'package:maryana/app/modules/gift_card/controllers/gift_card_controller.dart';
import 'package:maryana/app/modules/global/model/model_response.dart' as model;
import 'package:maryana/app/modules/global/model/test_model_response.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/main/controllers/tab_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:maryana/app/routes/app_pages.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
    with SingleTickerProviderStateMixin {
  final CartController cartController = Get.put(CartController());
  final AddressController addressController = Get.put(AddressController());
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Super slow animation
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    //  addressController.fetchAddresses();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget step() {
    return Obx(() {
      return SizedBox(
        width: 266.w,
        height: 22.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/cart/location.svg',
                width: 22.w,
                height: 22.h,
                color: num.parse(cartController.step.value) >= 1
                    ? const Color(0xFF53178C)
                    : const Color(0xFFC8C7CC)),
            SvgPicture.asset(
              'assets/images/cart/line.svg',
              width: 61.w,
              height: 3.h,
              color: num.parse(cartController.step.value) >= 1
                  ? const Color(0xFF53178C)
                  : const Color(0xFFC8C7CC),
            ),
            SvgPicture.asset('assets/images/cart/payment.svg',
                width: 22.w,
                height: 22.h,
                color: num.parse(cartController.step.value) >= 2
                    ? const Color(0xFF53178C)
                    : const Color(0xFFC8C7CC)),
            SvgPicture.asset(
              'assets/images/cart/line.svg',
              width: 61.w,
              height: 3.h,
              color: num.parse(cartController.step.value) >= 2
                  ? const Color(0xFF53178C)
                  : const Color(0xFFC8C7CC),
            ),
            SvgPicture.asset(
              'assets/images/cart/done.svg',
              width: 22.w,
              height: 22.h,
              color: num.parse(cartController.step.value) >= 3
                  ? const Color(0xFF53178C)
                  : const Color(0xFFC8C7CC),
            ),
          ],
        ),
      );
    });
  }

  Widget itemCart(ViewProductData product, CartItem item) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0xFFFAFAFA)),
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Hero(
                  tag: product!.id.toString(),
                  child: Container(
                    width: 117.88058471679688.w,
                    height: 117.71769714355469.h,
                    decoration: const BoxDecoration(
                      color: Color(0xffdcdcdf),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: (product!.image!.isEmpty)
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://via.assets.so/shoe.png?id=1&q=95&w=360&h=360&fit=fill',
                              fit: BoxFit.cover,
                              width: 117.88058471679688,
                              height: 117.71769714355469,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Image.network(
                                'https://via.assets.so/shoe.png?id=1&q=95&w=360&h=360&fit=fill',
                                fit: BoxFit.cover,
                                width: 117.88058471679688,
                                height: 117.71769714355469,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: product!.image != null &&
                                      product!.image!.isNotEmpty
                                  ? product!.image!
                                  : '',
                              fit: BoxFit.cover,
                              width: 117.88058471679688,
                              height: 117.71769714355469,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Image.network(
                                'https://via.assets.so/shoe.png?id=1&q=95&w=360&h=360&fit=fill',
                                fit: BoxFit.cover,
                                width: 117.88058471679688,
                                height: 117.71769714355469,
                              ),
                            ),
                          ),
                  )),
              SizedBox(
                width: 13.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 114.w,
                    child: Text(
                      GetMaxChar(product!.name ?? '', 16),
                      style: primaryTextStyle(
                        color: const Color(0xFF1D1F22),
                        size: 13,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.w,
                  ),
                  SizedBox(
                    width: 58,
                    height: 19,
                    child: Text(
                      product!.old_price == null
                          ? '\$ ${product!.price}'
                          : '\$ ${product!.old_price}',
                      style: primaryTextStyle(
                        color: const Color(0xFF1D1F22),
                        size: 16,
                        weight: FontWeight.w700,
                        height: 0.09,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.w,
                  ),
                  Text(
                    'Size: ${item!.selectedSize.toString()}',
                    style: primaryTextStyle(
                      color: const Color(0xFF8A8A8F),
                      size: 10,
                      weight: FontWeight.w700,
                      height: 0.20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          PositionedDirectional(
            top: 10.h,
            end: 20.w,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                cartController.removeItem(item);
              },
            ),
          ),
          PositionedDirectional(
            bottom: 12.h,
            end: 16.w,
            child: Container(
              width: 63.10.w,
              height: 22.h,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 9.w,
                  ),
                  InkWell(
                      onTap: () => {
                            if (item.quantity > 1)
                              {
                                cartController.updateQuantity(
                                    item, item.quantity - 1)
                              }
                          },
                      child: Container(
                        width: 5.79.w,
                        height: 2.h,
                        color: Colors.black.withOpacity(0.5),
                      )),
                  SizedBox(
                    width: 12.w,
                  ),
                  SizedBox(
                    width: 6.44.w,
                    height: 13.48.h,
                    child: Text(
                      item.quantity.toString(),
                      style: primaryTextStyle(
                        color: Colors.black.withOpacity(0.5),
                        size: 12,
                        fontFamily: 'Roboto',
                        weight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  InkWell(
                      onTap: () => {
                            cartController.updateQuantity(
                                item, item.quantity + 1)
                          },
                      child: SizedBox(
                        width: 5.79.w,
                        height: 13.48.h,
                        child: Text(
                          '+',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String titleStep() {
    String title = 'Shipping';
    switch (cartController.step.value) {
      case '1':
        title = 'Shipping';
        break;
      case '2':
        title = 'Payment';
        break;
      case '3':
        title = 'Order Placed';
        break;
    }

    return title;
  }

  String ButtonTitleStep() {
    String title = 'Confirm';
    switch (cartController.step.value) {
      case '1':
        title = 'Confirm';
        break;
      case '2':
        title = 'Place My Order';
        break;
      case '3':
        title = 'Continue shopping';
        break;
    }

    return title;
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
        )
      ],
    );
  }

  Widget _buildPaymentMethodCard(
      String method, String icon, bool isSelected, width, height) {
    return GestureDetector(
        onTap: () {
          cartController.selectedMethod.value = method;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 94.w,
          height: 64.w,
          decoration: ShapeDecoration(
            color: isSelected ? const Color(0xff43484B) : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            shadows: const [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 16,
                offset: Offset(0, 5),
                spreadRadius: 0,
              )
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SvgPicture.asset(
                'assets/images/cart/$icon.svg',
                color: method == 'Cash'
                    ? null
                    : isSelected
                        ? Colors.white
                        : Colors.grey,
                width: width,
                height: height,
              ),
              SizedBox(height: 6.h),
              Text(
                method,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF6D758A),
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.36,
                ),
              )
            ]),
          ),
        ));
  }

  Widget stepPayment() {
    return Obx(() => SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildPaymentMethodCard(
                      "Cash",
                      'cash',
                      cartController.selectedMethod.value == "Cash",
                      36.49.w,
                      22.h,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    _buildPaymentMethodCard(
                        "Credit Card",
                        'credit',
                        cartController.selectedMethod.value == "Credit Card",
                        35.w,
                        22.h),
                    // Container(
                    //     width: 94.w,
                    //     height: 64.w,
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(12.r),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.black.withOpacity(0.1),
                    //           blurRadius: 6,
                    //           offset: Offset(0, 2),
                    //         ),
                    //       ],
                    //     ),
                    //     child: Padding(
                    //         padding: EdgeInsets.only(top: 10),
                    //         child: SvgPicture.asset(
                    //           'assets/images/cart/more.svg',
                    //           width: 150.10.w,
                    //           height: 64.h,
                    //           fit: BoxFit.cover,
                    //         ))),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            if (cartController.selectedMethod.value == "Cash") orderSummary(),
            if (cartController.selectedMethod.value != "Cash") orderSummary(),
            SizedBox(height: 10.h),
          ],
        )));
  }

  Widget orderSummary() {
    return Obx(
      () => Container(
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
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartController.cartItems[index];
                return _buildOrderItem(item.product.name ?? '', item.quantity,
                    double.parse(item.product.price!));
              },
            ),
            SizedBox(height: 10.h),
            _buildSummaryRow("Subtotal",
                double.parse(cartController.subTotal.value.toString())),
            _buildSummaryRow("Shipping Fee",
                double.parse(cartController.shipping.value.toString())),
            _buildSummaryRow("Discount Applied",
                -double.parse(cartController.discount.value.toString())),
            _buildSummaryRow("Gift Card Discount",
                -double.parse(cartController.giftCardValue.value.toString())),
            _buildSummaryRow("Coupon Discount",
                -double.parse(cartController.couponValue.value.toString())),
            Divider(),
            _buildSummaryRow(
                "Total", double.parse(cartController.total.value.toString()),
                isTotal: true),
            SizedBox(height: 10.h),
            if (double.parse(cartController.giftCardValue.value.toString()) <
                double.parse(cartController.total.value.toString()))
              _buildCouponInput(),
            _buildGiftCardDropdown(),
            SizedBox(height: 10.h),
            if (cartController.selectedMethod.value != "Cash")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'You will pay after the order is confirmed',
                  style: primaryTextStyle(
                    size: 16,
                    color: Colors.red, // You can adjust the style as needed
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
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

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
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
            "\$${value.toStringAsFixed(2)}",
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

  Widget _buildCouponInput() {
    return Obx(
      () => cartController.couponCode.value.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: TextField(
                onSubmitted: (value) => cartController.applyCoupon(value),
                onChanged: (value) {
                  cartController.coupon.value = value;
                },
                decoration: InputDecoration(
                  hintText: "Enter Coupon Code",
                  border: OutlineInputBorder(),
                  suffixIcon: InkWell(
                      onTap: () {
                        cartController.applyCoupon(cartController.coupon.value);
                      },
                      child: const Icon(Icons.check)),
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Row(children: [
                    Icon(Icons.wallet_giftcard, color: primaryColor),
                    SizedBox(width: 10.w),
                    Text(
                      "Coupon Applied: ${cartController.couponCode.value}",
                      style: primaryTextStyle(size: 14.sp.round()),
                    ),
                  ])),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: cartController.removeCoupon,
                  ),
                ],
              ),
            ),
    );
  }

  GiftCardController giftCardController = Get.put(GiftCardController());

  Widget _buildGiftCardDropdown() {
    return Obx(
      () => cartController.giftCardValue.value.toString().isEmpty ||
              cartController.giftCardValue.value == 0.0
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: DropdownButton<Transaction>(
                isExpanded: true,
                items:
                    giftCardController.receivedTransactions.map((transaction) {
                  return DropdownMenuItem<Transaction>(
                    value: transaction,
                    child: Row(
                      children: [
                        Icon(Icons.card_giftcard, color: primaryColor),
                        SizedBox(width: 10.w),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "From: ${transaction.from!.firstName} ${transaction.from!.lastName}",
                              style: secondaryTextStyle(),
                            ),
                            Text(
                              " Amount: ${transaction.amount} \$",
                              style: secondaryTextStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (Transaction? selectedTransaction) {
                  if (selectedTransaction != null) {
                    cartController
                        .applyGiftCard(selectedTransaction.id.toString());
                  }
                },
                hint: Text(
                  "Select Gift Card",
                  style: primaryTextStyle(size: 14.sp.round()),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Animate(
                effects: [FadeEffect(), ScaleEffect()],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Row(children: [
                      Icon(Icons.wallet_giftcard, color: primaryColor),
                      SizedBox(width: 10.w),
                      Text(
                        "Gift Card Applied: ${cartController.giftCardValue.value.toString()} \$",
                        style: primaryTextStyle(size: 14.sp.round()),
                      ),
                    ])),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: cartController.removeGiftCard,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  final NavigationsBarController _tabController =
      Get.put(NavigationsBarController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: const CustomAppBar(
              title: 'Checkout',
              back: true,
            ),
            backgroundColor: const Color(0xffFDFDFD),
            body: Obx(() {
              return SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  step(),
                  SizedBox(
                    height: 44.h,
                  ),
                  SizedBox(
                      width: 332.w,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 35.w,
                                child: ShowUp(
                                  delay: 200,
                                  child: Text(
                                    'STEP ${cartController.step.value}',
                                    style: primaryTextStyle(
                                      color: Color(0xFF1D1F22),
                                      size: 11,
                                      weight: FontWeight.w400,
                                      letterSpacing: -0.06,
                                    ),
                                  ),
                                )),
                            ShowUp(
                                delay: 400,
                                child: Text(
                                  titleStep(),
                                  style: secondaryTextStyle(
                                    color: Color(0xFF1D1F22),
                                    size: 25,
                                    weight: FontWeight.w700,
                                  ),
                                )),
                          ])),
                  SizedBox(
                    height: 30.h,
                  ), //   Expanded(
                  //     child: SizedBox(
                  //       width: 310.w,
                  //       child: ListView.builder(
                  //         itemCount: cartController.cartItems.length,
                  //         itemBuilder: (context, index) {
                  //           final item = cartController.cartItems[index];
                  //           return Padding(
                  //             padding: const EdgeInsets.only(bottom: 20),
                  //             child: itemCart(item.product, item),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  if (cartController.step.value == '1')
                    SizedBox(
                      height: 400.h,
                      width: 375.w,
                      child: AddressListScreen(
                        viewOnly: true,
                      ),
                    ),
                  if (cartController.step.value == '2')
                    SizedBox(
                        height: 400.h,
                        width: 375.w,
                        child: Center(child: stepPayment())),
                  if (cartController.step.value == '3')
                    SizedBox(
                        height: 400.h,
                        width: 375.w,
                        child: Center(child: stepThree())),

                  Hero(
                      tag: 'checkout',
                      child: Material(
                          color: Colors.transparent,
                          child: Container(
                            width: 375.w,
                            height: 145.h,
                            decoration: cartController.step.value != '3'
                                ? const ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(18),
                                      ),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 10,
                                        offset: Offset(0, 0),
                                        spreadRadius: -2,
                                      ),
                                    ],
                                  )
                                : null,
                            child: Column(
                              children: [
                                if (cartController.step.value != '3')
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                if (cartController.step.value != '3')
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 39),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Subtotal',
                                          style: primaryTextStyle(
                                            color: Colors.black,
                                            size: 14,
                                            weight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '\$ ${cartController.cartItems.fold<double>(0, (sum, item) => sum + num.parse(item.product!.price!) * item.quantity).toStringAsFixed(2)}',
                                          style: primaryTextStyle(
                                            size: 20,
                                            color: Colors.black,
                                            weight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                InkWell(
                                    onTap: () {
                                      if (cartController.step.value == '1') {
                                        if (cartController
                                            .shippingID.value.isNotEmpty) {
                                          cartController.step.value = '2';
                                          cartController.fetchCheckoutDetails();

                                          //       cartController.checkoutApi();
                                        } else {
                                          Get.snackbar('Sorry',
                                              'You should choose the default shipping address.');
                                        }
                                      } else if (cartController.step.value ==
                                          '2') {
                                        if (cartController
                                            .shippingID.value.isNotEmpty) {
                                          cartController
                                              .confirmCheckout(cartController
                                                  .selectedMethod.value)
                                              .then((value) => {
                                                    if (value == 'true')
                                                      cartController
                                                          .step.value = '3'
                                                  });
                                          ;
                                        } else {
                                          Get.snackbar('Sorry',
                                              'You should choose the default shipping address.',
                                              backgroundColor:
                                                  Colors.yellowAccent);
                                        }
                                      } else {
                                        // send to whatsapp data for number xxx
                                        _tabController.changeIndex(1);

                                        // _tabController.selectedIndex.value = 1;
                                        // Get.offAndToNamed(Routes.MAIN);
                                        Get.offNamedUntil(
                                            Routes.MAIN, (Route) => false);
                                      }
                                    },
                                    child: Container(
                                      width: 315.w,
                                      height: 60.h,
                                      decoration: cartController.loading.value
                                          ? null
                                          : ShapeDecoration(
                                              color: const Color(0xFFD4B0FF),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                      child: cartController.loading.value
                                          ? Center(
                                              child: Center(
                                                  child: LoadingAnimationWidget
                                                      .flickr(
                                                leftDotColor: primaryColor,
                                                rightDotColor:
                                                    const Color(0xFFFF0084),
                                                size: 50,
                                              )),
                                            )
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/cart_in_button.svg',
                                                  width: 20.w,
                                                  height: 20.h,
                                                ),
                                                SizedBox(
                                                  width: 16.w,
                                                ),
                                                Text(
                                                  ButtonTitleStep(),
                                                  textAlign: TextAlign.center,
                                                  style: primaryTextStyle(
                                                    color: Color(0xFF21034F),
                                                    size: 16,
                                                    weight: FontWeight.w700,
                                                    height: 0.09,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ))
                              ],
                            ),
                          ))),
                ],
              ));
            })));
  }
}
