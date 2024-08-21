import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maryana/app/modules/address/controllers/address_controller.dart';
import 'package:maryana/app/modules/cart/controllers/cart_controller.dart';
import 'package:maryana/app/modules/cart/views/checkout_view.dart';
import 'package:maryana/app/modules/global/model/model_response.dart'
    hide Material;
import 'package:maryana/app/modules/global/model/test_model_response.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  final CartController cartController = Get.put(CartController());
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _handAnimationController;
  late Animation<Offset> _handAnimation;
  late AnimationController _scaleAnimationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    cartController.fetchCartDetailsFromAPI();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _handAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _handAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-0.0, 0),
    ).animate(CurvedAnimation(
      parent: _handAnimationController,
      curve: Curves.easeInOut,
    ));

    _handAnimationController.repeat(reverse: false);
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleAnimationController.dispose();
    _handAnimationController.dispose();
    super.dispose();
  }

  final AddressController addressController = Get.put(AddressController());

  Widget itemCart(ViewProductData product, CartItem item, int index) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        ).animate(_animation),
        child: InkWell(
          onTap: () {
            cartController.cartItems[index].isDismissible = false;
            cartController.cartItems.refresh();
          },
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.50, color: Color(0xFFFAFAFA)),
                borderRadius: BorderRadius.circular(20),
              ),
              shadows: [
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
                        width: 97.88.w,
                        height: 117.72.h,
                        decoration: BoxDecoration(
                          color: Color(0xffdcdcdf),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: product!.image!.isEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://via.assets.so/shoe.png?id=1&q=95&w=360&h=360&fit=fill',
                                  fit: BoxFit.cover,
                                  width: 97.88.w,
                                  height: 117.72.h,
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Image.network(
                                    'https://via.assets.so/shoe.png?id=1&q=95&w=360&h=360&fit=fill',
                                    fit: BoxFit.cover,
                                    width: 97.88.w,
                                    height: 117.72.h,
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: product!.image!,
                                  fit: BoxFit.cover,
                                  width: 97.88.w,
                                  height: 117.72.h,
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Image.network(
                                    'https://via.assets.so/shoe.png?id=1&q=95&w=360&h=360&fit=fill',
                                    fit: BoxFit.cover,
                                    width: 97.88.w,
                                    height: 117.72.h,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 13.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 114.w,
                          child: Text(
                            GetMaxChar(product!.name ?? '', 16),
                            style: primaryTextStyle(
                              color: Color(0xFF1D1F22),
                              size: 13.sp.round(),
                              weight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            SizedBox(
                              height: 19.h,
                              child: Text(
                                '\$ ${product!.price}',
                                style: primaryTextStyle(
                                  color: Color(0xFF1D1F22),
                                  size: 16.sp.round(),
                                  weight: FontWeight.w700,
                                  height: 0.09,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            if (product!.old_price != null)
                              SizedBox(
                                height: 19.h,
                                child: Text(
                                  '\$ ${product!.old_price}',
                                  style: primaryTextStyle(
                                    color: Color(0xFF8A8A8F),
                                    size: 15.sp.round(),
                                    weight: FontWeight.w700,
                                    height: 0.09,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: 110.w,
                          child: item!.selectedSize!.isEmpty &&
                                  item!.selectedColor!.isEmpty
                              ? SizedBox()
                              : Text(
                                  'Size: ${item!.selectedSize.toString()} |  Color: ${item!.selectedColor.toString()}',
                                  style: primaryTextStyle(
                                    color: Color(0xFF8A8A8F),
                                    size: 10.sp.round(),
                                    weight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
                PositionedDirectional(
                  top: 20.h,
                  end: 70.w,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SlideTransition(
                      position: _handAnimation,
                      child: Row(
                        children: [
                          Icon(Icons.swipe, size: 20.sp, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedPositionedDirectional(
                  duration: const Duration(milliseconds: 300),
                  top: 0.h,
                  end: !item.isDismissible ? 0.w : 0.w,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 118.h,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (item.quantity > 1) {
                              cartController.updateQuantity(
                                  item, item.quantity - 1);
                              item.quantity - 1;
                            }
                          },
                          child: Text(
                            '-',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 30.sp,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                child: child, scale: animation);
                          },
                          child: Text(
                            item.quantity.toString(),
                            key: ValueKey<int>(item.quantity),
                            style: primaryTextStyle(
                              color: Colors.black.withOpacity(0.5),
                              size: 20.sp.round(),
                              fontFamily: 'Roboto',
                              weight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            cartController.updateQuantity(
                                item, item.quantity + 1);
                          },
                          child: Text(
                            '+',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 25.sp,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PositionedDirectional(
                  bottom: 0.h,
                  end: 0.w,
                  child: Observer(
                    builder: (_) => Dismissible(
                      key: Key(item.product.toString()),
                      background: Container(
                        color: Colors.transparent,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(Icons.check,
                                color: Colors.white, size: 30),
                          ),
                        ),
                      ),
                      direction: DismissDirection.startToEnd,
                      onUpdate: (details) {},
                      confirmDismiss: (direction) async {
                        cartController.cartItems[index].isDismissible = false;
                        cartController.cartItems.refresh();
                        return false;
                      },
                      onDismissed: (direction) {
                        //   cartController.removeItem(item);
                      },
                      child: InkWell(
                        onTap: () {
                          cartController.removeItem(item);
                        },
                        child: Container(
                          width: item.isDismissible ? 50.w : 0,
                          height: 120.h,
                          decoration: BoxDecoration(
                            color: item.isDismissible
                                ? Colors.red
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(Icons.delete,
                                color: Colors.white, size: 24.w),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                        Get.defaultDialog(
                          title: 'Confirm',
                          titleStyle: primaryTextStyle(
                            size: 20.sp.round(),
                            weight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          middleText:
                              'Are you sure you want to empty the cart?',
                          middleTextStyle: primaryTextStyle(
                            size: 14.round(),
                            color: Colors.black87,
                          ),
                          textCancel: 'Cancel',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          cancelTextColor: primaryColor,
                          textConfirm: 'Confirm',
                          confirmTextColor: Colors.white,
                          buttonColor: primaryColor,
                          onConfirm: () {
                            cartController.clearCart();
                            Get.back();
                          },
                          radius: 15,
                          barrierDismissible: false,
                        );
                      },
                    )
                  ],
                )
              : const CustomAppBar(
                  title: 'Your Cart',
                  back: false,
                ),
          backgroundColor: const Color(0xffFDFDFD),
          body: cartController.isAuth.value
              ? buildCartWidgets()
              : Align(
                  alignment: Alignment.center,
                  child: socialMediaPlaceHolder()));
    });
  }

  buildCartWidgets() {
    if (cartController.loading.value) {
      return Center(
          child: LoadingAnimationWidget.flickr(
        leftDotColor: primaryColor,
        rightDotColor: const Color(0xFFFF0084),
        size: 50,
      ));
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
          SizedBox(
            height: 30.h,
          ),
          Expanded(
            child: AnimatedContainer(
              width: 327.w,
              duration: const Duration(milliseconds: 10),
              curve: Curves.slowMiddle,
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];

                  return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Observer(
                          builder: (_) => !item.isDismissible
                              ? Dismissible(
                                  key: Key(item.product.toString()),
                                  background: Container(
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(
                                          width: 0.50,
                                          color: Color(0xFFFAFAFA)),
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.delete,
                                          color: Colors.white, size: 30),
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  onUpdate: (details) {},
                                  confirmDismiss: (direction) async {
                                    //    cartController.removeItem(item);
                                    cartController
                                        .cartItems[index].isDismissible = true;
                                    cartController.cartItems.refresh();

                                    return false; // إعادة false لمنع الحذف
                                  },
                                  onDismissed: (direction) {
                                    //    cartController.removeItem(item);
                                  },
                                  child: itemCart(item.product, item, index))
                              : itemCart(item.product, item, index)));
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
                          SizedBox(
                            height: 16.h,
                          ),
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
                              cartController.step.value = '1';

                              var defaultAddress = addressController.addressList
                                  .firstWhereOrNull(
                                (address) => address.isDefault == 1,
                                // إرجاع null إذا لم يتم العثور على عنوان افتراضي
                              );

                              if (defaultAddress != null) {
                                cartController.shippingID.value =
                                    defaultAddress.id.toString();
                                Get.toNamed(Routes.CHECKOUT);
                              }

                              Get.toNamed(Routes.CHECKOUT);
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
