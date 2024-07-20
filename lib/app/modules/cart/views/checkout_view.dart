import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/address/controllers/address_controller.dart';
import 'package:maryana/app/modules/address/views/address_view.dart';
import 'package:maryana/app/modules/cart/controllers/cart_controller.dart';
import 'package:maryana/app/modules/global/model/model_response.dart' as model;
import 'package:maryana/app/modules/global/model/test_model_response.dart';
 import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/main/controllers/tab_controller.dart';
 
import 'package:maryana/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

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
            Icon(Icons.shopping_cart_checkout,
                size: 22.sp,
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
            SvgPicture.asset('assets/images/cart/location.svg',
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
              13.width,
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
                  16.height,
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
                  8.height,
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
                  9.width,
                  Container(
                    width: 5.79.w,
                    height: 2.h,
                    color: Colors.black.withOpacity(0.5),
                  ).onTap(() {
                    if (item.quantity > 1) {
                      cartController.updateQuantity(item, item.quantity - 1);
                    }
                  }),
                  12.width,
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
                  12.width,
                  SizedBox(
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
                  ).onTap(() {
                    cartController.updateQuantity(item, item.quantity + 1);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String titleStep() {
    String title = 'Confirm Cart';
    switch (cartController.step.value) {
      case '1':
        title = 'Confirm Cart';
        break;
      case '2':
        title = 'Shipping';
        break;
      case '3':
        title = 'Order Completed';
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
        62.height,
        ShowUp(
            delay: 200,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '100',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 42,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      height: 0.03,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: primaryTextStyle(
                      color: Colors.black,
                      size: 26,
                      weight: FontWeight.w700,
                      height: 0.05,
                    ),
                  ),
                  TextSpan(
                    text: 'Pts',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: GoogleFonts.sora().fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            )),
        10.height,
        ShowUp(
          delay: 400,
          child: SizedBox(
              width: 272.w,
              child: Text(
                'Thank you for your purchase.\nYou can view your order in ‘My Orders’ section.',
                textAlign: TextAlign.center,
                style: primaryTextStyle(
                  color: Color(0xFF33302E),
                  size: 14,
                  weight: FontWeight.w400,
                ),
              )),
        )
      ],
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  20.height,
                  step(),
                  44.height,
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
                  30.height,
                  if (cartController.step.value == '1')
                    Expanded(
                      child: SizedBox(
                        width: 310.w,
                        child: ListView.builder(
                          itemCount: cartController.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartController.cartItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: itemCart(item.product, item),
                            );
                          },
                        ),
                      ),
                    ),
                  if (cartController.step.value == '2')
                    SizedBox(
                      height: 400.h,
                      width: 375.w,
                      child: AddressListScreen(
                        viewOnly: true,
                      ),
                    ),
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
                                if (cartController.step.value != '3') 16.height,
                                if (cartController.step.value != '3')
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 39),
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
                                16.height,
                                Container(
                                  width: 315.w,
                                  height: 60.h,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFD4B0FF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                ).onTap(() {
                                  if (cartController.step.value == '1') {
                                    cartController.step.value = '2';
                                  } else if (cartController.step.value == '2') {
                                    if (cartController
                                        .shippingID.value.isNotEmpty) {
                                      cartController.step.value = '3';
                                      cartController.checkoutApi();
                                    } else {
                                      Get.snackbar('Sorry',
                                          'You should choose the default shipping address.',
                                          backgroundColor: Colors.yellowAccent);
                                    }
                                  } else {
                                    // send to whatsapp data for number xxx
                                    _tabController.selectedIndex.value = 1;
                                    Get.offAndToNamed(Routes.MAIN);
                                  }
                                }),
                              ],
                            ),
                          ))),
                ],
              );
            })));
  }
}
