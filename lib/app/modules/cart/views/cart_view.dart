import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maryana/app/modules/cart/controllers/cart_controller.dart';
import 'package:maryana/app/modules/cart/views/checkout_view.dart';
import 'package:maryana/app/modules/global/model/model_response.dart'
    hide Material;
import 'package:maryana/app/modules/global/model/test_model_response.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:nb_utils/nb_utils.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  final CartController cartController = Get.put(CartController());
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget itemCart(ViewProductData product, CartItem item) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        ).animate(_animation),
        child: Container(
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
                        width: 97.88058471679688.w,
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
                                  width: 97.88058471679688,
                                  height: 117.71769714355469,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Image.network(
                                    'https://via.assets.so/shoe.png?id=1&q=95&w=360&h=360&fit=fill',
                                    fit: BoxFit.cover,
                                    width: 97.88058471679688,
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
                                  width: 97.88058471679688,
                                  height: 117.71769714355469,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Image.network(
                                    'https://via.assets.so/shoe.png?id=1&q=95&w=360&h=360&fit=fill',
                                    fit: BoxFit.cover,
                                    width: 97.88058471679688,
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
                      SizedBox(
                          width: 120.w,
                          child: Text(
                            'Size: ${item!.selectedSize.toString()} |  Color: ${item!.selectedColor.toString()}',
                            style: primaryTextStyle(
                              color: const Color(0xFF8A8A8F),
                              size: 10,
                              weight: FontWeight.w700,
                            ),
                          )),
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
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                  // width: 63.10.w,
                  // height: 22.h,
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
                      Container(
                        width: 5.79.w,
                        height: 3.h,
                        color: Colors.black.withOpacity(0.5),
                      ).onTap(() {
                        if (item.quantity > 1) {
                          cartController.updateQuantity(
                              item, item.quantity - 1);
                        }
                      }),
                      12.width,
                      SizedBox(
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cartController.cartItems.isNotEmpty
          ? CustomAppBar(
              title: 'Your Cart',
              back: false,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.remove_shopping_cart_rounded,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    // Your onTap code here
                    print('Delete icon tapped');
                    cartController.clearCart();

                    // Add your functionality here
                  },
                ),
              ],
            )
          : const CustomAppBar(
              title: 'Your Cart',
              back: false,
            ),
      backgroundColor: const Color(0xffFDFDFD),
      body: Obx(() {
        return cartController.isAuth.value
            ? buildCartWidgets()
            : Align(
                alignment: Alignment.center, child: socialMediaPlaceHolder());
      }),
    );
  }

  buildCartWidgets() {
    if (cartController.loading.value) {
      return Center(
          child: Center(
              child: LoadingAnimationWidget.flickr(
        leftDotColor: primaryColor,
        rightDotColor: const Color(0xFFFF0084),
        size: 50,
      )));
    } else if (cartController.cartItems.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/cart/shopping-cart.png",
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 4,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Text(
                'Your cart is empty ',
                style: primaryTextStyle(size: 20.sp.round()),
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          30.height,
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
          Hero(
              tag: 'checkout',
              child: Material(
                  color: Colors.transparent,
                  child: FadeTransition(
                    opacity: _animation,
                    child: Container(
                      width: 375.w,
                      height: 145.h,
                      decoration: const ShapeDecoration(
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
                      ),
                      child: Column(
                        children: [
                          16.height,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 39),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  cartController.total.value.isNotEmpty &&
                                          cartController.total.value != '0'
                                      ? '\$ ${cartController.total.value}'
                                      : '\$ ${cartController.cartItems.fold<double>(0, (sum, item) => sum + num.parse(item.product!.price!) * item.quantity).toStringAsFixed(2)}',
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
                          InkWell(
                            onTap: () {
                              cartController.step.value = '1';
                              Get.to(CheckoutPage());
                            },
                            child: Container(
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Proceed to checkout',
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))),
        ],
      );
    }
  }
}
