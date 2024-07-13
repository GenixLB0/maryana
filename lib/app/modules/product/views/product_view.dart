import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:nb_utils/nb_utils.dart'
    hide primaryTextStyle
    hide boldTextStyle
    hide secondaryTextStyle;

import '../../global/theme/app_theme.dart';
import '../controllers/product_controller.dart';

final globalKey = GlobalKey<ScaffoldState>();

class ProductView extends GetView<ProductController> {
  const ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductController().initialized ? null : Get.put(ProductController());
    controller.setIndex();
    ViewProductData? comingProduct = Get.arguments as ViewProductData;

    print("incoming pro is ${comingProduct}");

    return Scaffold(
      backgroundColor: Colors.white,
      key: globalKey,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Search Bar
                _buildSearchWidget(context),
                //Carousel Images
                _buildProductImagesCarousel(context, comingProduct),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Product Name and Rating
                      _buildProductNameAndStartRating(context, comingProduct),
                      //Product Price
                      _buildProductPrice(context, comingProduct),
                      //Product Details
                      _buildProductDetails(context, comingProduct),
                      //Product Reviews
                      _buildProductReviews(context, comingProduct),
                    ]),
              ],
            ),
          ),
        ),
      ),
      //Product Add To Cart Button
      bottomNavigationBar: ShowUp(
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
                        offset: Offset(0, -1), // changes position of shadow
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
                    Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 9,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ], borderRadius: BorderRadius.circular(55)),
                      child: SvgPicture.asset(
                        "assets/images/home/add_to_wishlist.svg",
                        fit: BoxFit.contain,
                        width: 30.w,
                        height: 30.h,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                      child: _buildAddToCartButton(context, comingProduct),
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

  buildBottomSheet(ViewProductData comingProduct, context) {
    final DraggableScrollableController sheetController =
        DraggableScrollableController();

    final ScrollController scrollController = ScrollController();
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 1.0,
            ),
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
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  ///////////////////Size//////////////////////////////
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Size",
                          style: boldTextStyle(
                              size: 18.sp.round(),
                              letterSpacing: 0.8.w,
                              color: Colors.grey),
                        )),
                  ),

                  ShowUp(
                    delay: 300,
                    child: Obx(() {
                      return controller.isProductLoading.value
                          ? loadingIndicatorWidget()
                          : GetBuilder<ProductController>(
                              // assignId: true,
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
                                                  color: controller.sizeList[
                                                              index] ==
                                                          controller
                                                              .selectedSize
                                                              .value
                                                      ? Color(0xFF515151)
                                                      : Color(0xFFFAFAFA),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.50),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    controller.sizeList[index],
                                                    style: primaryTextStyle(
                                                        color:
                                                            Color(0xffCCCCCC),
                                                        size: 15.sp.round()),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        separatorBuilder: (ctx, index) =>
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                        itemCount: controller.sizeList.length));
                              },
                            );
                    }),
                  ),
                  ////////////////////////////////////////////////////
                  SizedBox(
                    height: 20.h,
                  ),
                  /////////////////Color//////////////////////////////
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Color",
                          style: boldTextStyle(
                              size: 18.sp.round(),
                              letterSpacing: 0.8.w,
                              color: Colors.grey),
                        )),
                  ),
                  ShowUp(
                    delay: 300,
                    child: Obx(() {
                      return controller.isProductLoading.value
                          ? loadingIndicatorWidget()
                          : GetBuilder<ProductController>(
                              // assignId: true,
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
                                                controller.setColor(controller
                                                    .colorsList[index]);
                                              },
                                              child: Container(
                                                width: 45.w,
                                                height: 45.h,
                                                decoration: ShapeDecoration(
                                                  color: controller.colorsList[
                                                              index] ==
                                                          controller
                                                              .selectedColor
                                                              .value
                                                      ? const Color(0xFF515151)
                                                      : const Color(0xFFFAFAFA),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.50),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    controller
                                                        .colorsList[index],
                                                    style: primaryTextStyle(
                                                        color:
                                                            Color(0xffCCCCCC),
                                                        size: 15.sp.round()),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        separatorBuilder: (ctx, index) =>
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                        itemCount:
                                            controller.colorsList.length));
                              },
                            );
                    }),
                  ),
                  /////////////////////////////////////////////////////////////
                  //show the bundles
                  // ShowUp(
                  //   delay: 300,
                  //   child: Column(
                  //     children: [
                  //       //Color
                  //       Padding(
                  //         padding: EdgeInsets.only(left: 15.w),
                  //         child: Row(
                  //           children: [
                  //             Align(
                  //                 alignment: Alignment.topLeft,
                  //                 child: Text(
                  //                   "Bundles",
                  //                   style: boldTextStyle(
                  //                       size: 18.sp.round(),
                  //                       color: Colors.grey,
                  //                       letterSpacing: 0.8.w),
                  //                 )),
                  //             Spacer(),
                  //             // Obx(() {
                  //             //   return Align(
                  //             //       alignment: Alignment.topRight,
                  //             //       child: Text(
                  //             //         "Left in Stock : ${controller.currentStock.value.toString()}",
                  //             //         style: boldTextStyle(
                  //             //             size: 18.sp.round(),
                  //             //             color: Colors.grey,
                  //             //             letterSpacing: 0.8.w),
                  //             //       ));
                  //             // }),
                  //             SizedBox(
                  //               width: 15.w,
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //       // GetBuilder<ProductController>(
                  //       //   // assignId: true,
                  //       //   builder: (logic) {
                  //       //     return Container(
                  //       //         margin: EdgeInsets.symmetric(horizontal: 15.w),
                  //       //         height: 100.h,
                  //       //         width: MediaQuery.of(context).size.width,
                  //       //         child: ListView.separated(
                  //       //             scrollDirection: Axis.horizontal,
                  //       //             itemBuilder: (ctx, index) =>
                  //       //                 GestureDetector(
                  //       //                     onTap: () {
                  //       //                       print("tapped oustide !");
                  //       //                       // controller.setColor(color);
                  //       //                     },
                  //       //                     child:
                  //       //                     BuildBundle(
                  //       //                       image: controller
                  //       //                           .bundles[index].image!,
                  //       //                       name: controller
                  //       //                           .bundles[index].name!,
                  //       //                       type: controller
                  //       //                           .bundles[index].type!,
                  //       //                     )),
                  //       //             separatorBuilder: (ctx, index) => SizedBox(
                  //       //                   width: 5.w,
                  //       //                 ),
                  //       //             itemCount: controller.bundles.length));
                  //       //   },
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                  const Spacer(),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.sp),
                          topRight: Radius.circular(20.sp)),
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
                        SizedBox(
                          height: 15.h,
                        ),
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
                                      weight: FontWeight.w400),
                                ),
                                Spacer(),
                                Text(
                                  "\$ ${controller.product!.price!}",
                                  style: primaryTextStyle(
                                      size: 17.sp.round(),
                                      weight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        ShowUp(
                            delay: 300,
                            child: GestureDetector(
                              onTap: () {
                                //todo
                                // take Product arguments from here
                                ViewProductData product = controller.product!;

                                //todo
                                //Nav To Cart Screen
                                //Setted to Main Screen for now
                                Get.toNamed(Routes.MAIN);
                              },
                              child: SvgPicture.asset(
                                "assets/images/product/proced_to_checkout.svg",
                                height: 60.h,
                                fit: BoxFit.cover,
                              ),
                            )),
                        SizedBox(
                          height: 15.h,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ])
        ]));
  }

  buildRatingWidget() {
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
              Text("4.2",
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
              StarRating(
                  rating: 4, onRatingChanged: (v) {}, color: Color(0xffFFD600))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          buildRatingBar("5", 0.3),
          buildRatingBar("4", 0.7),
          buildRatingBar("3", 0.2),
          buildRatingBar("2", 0.1),
          buildRatingBar("1", 0.0),
          SizedBox(
            height: 50,
          )
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
              percent: percentage,
              progressColor: Color(0xffFFD600),
              barRadius: Radius.circular(25.w),
            ),
          ),
          Spacer(),
          Text("${(percentage * 100).toInt().toString()} %")
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
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
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
                    child: SvgPicture.asset(
                        "assets/images/forgot_password/Frame 361.svg"),
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 20,
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

  _buildProductImagesCarousel(
      BuildContext context, ViewProductData comingProduct) {
    List<Attachments> imgList = [];
    //adding attachments
    if (comingProduct.attachments != null) {
      for (var img in comingProduct.attachments!) {
        if (img.name == "app_show") {
          imgList.addNonNull(img);
        }
      }
    }

    return ShowUp(
      delay: 200,
      child: Container(
        child: Container(
            height: MediaQuery.of(context).size.height / 2.2,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: ImageSliderWithIndicators(
              imgList: imgList,
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
              child: Text(comingProduct.name!,
                  style:
                      boldTextStyle(size: 25.sp.round(), letterSpacing: 1.5.w)),
            )),

        //Star Rating
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Row(
            children: [
              StarRating(
                onRatingChanged: (double rating) {},
                color: Colors.green,
                rating: 4,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  "(54)",
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
          child: Text("\$ ${comingProduct.price!}",
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
                text: comingProduct.description!,
              )
            : SizedBox()),
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
        Obx(() =>
            controller.isShowReviews.value ? buildRatingWidget() : SizedBox())
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
        showMaterialModalBottomSheet(
          context: myContext,
          backgroundColor: Colors.transparent,
          expand: false,
          builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: buildBottomSheet(comingProduct, myContext)),
        );
      },
      child:
          // controller.isAddToCartActive.value
          //     ? Lottie.asset(
          //         "assets/images/product/added_to_cart.json",
          //         width: 200.w,
          //         height: 70.h,
          //         fit: BoxFit.contain,
          //       )
          //     :
          SvgPicture.asset(
        "assets/images/product/add_to_cart.svg",
        fit: BoxFit.contain,
        width: 300.w,
        height: 50.h,
      ),
    );
  }
}

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating(
      {this.starCount = 5,
      required this.rating,
      required this.onRatingChanged,
      required this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = const Icon(
        Icons.star_border,
        color: Colors.grey,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: 27,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: 27,
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
  const ImageSliderWithIndicators({required this.imgList});

  final List<Attachments> imgList;

  @override
  _ImageSliderWithIndicatorsState createState() =>
      _ImageSliderWithIndicatorsState();
}

class _ImageSliderWithIndicatorsState extends State<ImageSliderWithIndicators> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> child = widget.imgList.isEmpty
        ? List.generate(
            1, (int index) => Image.asset("assets/images/placeholder.png"))
        : widget.imgList.map((image) {
            return Container(
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
            );
          }).toList();

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CarouselSlider(
              items: child,
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 1.1,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  _current = index;
                  setState(() {});
                },
              ),
            ),
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
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
