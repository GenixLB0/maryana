import 'dart:io';
import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:maryana/app/modules/cart/controllers/cart_controller.dart';
import 'package:maryana/app/modules/cart/views/cart_view.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/home/controllers/home_controller.dart';
import 'package:maryana/app/modules/home/views/home_view.dart';
import 'package:maryana/app/modules/main/views/main_view.dart';
import 'package:maryana/app/modules/product/views/FullImage.dart';
import 'package:maryana/app/modules/product/views/size_guide.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';

import '../../../../main.dart';
import '../../global/theme/app_theme.dart';
import '../../global/theme/colors.dart';
import '../../search/views/search_view.dart';
import '../controllers/product_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

final CartController cartController = Get.put(CartController());

class ProductView extends GetView<ProductController> {
  const ProductView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductController().initialized ? null : Get.put(ProductController());
    HomeController homeController = Get.put(HomeController());
    controller.setIndex();

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Obx(() {
          return controller.product.value.image == null
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Search Bar
                        _buildSearchWidget(context),
                        //Carousel Images
                        Opacity(
                          opacity: 0.3,
                          child: controller.placeHolderImg.value.isEmpty
                              ? SizedBox()
                              : Image.network(
                                  controller.placeHolderImg.value,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        LoadingWidget(
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Product Name and Rating
                                _buildProductNameAndStartRating(
                                    context, controller.product.value),
                                //Product Price
                                _buildProductPrice(
                                    context, controller.product.value),

                                //Product Details
                                _buildProductDetails(
                                    context, controller.product.value),
                                //Product Size Guide

                                //Product Reviews
                                _buildProductReviews(
                                    context, controller.product.value),
                              ]),
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Search Bar
                        _buildSearchWidget(context),
                        //Carousel Images
                        GetBuilder<ProductController>(builder: (logic) {
                          print(
                              "the prodicts attaches are ${logic.product.value.attachments!}");
                          return _buildProductImagesCarousel(context,
                              logic.productImages, logic.placeHolderImg.value);
                        }),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //build Small Photos
                              GetBuilder<ProductController>(builder: (logic) {
                                return _buildSmallImagesView();
                              }),

                              //Product Name and Rating
                              _buildProductNameAndStartRating(
                                  context, controller.product.value),
                              //Product Price
                              _buildProductPrice(
                                  context, controller.product.value),

//Product Colors
                              _buildProductColors(context),
                              //Product Details
                              _buildProductDetails(
                                  context, controller.product.value),
                              //Product Size Guide

                              //Product Reviews
                              _buildProductReviews(
                                  context, controller.product.value),

                              //See Also Products
                              _buildSeeAlsoProduct(
                                  context, controller.product.value),
                            ]),
                      ],
                    ),
                  ),
                );
        }),
      ),
      //Product Add To Cart Button
      bottomNavigationBar: Obx(() {
        return controller.product.value.image == null
            ? LoadingWidget(
                ShowUp(
                  delay: 200,
                  child: Container(
                    height: 100.h,
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            height: 2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(
                                      0, -1), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 15.w,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 35.w,
                                  height: 35.h,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 9,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ], borderRadius: BorderRadius.circular(55)),
                                  child: userToken == null
                                      ? InkWell(
                                          child: SvgPicture.asset(
                                            "assets/images/home/add_to_wishlist.svg",
                                            fit: BoxFit.contain,
                                            width: 30.w,
                                            height: 30.h,
                                          ),
                                        )
                                      : Obx(() {
                                          return homeController
                                                  .wishlistProductIds
                                                  .contains(controller
                                                      .product.value.id)
                                              ? InkWell(
                                                  child: SvgPicture.asset(
                                                    "assets/images/home/wishlisted.svg",
                                                    fit: BoxFit.contain,
                                                    width: 30.w,
                                                    height: 30.h,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    if (HomeController()
                                                        .initialized) {
                                                      HomeController
                                                          homeController =
                                                          Get.find<
                                                              HomeController>();
                                                      homeController
                                                          .addToWishlist(
                                                              controller.product
                                                                  .value.id);
                                                    } else {
                                                      HomeController
                                                          homeController =
                                                          Get.put(
                                                              HomeController());
                                                      homeController
                                                          .addToWishlist(
                                                              controller.product
                                                                  .value.id);
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                    "assets/images/home/add_to_wishlist.svg",
                                                    fit: BoxFit.contain,
                                                    width: 30.w,
                                                    height: 30.h,
                                                  ),
                                                );
                                        }),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                child: _buildAddToCartButton(
                                    context, controller.product.value),
                                flex: 15,
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : ShowUp(
                delay: 200,
                child: Container(
                  height: 100.h,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          height: 2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset:
                                    Offset(0, -1), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 15.w,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 35.w,
                                height: 35.h,
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 9,
                                    offset: Offset(
                                        0, 2), // changes position of shadow
                                  ),
                                ], borderRadius: BorderRadius.circular(55)),
                                child: userToken == null
                                    ? InkWell(
                                        onTap: () {
                                          if (HomeController().initialized) {
                                            HomeController homeController =
                                                Get.find<HomeController>();
                                            homeController.addToWishlist(
                                                controller.product.value.id);
                                          } else {
                                            HomeController homeController =
                                                Get.put(HomeController());
                                            homeController.addToWishlist(
                                                controller.product.value.id);
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          "assets/images/home/add_to_wishlist.svg",
                                          fit: BoxFit.contain,
                                          width: 30.w,
                                          height: 30.h,
                                        ),
                                      )
                                    : Obx(() {
                                        return homeController.wishlistProductIds
                                                .contains(
                                                    controller.product.value.id)
                                            ? InkWell(
                                                onTap: () {
                                                  if (HomeController()
                                                      .initialized) {
                                                    HomeController
                                                        homeController =
                                                        Get.find<
                                                            HomeController>();
                                                    homeController
                                                        .removeFromWishlist(
                                                            controller.product
                                                                .value.id);
                                                  } else {
                                                    HomeController
                                                        homeController =
                                                        Get.put(
                                                            HomeController());
                                                    homeController
                                                        .removeFromWishlist(
                                                            controller.product
                                                                .value.id);
                                                  }
                                                },
                                                child: AvatarGlow(
                                                  curve: Curves.fastOutSlowIn,
                                                  glowColor:
                                                      Colors.purpleAccent,
                                                  repeat: false,
                                                  child: SvgPicture.asset(
                                                    "assets/images/home/wishlisted.svg",
                                                    fit: BoxFit.contain,
                                                    width: 30.w,
                                                    height: 30.h,
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  if (HomeController()
                                                      .initialized) {
                                                    HomeController
                                                        homeController =
                                                        Get.find<
                                                            HomeController>();
                                                    homeController
                                                        .addToWishlist(
                                                            controller.product
                                                                .value.id);
                                                  } else {
                                                    HomeController
                                                        homeController =
                                                        Get.put(
                                                            HomeController());
                                                    homeController
                                                        .addToWishlist(
                                                            controller.product
                                                                .value.id);
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  "assets/images/home/add_to_wishlist.svg",
                                                  fit: BoxFit.contain,
                                                  width: 30.w,
                                                  height: 30.h,
                                                ),
                                              );
                                      }),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Expanded(
                              child: _buildAddToCartButton(
                                  context, controller.product.value),
                              flex: 15,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
      }),
      // Back-to-top button
    );
  }

  buildSearchAndFilter(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 65.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 15.w,
          ),
          Flexible(
            flex: 12,
            child: Container(
              child: TextField(
                onSubmitted: (v) {
                  // controller.addSearchKeywords(v);
                  // controller.getSearchResultsFromApi();
                  //
                  //
                  //
                  // Get.to(()=> ResultView());
                },
                autofocus: false,
                style: primaryTextStyle(
                  color: Colors.black,
                  size: 14.sp.round(),
                  weight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey, width: 2)),
                  hintStyle: primaryTextStyle(
                    color: Colors.black,
                    size: 14.sp.round(),
                    weight: FontWeight.w400,
                    height: 1,
                  ),
                  errorStyle: primaryTextStyle(
                    color: Colors.red,
                    size: 14.sp.round(),
                    weight: FontWeight.w400,
                    height: 1,
                  ),
                  labelStyle: primaryTextStyle(
                    color: Colors.grey,
                    size: 14.sp.round(),
                    weight: FontWeight.w400,
                    height: 1,
                  ),
                  labelText: "Search Clothes ...",
                  prefixIcon: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/search.svg',
                      width: 25.w,
                      height: 25.h,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            child: SvgPicture.asset(
              "assets/images/product/upload.svg",
              height: 35.h,
              width: 35.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 15.w,
          )
        ],
      ),
    );
  }

  buildBottomSheet(ViewProductData comingProduct, BuildContext context) {
    final DraggableScrollableController sheetController =
        DraggableScrollableController();
    final ScrollController scrollController = ScrollController();

    return Container(
      height: MediaQuery.of(context).size.height / 3,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 1.0),
          BoxShadow(color: Colors.white70, offset: Offset(0, -1)),
          BoxShadow(color: Colors.white70, offset: Offset(0, 1)),
          BoxShadow(color: Colors.white70, offset: Offset(-1, -1)),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: CustomScrollView(controller: scrollController, slivers: [
        SliverList.list(children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                ///////////////////Size//////////////////////////////
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Size",
                          style: boldTextStyle(
                            size: 18.sp.round(),
                            letterSpacing: 0.8.w,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    controller.product.value.sizeGuide?.fitType == null
                        ? SizedBox()
                        : GestureDetector(
                            onTap: () {
                              Get.to(
                                  () => SizeGuideView(
                                        selectedFitType: controller
                                                .productSizeGuide
                                                .value
                                                .fitType ??
                                            "",
                                        selectedStretch: controller
                                            .productSizeGuide.value.stretch!,
                                        selectedAttr: controller
                                            .productSizeGuide.value.attr!,
                                      ),
                                  transition: Transition.fadeIn,
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 400));
                            },
                            child: LoadingWidget(
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Size Guide",
                                      style: primaryTextStyle(
                                          color: Colors.grey[300]),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.grey[300],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                  ],
                ),
                SizedBox(height: 10.h),

                Column(
                  children: [
                    ShowUp(
                      delay: 300,
                      child: Obx(() {
                        return controller.isProductLoading.value
                            ? loadingIndicatorWidget()
                            : GetBuilder<ProductController>(
                                builder: (logic) {
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    height: 50.h,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctx, index) =>
                                          GestureDetector(
                                        onTap: () {
                                          controller.setSize(
                                              controller.sizeList[index]);
                                        },
                                        child: Container(
                                          width: 45.w,
                                          height: 45.h,
                                          decoration: ShapeDecoration(
                                            color: controller.sizeList[index] ==
                                                    controller
                                                        .selectedSize.value
                                                ? Color(0xFF515151)
                                                : Color(0xFFFAFAFA),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.50),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              controller.sizeList[index],
                                              style: primaryTextStyle(
                                                color: Color(0xffCCCCCC),
                                                size: 15.sp.round(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      separatorBuilder: (ctx, index) =>
                                          SizedBox(width: 5.w),
                                      itemCount: controller.sizeList.length,
                                    ),
                                  );
                                },
                              );
                      }),
                    ),
                  ],
                ),
                ////////////////////////////////////////////////////
                // SizedBox(height: 20.h),
                // /////////////////Color//////////////////////////////
                // Padding(
                //   padding: EdgeInsets.only(left: 15.w),
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: Text(
                //       "Color",
                //       style: boldTextStyle(
                //         size: 18.sp.round(),
                //         letterSpacing: 0.8.w,
                //         color: Colors.grey,
                //       ),
                //     ),
                //   ),
                // ),

                const Spacer(),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.sp),
                      topRight: Radius.circular(20.sp),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      ShowUp(
                        delay: 300,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Row(
                            children: [
                              Text(
                                "SubTotal",
                                style: primaryTextStyle(
                                  size: 17.sp.round(),
                                  weight: FontWeight.w400,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$ ${comingProduct.price!}",
                                style: primaryTextStyle(
                                  size: 17.sp.round(),
                                  weight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      ShowUp(
                        delay: 300,
                        child: GestureDetector(
                          onTap: () {
                            // Handle Add to Cart action
                            if (userToken != null) {
                              print('teasdsadsa');
                              bool isProductInCart =
                                  cartController.cartItems.any(
                                (element) =>
                                    element.product != null &&
                                    controller.product != null &&
                                    element.selectedSize ==
                                        controller.selectedSize.value &&
                                    element.product.id ==
                                        controller.product.value.id,
                              );

                              print('teasdsadsa2');

                              if (isProductInCart) {
                                cartController.removeItem(cartController
                                    .cartItems
                                    .firstWhere((element) =>
                                        element.product.id ==
                                        controller.product.value.id));
                              }
                              print('teasdsadsa3');
                              cartController.loading.value = true;
                              controller.product.value.selectedSize =
                                  controller.selectedSize.value;
                              controller.product.value.selectedColor =
                                  controller.selectedColor.value;
                              if (controller.selectedSize.value.isNotEmpty &&
                                  controller.selectedColor.value.isNotEmpty) {
                                cartController.addToCart(
                                  controller.product.value,
                                  controller.selectedSize.value,
                                  controller.selectedColor.value,
                                  quantity: 1,
                                );
                                print('teasdsadsa4');
                                Get.toNamed(Routes.CART);
                                cartController.loading.value = false;
                              } else {
                                Get.snackbar(
                                    "Error", "Please Select From Options First",
                                    backgroundColor: Colors.white);
                              }
                            } else {
                              Get.to(() => CartPage());
                            }
                          },
                          child: SvgPicture.asset(
                            "assets/images/product/add_to_cart.svg",
                            height: 60.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ])
      ]),
    );
  }

  buildRatingWidget(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(controller.product.value.rating.toString(),
                  style: primaryTextStyle(
                      color: Color(0xFF231F20),
                      height: 0.03,
                      letterSpacing: 0.48,
                      weight: FontWeight.w700,
                      size: 30.sp.round())),
              SizedBox(
                width: 10.w,
              ),
              Text("OUT OF 5",
                  style: secondaryTextStyle(
                      color: Color(0xFF8A8A8F),
                      height: 0.11,
                      letterSpacing: 0.07,
                      weight: FontWeight.w400,
                      size: 12.sp.round())),
              Spacer(),
              controller.product.value.rating == null
                  ? StarRating(
                      isCustomer: false,
                      rating: 0,
                      onRatingChanged: (v) {},
                      color: Color(0xffFFD600))
                  : StarRating(
                      isCustomer: false,
                      rating: controller.product.value.rating!.toDouble(),
                      onRatingChanged: (v) {},
                      color: Color(0xffFFD600))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          buildRatingBar(
              "5",
              controller.product.value.rating_percentages!.isEmpty
                  ? 0
                  : controller.product.value.rating_percentages![4].toDouble()),
          buildRatingBar(
              "4",
              controller.product.value.rating_percentages!.isEmpty
                  ? 0
                  : controller.product.value.rating_percentages![3].toDouble()),
          buildRatingBar(
              "3",
              controller.product.value.rating_percentages!.isEmpty
                  ? 0
                  : controller.product.value.rating_percentages![2].toDouble()),
          buildRatingBar(
              "2",
              controller.product.value.rating_percentages!.isEmpty
                  ? 0
                  : controller.product.value.rating_percentages![1].toDouble()),
          buildRatingBar(
              "1",
              controller.product.value.rating_percentages!.isEmpty
                  ? 0
                  : controller.product.value.rating_percentages![0].toDouble()),
          SizedBox(
            height: 50,
          ),
          _buildCustomersReviews(context)
        ],
      ),
    );
  }

  buildRatingBar(String number, double percentage) {
    return Container(
      height: 30.h,
      child: Row(
        children: [
          Text(number),
          SizedBox(
            width: 2.w,
          ),
          Icon(
            Icons.star,
            color: Color(0xffFFD600),
          ),
          SizedBox(
            width: 4.w,
          ),
          Flexible(
            flex: 12,
            child: LinearPercentIndicator(
              backgroundColor: Colors.grey[300],
              percent: percentage / 100,
              progressColor: Color(0xffFFD600),
              barRadius: Radius.circular(25.w),
            ),
          ),
          Spacer(),
          Text("${(percentage).toInt().toString()} %")
        ],
      ),
    );
  }

  _buildSearchWidget(context) {
    return Column(
      children: [
        SizedBox(
          height: 15.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Container(
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Obx(() {
                  ProductController productController =
                      Get.put(ProductController());
                  return InkWell(
                    onTap: () {
                      productController.isHomeIcon.value
                          ? Get.to(() => MainView())
                          : Get.back();
                    },
                    child: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: productController.isHomeIcon.value
                          ? const Icon(Icons.home)
                          : SvgPicture.asset(
                              "assets/images/forgot_password/Frame 361.svg"),
                    ),
                  );
                }),
                Spacer(),
                Obx(() {
                  return controller.isSharing.value
                      ? Center(
                          child: LoadingAnimationWidget.flickr(
                          leftDotColor: primaryColor,
                          rightDotColor: const Color(0xFFFF0084),
                          size: 30,
                        ))
                      : IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () async {
                            await _shareProductWithImage();
                          },
                        );
                }),
                IconButton(
                  icon: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      width: 26.w,
                      height: 26.h,
                    ),
                  ),
                  onPressed: () {
                    HomeController homeController = HomeController().initialized
                        ? Get.find<HomeController>()
                        : Get.put(HomeController());
                    var products = homeController.homeModel.value.product;
                    var categories = homeController.homeModel.value.categories;

                    Get.to(SearchView(),
                        arguments: [products, categories],
                        transition: Transition.fadeIn,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 400));
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          height: 2,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black12,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }

  Future<void> _shareProductWithImage() async {
    controller.startSharing();
    final url = "${controller.product.value.image}";
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/image.jpg');
    file.writeAsBytesSync(response.bodyBytes);

    final xFile = XFile(file.path);

    Share.shareXFiles([xFile],
        text:
            'Check out this Product: https://mariannela-8c357.web.app/product/?id=${controller.product.value.id} ');
    controller.endSharing();
  }

  _buildProductImagesCarousel(
      BuildContext context, List<Attachments> imgList, placeHolderImg) {
    //adding attachments
    // if (comingProduct.attachments != null) {
    //   for (var img in comingProduct.attachments!) {
    //     if (img.name == "app_show") {
    //       imgList.addNonNull(img);
    //     }
    //   }
    // }

    return ShowUp(
      delay: 200,
      child: Container(
        child: Container(
            height: MediaQuery.of(context).size.height / 2.06,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: ImageSliderWithIndicators(
              imgList: imgList,
              placeHolderImg: placeHolderImg,
            )),
      ),
    );
  }

  _buildProductNameAndStartRating(
      BuildContext context, ViewProductData comingProduct) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        //Name
        Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(comingProduct.name ?? "",
                    style: boldTextStyle(
                        size: 25.sp.round(), letterSpacing: 1.5.w)))),

        //Star Rating
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Row(
            children: [
              StarRating(
                onRatingChanged: (double rating) {},
                color: Colors.green,
                rating: controller.product.value.rating == null
                    ? 0
                    : controller.product.value.rating.toDouble(),
                isCustomer: false,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: comingProduct.rating == null
                    ? Text(
                        "(0)",
                        style: primaryTextStyle(),
                      )
                    : Text(
                        "(${comingProduct.rating.toString()})",
                        style: primaryTextStyle(),
                      ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }

  _buildProductPrice(BuildContext context, ViewProductData comingProduct) {
    return Column(
      children: [
        //Price
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Text("\$ ${comingProduct.price ?? ""}",
              style: primaryTextStyle(
                  size: 27.sp.round(),
                  letterSpacing: 1.7.w,
                  weight: FontWeight.w700)),
        ),
        SizedBox(
          height: 13.h,
        ),
      ],
    );
  }

  _buildProductDetails(BuildContext context, ViewProductData comingProduct) {
    return Column(
      children: [
        //Details
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              Text("Description", style: boldTextStyle(size: 22.sp.round())),
              Spacer(),
              Obx(() => IconButton(
                  onPressed: () {
                    controller.switchShowDescription();
                  },
                  icon: Icon(
                    controller.isShowDescription.value
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_up_outlined,
                    size: 25.w,
                  )))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 7.w),
          height: 1.h,
          color: Colors.grey[300],
        ),
        SizedBox(
          height: 5.h,
        ),
        Obx(() => controller.isShowDescription.value
            ? DescriptionTextWidget(
                text: comingProduct.description ?? "",
              )
            : SizedBox()),
      ],
    );
  }

  _buildSizeGuide(BuildContext context, ViewProductData comingProduct) {
    return Column(
      children: [
        //Details
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              Text("Size Guide", style: boldTextStyle(size: 22.sp.round())),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Get.to(
                        () => SizeGuideView(
                              selectedFitType:
                                  controller.productSizeGuide.value.fitType ??
                                      "",
                              selectedStretch:
                                  controller.productSizeGuide.value.stretch ??
                                      "",
                              selectedAttr:
                                  controller.productSizeGuide.value.attr ?? [],
                            ),
                        transition: Transition.fadeIn,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 400));
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 25.w,
                  ))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 7.w),
          height: 1.h,
          color: Colors.grey[300],
        ),
        SizedBox(
          height: 5.h,
        ),
        Obx(() => controller.isShowDescription.value
            ? DescriptionTextWidget(
                text: comingProduct.description!,
              )
            : SizedBox()),
      ],
    );
  }

  _buildSeeAlsoProduct(BuildContext context, ViewProductData comingProduct) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Reviews
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text("Related Products",
              style: boldTextStyle(size: 22.sp.round())),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 7.w),
          height: 1,
          color: Colors.grey[300],
        ),
        SizedBox(
          height: 15.h,
        ),
        _buildProductGrid(context)
      ],
    );
  }

  _buildProductReviews(BuildContext context, ViewProductData comingProduct) {
    return Column(
      children: [
        //Reviews
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              Text("Reviews", style: boldTextStyle(size: 22.sp.round())),
              Spacer(),
              Obx(() => IconButton(
                  onPressed: () {
                    controller.switchShowReviews();
                  },
                  icon: Icon(
                    controller.isShowReviews.value
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_up_outlined,
                    size: 25.w,
                  )))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 7.w),
          height: 1,
          color: Colors.grey[300],
        ),
        SizedBox(
          height: 5.h,
        ),
        Obx(() => controller.isShowReviews.value
            ? buildRatingWidget(context)
            : SizedBox())
      ],
    );
  }

  _buildAddToCartButton(myContext, ViewProductData comingProduct) {
    return GestureDetector(
      onTap: () {
        controller.changeAddToCartStatus();
        // Future.delayed(Duration(milliseconds: 1700), () {
        //   showMaterialModalBottomSheet(
        //     context: myContext,
        //     backgroundColor: Colors.transparent,
        //     expand: false,
        //     builder: (context) => BackdropFilter(
        //         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        //         child: buildBottomSheet("", "", "", myContext)),
        //   );
        // });
        if (controller.colorsList.length == 1 &&
            controller.sizeList.length == 1) {
          if (userToken != null) {
            print('teasdsadsa');
            bool isProductInCart = cartController.cartItems.any(
              (element) =>
                  element.product != null &&
                  controller.product != null &&
                  element.selectedSize == controller.selectedSize.value &&
                  element.product.id == controller.product.value.id,
            );
            print('teasdsadsa2');

            if (isProductInCart) {
              cartController.removeItem(cartController.cartItems.firstWhere(
                  (element) =>
                      element.product.id == controller.product.value.id));
            }
            print('teasdsadsa3');
            cartController.loading.value = true;
            controller.product.value.selectedSize =
                controller.selectedSize.value;
            controller.product.value.selectedColor =
                controller.selectedColor.value;
            cartController.addToCart(
              controller.product.value,
              controller.selectedSize.value,
              controller.selectedColor.value,
              quantity: 1,
            );
            print('teasdsadsa4');
            Get.toNamed(Routes.CART);
            cartController.loading.value = false;
          } else {
            Get.to(() => CartPage());
          }
        } else {
          if (controller.colorsList.isEmpty && controller.sizeList.isEmpty) {
            if (userToken != null) {
              print('teasdsadsa');
              bool isProductInCart = cartController.cartItems.any(
                (element) =>
                    element.product != null &&
                    controller.product != null &&
                    element.selectedSize == controller.selectedSize.value &&
                    element.product.id == controller.product.value.id,
              );
              print('teasdsadsa2');

              if (isProductInCart) {
                cartController.removeItem(cartController.cartItems.firstWhere(
                    (element) =>
                        element.product.id == controller.product.value.id));
              }
              print('teasdsadsa3');
              cartController.loading.value = true;
              controller.product.value.selectedSize =
                  controller.selectedSize.value;
              controller.product.value.selectedColor =
                  controller.selectedColor.value;
              cartController.addToCart(
                controller.product.value,
                controller.selectedSize.value,
                controller.selectedColor.value,
                quantity: 1,
              );
              print('teasdsadsa4');
              Get.toNamed(Routes.CART);
              cartController.loading.value = false;
            } else {
              Get.to(() => CartPage());
            }
          }
          showMaterialModalBottomSheet(
            context: myContext,
            backgroundColor: Colors.transparent,
            expand: false,
            builder: (context) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: buildBottomSheet(comingProduct, myContext)),
          );
        }
      },
      child: SvgPicture.asset(
        "assets/images/product/add_to_cart.svg",
        fit: BoxFit.contain,
        width: 300.w,
        height: 50.h,
      ),
    );
  }

  _buildCustomersReviews(context) {
    print("the review is  1 ${controller.reviews}");
    return GetBuilder<ProductController>(
        id: "reviews",
        builder: (logic) {
          return controller.isReviewsLoading
              ? placeHolderWidget()
              : controller.reviews.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Reviews Yet ..",
                          style: primaryTextStyle(),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //       left: MediaQuery.of(context).size.width / 3.1),
                        //   child: StarRating(
                        //       rating: 0,
                        //       onRatingChanged: (v) {},
                        //       color: Color(0xffFFD600),
                        //       isCustomer: true),
                        // ),
                        SizedBox(
                          height: 30.h,
                        )
                      ],
                    )
                  : ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          _buildOneCustomerReview(controller.reviews[index]),
                      separatorBuilder: (context, index) => Divider(
                            height: 2,
                            color: Colors.grey[300],
                          ),
                      itemCount: controller.reviews.length);
        });
  }

  _buildOneCustomerReview(ReviewsModel review) {
    print("the review is ${review.title}");
    return Container(
      height: 150.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                backgroundImage:
                    AssetImage("assets/images/profile/profile_placeholder.png"),
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.customer!,
                    style: primaryTextStyle(),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    child: StarRating(
                      rating: review.rating!.toDouble(),
                      onRatingChanged: (v) {},
                      color: Color(0xffFFD600),
                      isCustomer: true,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            overflow: TextOverflow.ellipsis,
            review.title!,
            style: primaryTextStyle(
              weight: FontWeight.w600,
              size: 18.sp.round(),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            overflow: TextOverflow.ellipsis,
            review.comment!,
            style: primaryTextStyle(
              size: 12.sp.round(),
            ),
          ),
        ],
      ),
    );
  }

  _buildProductGrid(context) {
    return GetBuilder<ProductController>(
        id: "related-products",
        builder: (logic) {
          return controller.isRelatedProductsLoading
              ? placeHolderWidget()
              : controller.finalRelatedProducts.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                        child: Text(
                          "No Related Products Yet",
                          style: primaryTextStyle(),
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.1),
                          crossAxisCount: 2,
                          crossAxisSpacing: 5.w),
                      itemBuilder: (context, index) {
                        return buildProductCard(
                            product: controller.finalRelatedProducts[index]);
                      },
                      itemCount: controller.finalRelatedProducts.length,
                    );
        });
  }

  _buildProductColors(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Colors", style: boldTextStyle(size: 22.sp.round())),
          SizedBox(height: 5.h),
          Divider(
            color: Colors.grey[300],
            height: 2,
          ),
          SizedBox(height: 10.h),
          ShowUp(
            delay: 300,
            child: Obx(() {
              return controller.isProductLoading.value
                  ? loadingIndicatorWidget()
                  : GetBuilder<ProductController>(
                      builder: (logic) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          height:
                              70.h, // Increase height to accommodate the text
                          width: MediaQuery.of(context).size.width,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) => GestureDetector(
                              onTap: () {
                                controller.setColor(
                                    controller.colorsList[index].name);
                                controller.changeImagesList(
                                    controller.colorsList[index].name);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 45.w,
                                    height: 45.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.3)),
                                      color: Color(int.parse(
                                          '0xff${controller.colorsList[index].hex!.split('#')[1]}')),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child:
                                              controller.selectedColor.value ==
                                                      controller
                                                          .colorsList[index]
                                                          .name
                                                  ? ShowUp(
                                                      delay: 200,
                                                      child: SvgPicture.asset(
                                                          'assets/images/selected.svg',
                                                          width: 20.w,
                                                          height: 20.w,
                                                          color: controller
                                                                      .colorsList[
                                                                          index]
                                                                      .name ==
                                                                  'White'
                                                              ? Colors.black
                                                              : Colors.white),
                                                    )
                                                  : SizedBox(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height: 5
                                          .h), // Spacing between the circle and the text
                                  Text(
                                    controller.colorsList[index].name ??
                                        '', // Display color name
                                    style: primaryTextStyle(
                                        size: 12.sp.round(),
                                        weight: FontWeight
                                            .w400), // Adjust font size
                                  ),
                                ],
                              ),
                            ),
                            separatorBuilder: (ctx, index) =>
                                SizedBox(width: 5.w),
                            itemCount: controller.colorsList.length,
                          ),
                        );
                      },
                    );
            }),
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  _buildSmallImagesView() {
    return Container(
      margin: EdgeInsets.only(left: 5.w),
      height: 90.h,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) => InkResponse(
                onTap: () {
                  controller.setSelectedIndex(index);
                  controller.setCarouselControllerIndex(index);
                },
                child: Obx(() {
                  return Container(
                      width: 80.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: controller.selectedIndex.value == index
                                  ? Colors.black
                                  : Colors.grey[300]!,
                              width: 3.w)),
                      child: Image.network(
                        controller.productImages[index].path!,
                        fit: BoxFit.cover,
                      ));
                }),
              ),
          separatorBuilder: (context, index) => SizedBox(
                width: 5.w,
              ),
          itemCount: controller.productImages.length),
    );
  }
}

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final bool isCustomer;

  StarRating(
      {this.starCount = 5,
      required this.rating,
      required this.onRatingChanged,
      required this.color,
      required this.isCustomer});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: Colors.grey,
        size: isCustomer ? 17 : 27,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: isCustomer ? 17 : 27,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: isCustomer ? 17 : 27,
      );
    }
    return InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children:
            List.generate(starCount, (index) => buildStar(context, index)));
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf!.isEmpty
          ? Text(
              firstHalf!,
              style: primaryTextStyle(
                  size: 14.sp.round(), weight: FontWeight.w500),
            )
          : Column(
              children: <Widget>[
                Text(
                  flag ? (firstHalf! + "...") : (firstHalf! + secondHalf!),
                  style: primaryTextStyle(
                      size: 14.sp.round(), weight: FontWeight.w500),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(flag ? "show more" : "show less",
                          style: primaryTextStyle(
                              size: 14.sp.round(),
                              weight: FontWeight.w500,
                              color: Colors.blue)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

class BuildBundle extends StatefulWidget {
  const BuildBundle(
      {super.key, required this.image, required this.name, required this.type});

  final String image;
  final String name;
  final String type;

  @override
  State<BuildBundle> createState() => _BuildBundleState();
}

class _BuildBundleState extends State<BuildBundle> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isTapped = !isTapped;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(8.0.h),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(
              color: isTapped ? Colors.black : Colors.transparent, width: 2.w),
          borderRadius: BorderRadius.circular(15.sp),
        ),
        child: Row(
          children: [
            Image.network(
              widget.image,
              width: 50.w,
              height: 50.h,
            ),
            Container(
              width: 100.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: primaryTextStyle(
                        color: Colors.black, size: 15.sp.round()),
                  ),
                  Text(
                    widget.type,
                    overflow: TextOverflow.ellipsis,
                    style: primaryTextStyle(
                        color: Colors.grey, size: 13.sp.round()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSliderWithIndicators extends StatefulWidget {
  const ImageSliderWithIndicators(
      {required this.imgList, required this.placeHolderImg});

  final List<Attachments> imgList;
  final String placeHolderImg;

  @override
  _ImageSliderWithIndicatorsState createState() =>
      _ImageSliderWithIndicatorsState();
}

class _ImageSliderWithIndicatorsState extends State<ImageSliderWithIndicators> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> child = widget.imgList.isEmpty
        ? List.generate(
            3, (int index) => Image.asset("assets/images/placeholder.png"))
        : widget.imgList.map((image) {
            return InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrl: image.path!.toString(),
                      ),
                    )),
                child: Hero(
                    tag: image.path![image.path!.length - 1],
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                              height: MediaQuery.of(context).size.height / 2,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              imageUrl: image.path!,
                            ),
                          ],
                        ),
                      ),
                    )));
          }).toList();

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GetBuilder<ProductController>(builder: (logic) {
              return CarouselSlider(
                carouselController: logic.carouselController,
                items: child,
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  initialPage: logic.selectedIndex.value,
                  aspectRatio: 1.1,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    logic.setSelectedIndex(index);

                    setState(() {});
                  },
                ),
              );
            }),
            Container(
              margin: EdgeInsets.only(top: 20),
              // Add margin to the top side
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white12,
                    //Color.fromARGB(255, 218, 218, 218),
                    blurRadius: 2.0,
                    offset: Offset(0, -2), // Shadow only at the top
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
                color: Colors.white,
              ),
              height: 30.h,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imgList.map((image) {
                  int index = widget.imgList.indexOf(image);
                  return GetBuilder<ProductController>(builder: (logic) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: logic.selectedIndex.value == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  });
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
