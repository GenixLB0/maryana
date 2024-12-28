import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:maryana/app/modules/main/views/main_view.dart';
import 'package:maryana/app/modules/product/controllers/product_controller.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:collection/collection.dart';
import 'package:maryana/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart'; // You have to add this manually, for some reason it cannot be added automatically
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  final CartController cartController = Get.put(CartController());
  final ProductController productController = Get.put(ProductController());

  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _handAnimationController;
  late Animation<Offset> _handAnimation;
  late AnimationController _scaleAnimationController;
  late Animation<double> _scaleAnimation;
  List<Product> cartProducts = [];

  //  Uri? _lastProcessedLink;
  // StreamSubscription<String?>? _linkSubscription;

  // Future<void> _handleIncomingLinks() async {
  //   // Handle initial link if app was launched via a deep link
  //   final initialLink = await getInitialLink();
  //   if (initialLink != null) {
  //     _processIncomingLink(Uri.parse(initialLink));
  //   }

  //   // Attach a listener to handle deep links after the app is already started
  //   _linkSubscription = linkStream.listen((String? link) {
  //     if (link != null) {
  //       _processIncomingLink(Uri.parse(link));
  //     }
  //   });
  // }

  // void _processIncomingLink(Uri uri) {
  //   if (_lastProcessedLink == uri) {
  //     print("Duplicate deep link ignored: $uri");
  //     return;
  //   }

  //   // Process only if the path is /cart/ and has query parameters
  //   if (uri.path == '/cart/' && uri.queryParameters.isNotEmpty) {
  //     _lastProcessedLink = uri; // Track the processed link

  //     cartController.shareLoading.value = true;
  //     _processDeepLink(uri);
  //   }
  // }

  // void _processDeepLink(Uri deepLinkUri) async {
  //   String products = deepLinkUri.queryParameters['products'] ?? '';

  //   // Split each product by commas
  //   List<String> productDetails = products.split(',');

  //   for (String productDetail in productDetails) {
  //     // Each productDetail contains id, size, and color, e.g., "59-XXXL-Pink"
  //     List<String> details = productDetail.split('-');
  //     if (details.length == 3) {
  //       String id = details[0];
  //       String size = details[1];
  //       String color = details[2];

  //       // Fetch product by id and assign size and color
  //       await productController.getProduct(id);
  //       var product = productController.product.value;
  //       product.selectedSize = size;
  //       product.selectedColor = color;

  //       cartShareProducts.add(product);
  //     }
  //   }

  //   cartController.shareLoading.value = false;
  //   setState(() {});
  // }

  Future<void> _shareCartWithSingleLink() async {
    cartController.startSharing();

    // Assuming this holds all the products in the cart
    final cartProducts = cartController.cartItems;

    // Combine the product details into a single parameter for easy processing
    List<String> productDetails = cartProducts.map((item) {
      String productId = item.product.id.toString();
      String size = item.selectedSize ?? '';
      String color = item.selectedColor ?? '';
      return "$productId-$size-$color";
    }).toList();

    // Generate a single link that includes the combined product details
    String cartLink =
        'https://mariannela-8c357.web.app/cart/?products=${productDetails.join(',')}';
    print(cartLink + ' share cart link ');

    // Create the message text for sharing
    String cartText = 'Check out these products from our store: $cartLink';

    // Optionally, download product images to share along with the link
    XFile? imageFile;
    if (cartProducts.isNotEmpty) {
      final url = cartProducts.first.product.image;
      final response = await http.get(Uri.parse(url!));
      final documentDirectory = await getApplicationDocumentsDirectory();
      final file =
          File('${documentDirectory.path}/${cartProducts.first.product.id}_image.jpg');
      file.writeAsBytesSync(response.bodyBytes);
      imageFile = XFile(file.path);
    }
    // List<XFile> imageFiles = [];
    // for (var item in cartProducts) {
    //   final url = item.product.image;
    //   final response = await http.get(Uri.parse(url!));
    //   final documentDirectory = await getApplicationDocumentsDirectory();
    //   final file =
    //       File('${documentDirectory.path}/${item.product.id}_image.jpg');
    //   file.writeAsBytesSync(response.bodyBytes);
    //   final xFile = XFile(file.path);
    //   imageFiles.add(xFile);
    // }

    // Share the link with the product images if available
    if (imageFile != null ) {
      Share.shareXFiles([imageFile], text: cartText);
    } else {
      Share.share(cartText); // Just share the text if no images
    }

    cartController.endSharing();
  }

  @override
  void initState() {
    super.initState();
    cartController.fetchCartDetailsFromAPI();
    // _handleIncomingLinks();
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
    // _linkSubscription?.cancel();
    cartShareProducts.clear();
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
                  title: cartShareProducts.isNotEmpty
                      ? 'Shared Cart'
                      : 'Your Cart',
                  back: Navigator.canPop(context),
                  actions: [
                    Obx(() {
                      return cartController.isSharing.value
                          ? Center(
                              child: LoadingAnimationWidget.flickr(
                              leftDotColor: primaryColor,
                              rightDotColor: const Color(0xFFFF0084),
                              size: 30,
                            ))
                          : IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () async {
                                await _shareCartWithSingleLink();
                              },
                            );
                    }),
                    if (cartShareProducts.isEmpty)
                      IconButton(
                        icon: const Icon(
                          Icons.remove_shopping_cart_sharp,
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
                      ),
                    // cartShareProducts.isNotEmpty
                    //     ? InkWell(
                    //         onTap: () {
                    //           Get.off(MainView());
                    //         },
                    //         child: Icon(Icons.home, color: primaryColor))
                    //     : SizedBox()
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

  void addAllToCart() {
    bool missingSelection = false;
    for (var product in cartShareProducts) {
      // Check if color and size are selected
      if (product.selectedSize == null || product.selectedColor == null) {
        Get.snackbar(
            "Error", "Please select size and color for ${product.name}");
        missingSelection = true;
        break;
      }

      // Add product to cart if not already added
      if (!cartController.isProductInCart(product)) {
        cartController.addToCart(
            product, product.selectedSize!, product.selectedColor!);
      }
    }

    if (!missingSelection) {
      setState(() {
        cartShareProducts.clear();
        showDialog(
          context: context,
          builder: (_) => FireworksEffect(),
        );
      });
    }
  }

  Widget shareitemCart(ViewProductData product, int index) {
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
                                      placeHolderWidget(),
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
                          child: product!.colors!.isEmpty &&
                                  product!.selectedColor!.isEmpty
                              ? SizedBox()
                              : Text(
                                  'Size: ${product!.selectedSize.toString()} |  Color: ${product!.selectedColor.toString()}',
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
                  bottom: 20.h,
                  end: 20.w,
                  child: InkWell(
                    onTap: () => {
                      if (userToken != null)
                        {
                          print('teasdsadsa2'),
                          if (cartController.cartItems.any(
                            (element) =>
                                element.product != null &&
                                product != null &&
                                element.selectedSize == product.selectedSize &&
                                element.product.id == product.id,
                          ))
                            {
                              cartController.removeItem(cartController.cartItems
                                  .firstWhere((element) =>
                                      element.product.id == product.id)),
                            },
                          cartController.addToCart(
                            product,
                            product.selectedSize!,
                            product.selectedColor!,
                            quantity: 1,
                          ),
                          cartShareProducts.remove(product),
                          setState(() {}),
                          print('teasdsadsa4'),
                        }
                    },
                    child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: SlideTransition(
                          position: _handAnimation,
                          child: Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                  size: 20.sp, color: Colors.grey),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildCartWidgets() {
    if (cartController.loading.value || cartController.shareLoading.value) {
      return Center(
          child: LoadingAnimationWidget.flickr(
        leftDotColor: primaryColor,
        rightDotColor: const Color(0xFFFF0084),
        size: 50,
      ));
    } else if (cartController.cartItems.isEmpty && cartShareProducts.isEmpty) {
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
          if (cartShareProducts.isNotEmpty)
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.orangeAccent, width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.orangeAccent),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sharing with you some great items from others\' shopping list. ✨',
                      style: primaryTextStyle(
                        color: Colors.orangeAccent,
                        weight: FontWeight.bold,
                        size: 16.round(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (cartShareProducts.isNotEmpty)
            SizedBox(
              height: 30.h,
            ),
          if (cartShareProducts.isNotEmpty)
            Expanded(
              child: AnimatedContainer(
                width: 327.w,
                duration: const Duration(milliseconds: 10),
                curve: Curves.slowMiddle,
                child: ListView.builder(
                  itemCount: cartShareProducts.length,
                  itemBuilder: (context, index) {
                    final item = cartShareProducts[index];

                    return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: shareitemCart(item, index));
                  },
                ),
              ),
            ),
          if (cartShareProducts.isEmpty)
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
                                      cartController.cartItems[index]
                                          .isDismissible = true;
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
          if (cartShareProducts.isNotEmpty)
            Center(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                addAllToCart();
              },
              child: Text("Add All to Cart",
                  style: primaryTextStyle(color: Colors.white)),
            )),
          if (cartShareProducts.isNotEmpty)
            SizedBox(
              height: 30.h,
            ),
          if (cartShareProducts.isEmpty)
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
                                cartController.step.value = '1';

                                var defaultAddress = addressController
                                    .addressList
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
