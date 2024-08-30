import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/product/controllers/product_controller.dart';
import 'package:maryana/app/modules/search/controllers/search_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../routes/app_pages.dart';
import '../../global/config/configs.dart';
import '../../global/theme/app_theme.dart';
import '../../search/views/result_view.dart';
import '../controllers/shop_controller.dart';

class ShopView extends GetView<ShopController> {
  const ShopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ShopController());

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          ShowUp(
            delay: 200,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Discover",
                style: primaryTextStyle(
                    size: 22.sp.round(), weight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          buildSearchAndFilter(
              height: 55,
              context: context,
              isSearch: false,
              categories: controller.categories,
              products: controller.products),
          SizedBox(
            height: 5.h,
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
                  offset: Offset(-5, 0), // changes position of shadow
                ),
              ],
            ),
          ),

          _buildCategories(context),
          // Obx(() {
          //   return Expanded(
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 10.w),
          //       child: CustomScrollView(
          //         slivers: [
          //           SliverToBoxAdapter(
          //               child: SizedBox(
          //             height: 15.h,
          //           )),
          //           SliverToBoxAdapter(
          //             child: Align(
          //               alignment: Alignment.topLeft,
          //               child: Text(
          //                 "Shop By Categories",
          //                 style: boldTextStyle(
          //                     weight: FontWeight.w400, size: 23.sp.round()),
          //               ),
          //             ),
          //           ),
          //           controller.isCategoryLoading.value
          //               ? SliverToBoxAdapter(
          //                   child: loadingIndicatorWidget(),
          //                 )
          //               : SliverGrid(
          //                   gridDelegate:
          //                       SliverGridDelegateWithFixedCrossAxisCount(
          //                           crossAxisCount: 3,
          //                           childAspectRatio: MediaQuery.of(context)
          //                                   .size
          //                                   .width /
          //                               (MediaQuery.of(context).size.height /
          //                                   1.2),
          //                           mainAxisSpacing: 5.h,
          //                           crossAxisSpacing: 5.w // Adjust as needed
          //                           ),
          //                   delegate: SliverChildBuilderDelegate(
          //                     (BuildContext context, int index) {
          //                       return controller.categories.isEmpty
          //                           ? Text("No Categories Yet ...")
          //                           : ShowUp(
          //                               delay: 300,
          //                               child: Container(
          //                                 margin: EdgeInsets.symmetric(
          //                                     horizontal: 2.w),
          //                                 decoration: BoxDecoration(
          //                                   color: Colors.white,
          //                                   borderRadius:
          //                                       BorderRadius.circular(4.sp),
          //                                   boxShadow: const [
          //                                     BoxShadow(
          //                                         color: Colors.black12,
          //                                         spreadRadius: 0,
          //                                         blurRadius: 15),
          //                                   ],
          //                                 ),
          //                                 child: controller.categories[index]
          //                                             .image !=
          //                                         null
          //                                     ? Column(
          //                                         crossAxisAlignment:
          //                                             CrossAxisAlignment.start,
          //                                         children: [
          //                                           controller.categories[index]
          //                                                   .image!.isEmpty
          //                                               ? placeHolderWidget()
          //                                               : Stack(
          //                                                   alignment: Alignment
          //                                                       .topRight,
          //                                                   children: [
          //                                                     CachedNetworkImage(
          //                                                       imageUrl: controller
          //                                                           .categories[
          //                                                               index]
          //                                                           .image!,
          //                                                       width: 135.w,
          //                                                       height: 120.h,
          //                                                       fit: BoxFit
          //                                                           .cover,
          //                                                       placeholder:
          //                                                           (ctx, v) {
          //                                                         return placeHolderWidget();
          //                                                       },
          //                                                     ),
          //                                                   ],
          //                                                 ),
          //                                           SizedBox(
          //                                             height: 3.h,
          //                                           ),
          //                                           Padding(
          //                                             padding: EdgeInsets.only(
          //                                                 left: 5.w),
          //                                             child: Text(
          //                                               controller
          //                                                   .categories[index]
          //                                                   .name!,
          //                                               style: primaryTextStyle(
          //                                                   weight:
          //                                                       FontWeight.w700,
          //                                                   size: 16.sp.round(),
          //                                                   color:
          //                                                       Colors.black),
          //                                             ),
          //                                           ),
          //                                           SizedBox(
          //                                             height: 1.h,
          //                                           ),
          //                                         ],
          //                                       )
          //                                     : placeHolderWidget(),
          //                               ),
          //                             );
          //                     },
          //                     childCount: controller.categories.length,
          //                   ),
          //                 ),
          //           SliverToBoxAdapter(
          //               child: SizedBox(
          //             height: 15.h,
          //           )),
          //           SliverToBoxAdapter(
          //             child: Align(
          //               alignment: Alignment.topLeft,
          //               child: Text(
          //                 "Latest Products",
          //                 style: boldTextStyle(
          //                     weight: FontWeight.w400, size: 23.sp.round()),
          //               ),
          //             ),
          //           ),
          //           controller.isProductLoading.value
          //               ? SliverToBoxAdapter(
          //                   child: loadingIndicatorWidget(),
          //                 )
          //               : SliverGrid(
          //                   gridDelegate:
          //                       SliverGridDelegateWithFixedCrossAxisCount(
          //                           childAspectRatio: MediaQuery.of(context)
          //                                   .size
          //                                   .width /
          //                               (MediaQuery.of(context).size.height /
          //                                   1.2),
          //                           crossAxisCount: 2,
          //                           crossAxisSpacing: 5.w // Adjust as needed
          //                           ),
          //                   delegate: SliverChildBuilderDelegate(
          //                     (BuildContext context, int index) {
          //                       return controller.products.isEmpty
          //                           ? const Text("No Products Yet ...")
          //                           : ShowUp(
          //                               delay: 300,
          //                               child: GestureDetector(
          //                                 onTap: () {
          //                                   if (ProductController()
          //                                       .initialized) {
          //                                     Get.find<ProductController>();
          //                                     Get.toNamed(Routes.PRODUCT,
          //                                         arguments: controller
          //                                             .products[index]);
          //                                   } else {
          //                                     Get.put<ProductController>(
          //                                         ProductController());
          //                                     Get.toNamed(Routes.PRODUCT,
          //                                         arguments: controller
          //                                             .products[index]);
          //                                   }
          //                                 },
          //                                 child: Container(
          //                                   decoration: BoxDecoration(
          //                                     color: Colors.white,
          //                                     borderRadius:
          //                                         BorderRadius.circular(4.sp),
          //                                     boxShadow: const [
          //                                       BoxShadow(
          //                                           color: Colors.black12,
          //                                           spreadRadius: 0,
          //                                           blurRadius: 15),
          //                                     ],
          //                                   ),
          //                                   child: controller.products[index]
          //                                               .image !=
          //                                           null
          //                                       ? Column(
          //                                           crossAxisAlignment:
          //                                               CrossAxisAlignment
          //                                                   .start,
          //                                           children: [
          //                                             controller.products[index]
          //                                                     .image!.isEmpty
          //                                                 ? placeHolderWidget()
          //                                                 : Stack(
          //                                                     alignment:
          //                                                         Alignment
          //                                                             .topRight,
          //                                                     children: [
          //                                                       CachedNetworkImage(
          //                                                         imageUrl: controller
          //                                                             .products[
          //                                                                 index]
          //                                                             .image!,
          //                                                         width: 175.w,
          //                                                         height: 210.h,
          //                                                         fit: BoxFit
          //                                                             .cover,
          //                                                         placeholder:
          //                                                             (ctx, v) {
          //                                                           return placeHolderWidget();
          //                                                         },
          //                                                       ),
          //                                                       Padding(
          //                                                         padding:
          //                                                             const EdgeInsets
          //                                                                 .all(
          //                                                                 8.0),
          //                                                         child:
          //                                                             SvgPicture
          //                                                                 .asset(
          //                                                           "assets/images/home/add_to_wishlist.svg",
          //                                                           width: 33.w,
          //                                                           height:
          //                                                               33.h,
          //                                                           fit: BoxFit
          //                                                               .cover,
          //                                                         ),
          //                                                       )
          //                                                     ],
          //                                                   ),
          //                                             SizedBox(
          //                                               height: 3.h,
          //                                             ),
          //                                             Padding(
          //                                               padding:
          //                                                   EdgeInsets.only(
          //                                                       left: 5.w),
          //                                               child: Text(
          //                                                 controller
          //                                                     .products[index]
          //                                                     .name!,
          //                                                 style:
          //                                                     primaryTextStyle(
          //                                                         weight:
          //                                                             FontWeight
          //                                                                 .w700,
          //                                                         size: 16
          //                                                             .sp
          //                                                             .round(),
          //                                                         color: Colors
          //                                                             .black),
          //                                               ),
          //                                             ),
          //                                             SizedBox(
          //                                               height: 1.h,
          //                                             ),
          //                                             Container(
          //                                               padding:
          //                                                   EdgeInsets.only(
          //                                                       left: 5.w),
          //                                               width: 150.w,
          //                                               child: Text(
          //                                                 controller
          //                                                     .products[index]
          //                                                     .description!,
          //                                                 overflow: TextOverflow
          //                                                     .ellipsis,
          //                                                 style: primaryTextStyle(
          //                                                     weight: FontWeight
          //                                                         .w300,
          //                                                     size:
          //                                                         14.sp.round(),
          //                                                     color: Color(
          //                                                         0xff9B9B9B)),
          //                                               ),
          //                                             ),
          //                                             SizedBox(
          //                                               height: 1.h,
          //                                             ),
          //                                             Padding(
          //                                               padding:
          //                                                   EdgeInsets.only(
          //                                                       left: 5.w),
          //                                               child: Text(
          //                                                 "\$ ${controller.products[index].price!} ",
          //                                                 style: primaryTextStyle(
          //                                                     weight: FontWeight
          //                                                         .w600,
          //                                                     size:
          //                                                         15.sp.round(),
          //                                                     color: Color(
          //                                                         0xff370269)),
          //                                               ),
          //                                             ),
          //                                           ],
          //                                         )
          //                                       : placeHolderWidget(),
          //                                 ),
          //                               ),
          //                             );
          //                     },
          //                     childCount: controller.products.length,
          //                   ),
          //                 ),
          //         ],
          //       ),
          //     ),
          //   );
          // }),
        ],
      ),
    ));
  }

  buildShopByCategories(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: smallSpacing),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Shop By Categories",
                style:
                    boldTextStyle(weight: FontWeight.w400, size: 23.sp.round()),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.3),
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.w),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.sp),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 0,
                            blurRadius: 15),
                      ],
                    ),
                    child: controller.categories[index].image != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller.categories[index].image!.isEmpty
                                  ? placeHolderWidget()
                                  : Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: controller
                                              .categories[index].image!,
                                          width: 135.w,
                                          height: 120.h,
                                          fit: BoxFit.cover,
                                          placeholder: (ctx, v) {
                                            return placeHolderWidget();
                                          },
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Text(
                                  controller.categories[index].name!,
                                  style: primaryTextStyle(
                                      weight: FontWeight.w700,
                                      size: 16.sp.round(),
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                            ],
                          )
                        : placeHolderWidget(),
                  );
                },
                itemCount: controller.categories.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  buildShopByProducts(BuildContext context) {
    return Expanded(
      flex: 12,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: smallSpacing),
        child: controller.products.isEmpty
            ? Text("Empty")
            : Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Latest Products",
                      style: boldTextStyle(
                          weight: FontWeight.w400, size: 23.sp.round()),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Expanded(
                      child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.2),
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.w),
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.sp),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 0,
                                  blurRadius: 15),
                            ],
                          ),
                          child: controller.products[index].image != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    controller.products[index].image!.isEmpty
                                        ? placeHolderWidget()
                                        : Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: controller
                                                    .products[index].image!,
                                                width: 175.w,
                                                height: 210.h,
                                                fit: BoxFit.cover,
                                                placeholder: (ctx, v) {
                                                  return placeHolderWidget();
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SvgPicture.asset(
                                                  "assets/images/home/add_to_wishlist.svg",
                                                  width: 33.w,
                                                  height: 33.h,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            ],
                                          ),
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: Text(
                                        controller.products[index].name!,
                                        style: primaryTextStyle(
                                            weight: FontWeight.w700,
                                            size: 16.sp.round(),
                                            color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 5.w),
                                      width: 150.w,
                                      child: Text(
                                        controller.products[index].description!,
                                        overflow: TextOverflow.ellipsis,
                                        style: primaryTextStyle(
                                            weight: FontWeight.w300,
                                            size: 14.sp.round(),
                                            color: Color(0xff9B9B9B)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: Text(
                                        "\$ ${controller.products[index].price!} ",
                                        style: primaryTextStyle(
                                            weight: FontWeight.w600,
                                            size: 15.sp.round(),
                                            color: Color(0xff370269)),
                                      ),
                                    ),
                                  ],
                                )
                              : placeHolderWidget());
                    },
                    itemCount: controller.products.length,
                  ))
                ],
              ),
      ),
    );
  }

  _buildCategories(context) {
    return Obx(() {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                    child: ScrollablePositionedList.separated(
                        scrollDirection: Axis.vertical,
                        itemScrollController:
                            controller.categoriesScrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (controller.choosenCatId.value ==
                              controller.categories[index].id.toString()) {
                            controller.sendchosenCatIndex(index);
                          }

                          print("categories count is ${index}");
                          return controller.isCategoryLoading.value
                              ? placeHolderWidget()
                              : Obx(() {
                                  return VisibilityDetector(
                                    onVisibilityChanged: (visibilityInfo) {
                                      var visiblePercentage =
                                          visibilityInfo.visibleFraction * 100;
                                      if (controller.choosenCatId.value ==
                                          index.toString()) {
                                        debugPrint(
                                            'Chosen Cat Widget Collection ${visibilityInfo.key} is ${visiblePercentage}% visible');
                                      }
                                    },
                                    key: Key("chosenCat${index}"),
                                    child: Container(
                                      color: controller.choosenCatId.value ==
                                              controller.categories[index].id!
                                                  .toString()
                                          ? Colors.white
                                          : Colors.grey[200],
                                      child: AnimatedOpacity(
                                          opacity: 1,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeInOut,
                                          child: InkWell(
                                            onTap: controller
                                                    .isSubCategoriesLoading
                                                    .value
                                                ? () {}
                                                : () {
                                                    controller
                                                        .changeChoosenCatId(
                                                            controller
                                                                .categories[
                                                                    index]
                                                                .id!
                                                                .toString(),
                                                            controller
                                                                .categories[
                                                                    index]
                                                                .name!);

                                                    controller
                                                        .getSubCategoriesInCategory(
                                                            controller
                                                                .categories[
                                                                    index]
                                                                .id!);

                                                    // controller.getBrandsInCategory(
                                                    //     controller
                                                    //         .categories[index].id!);
                                                  },
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 1.w),
                                                child: Row(
                                                  children: [
                                                    controller.choosenCatId
                                                                .value ==
                                                            controller
                                                                .categories[
                                                                    index]
                                                                .id!
                                                                .toString()
                                                        ? Container(
                                                            color: Colors.black,
                                                            width: 5.w,
                                                            height: 20.h,
                                                          )
                                                        // : SizedBox(),
                                                        : Container(
                                                            color: Colors
                                                                .transparent,
                                                            width: 5.w,
                                                            height: 20.h,
                                                          ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.5,
                                                      ),
                                                      height: 45.h,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          controller
                                                              .categories[index]
                                                              .name!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: primaryTextStyle(
                                                              size:
                                                                  13.sp.round(),
                                                              color:
                                                                  Colors.black,
                                                              weight: controller
                                                                          .choosenCatId
                                                                          .value ==
                                                                      controller
                                                                          .categories[
                                                                              index]
                                                                          .id!
                                                                          .toString()
                                                                  ? FontWeight
                                                                      .w600
                                                                  : FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          )),
                                    ),
                                  );
                                });
                        },
                        separatorBuilder: (context, index) => SizedBox(),
                        itemCount: controller.isCategoryLoading.value
                            ? 10
                            : controller.categories.length),
                  ),
                )),
            SizedBox(
              width: 10.w,
            ),
            Expanded(flex: 4, child: _buildBrandsAndSubCategories(context))
          ],
        ),
      );
    });
  }

  _buildBrandsAndSubCategories(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.h,
        ),
        Text(
          "Shop By Category",
          style: primaryTextStyle(
              size: 13.sp.round(), weight: FontWeight.w700, wordSpacing: 0.6),
        ),
        SizedBox(
          height: 10.h,
        ),
        // _buildTopBrands(context),
        // Text("SHOP BY SUBCATEGORIES",
        //     style: boldTextStyle(size: 16.sp.round(), weight: FontWeight.w400)),
        _buildSubCategories(context),
      ],
    );
  }

  _buildTopBrands(context) {
    return Obx(() {
      return controller.isBrandsLoading.value
          ? Expanded(
              child: LoadingWidget(Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: GridView.count(
                    crossAxisCount: 4,
                    padding: EdgeInsets.all(8.w),
                    crossAxisSpacing: 10.h,
                    mainAxisSpacing: 10,
                    childAspectRatio: 6 / 7,
                    shrinkWrap: true,
                    children: <Widget>[
                      for (int i = 0; i < 12; ++i)
                        Container(
                            width: 100.w,
                            color: Color.fromARGB(255, 10 * i, 1 * i, 50))
                    ],
                  ))),
            )
          : controller.brands.isEmpty
              ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 9,
                      top: MediaQuery.of(context).size.height / 9,
                    ),
                    child: Text(
                      "No Brands Yet ..",
                      style: primaryTextStyle(
                          size: 12.sp.round(),
                          color: Colors.black,
                          weight: FontWeight.w400),
                    ),
                  ),
                )
              : Expanded(
                  child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: GridView.count(
                          crossAxisCount: 4,
                          padding: EdgeInsets.all(8.w),
                          crossAxisSpacing: 10.h,
                          mainAxisSpacing: 10,
                          childAspectRatio: 6 / 7,
                          shrinkWrap: true,
                          children: controller.brands
                              .map((brand) => GestureDetector(
                                    onTap: () {
                                      if (CustomSearchController()
                                          .initialized) {
                                        CustomSearchController mycontroller =
                                            Get.find<CustomSearchController>();
                                        mycontroller.getProductsInSection(
                                            sectionName: brand.name!,
                                            payload: {
                                              "brand_ids[0]":
                                                  brand.id.toString(),
                                              "category_ids[0]": controller
                                                  .choosenCatId
                                                  .toString(),
                                            });

                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 800));
                                      } else {
                                        CustomSearchController mycontroller =
                                            Get.put<CustomSearchController>(
                                                CustomSearchController());
                                        mycontroller.getProductsInSection(
                                            sectionName: brand.name!,
                                            payload: {
                                              "brand_ids[0]":
                                                  brand.id.toString(),
                                              "category_ids[0]": controller
                                                  .choosenCatId
                                                  .toString(),
                                            });

                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 800));
                                      }
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: CachedNetworkImage(
                                        imageUrl: brand.image!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ))
                              .toList())),
                );
    });
  }

  _buildSubCategories(context) {
    return Obx(() {
      return controller.isSubCategoriesLoading.value
          ? Expanded(
              child: LoadingWidget(Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(8.w),
                    crossAxisSpacing: 10.h,
                    mainAxisSpacing: 10,
                    childAspectRatio: 6 / 7,
                    shrinkWrap: true,
                    children: <Widget>[
                      for (int i = 0; i < 9; ++i)
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 35, // Adjust the radius as needed
                        ),
                      // Container(
                      //     width: 100.w,
                      //     color: Color.fromARGB(255, 10 * i, 1 * i, 50))
                    ],
                  ))),
            )
          : controller.subCategories.isEmpty
              ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 9,
                      top: MediaQuery.of(context).size.height / 9,
                    ),
                    child: Text(
                      "No SubCategories Yet ..",
                      style: primaryTextStyle(
                          size: 12.sp.round(),
                          color: Colors.black,
                          weight: FontWeight.w400),
                    ),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 10.0, // Spacing between columns
                          mainAxisSpacing: 10.0, // Spacing between rows
                          childAspectRatio: 0.56, // Aspect ratio of each item
                        ),
                        itemCount:
                            controller.subCategories.length, // Number of items
                        itemBuilder: (context, index) {
                          ShopController shopController =
                              Get.find<ShopController>();
                          return index == 0
                              ? InkWell(
                                  onTap: () {
                                    Map<String, dynamic> payload = {};
                                    int i = 0;
                                    for (var category
                                        in controller.subCategories) {
                                      payload["category_ids[${i}]"] =
                                          category.id.toString();
                                      i++;
                                    }
                                    if (CustomSearchController().initialized) {
                                      CustomSearchController controller =
                                          Get.find<CustomSearchController>();
                                      controller.getProductsInSection(
                                          sectionName: shopController
                                              .choosenCatName.value,
                                          payload: payload);

                                      Get.to(() => const ResultView(),
                                          transition: Transition.fadeIn,
                                          curve: Curves.easeInOut,
                                          duration: const Duration(
                                              milliseconds: 800));
                                    } else {
                                      CustomSearchController controller =
                                          Get.put(CustomSearchController());
                                      controller.getProductsInSection(
                                          sectionName: shopController
                                              .choosenCatName.value,
                                          payload: payload);

                                      Get.to(() => const ResultView(),
                                          transition: Transition.fadeIn,
                                          curve: Curves.easeInOut,
                                          duration: const Duration(
                                              milliseconds: 800));
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        radius:
                                            40, // Adjust the radius as needed
                                        child: SvgPicture.asset(
                                            "assets/images/home/grid_menu.svg"), // Use your image URL here
                                      ),
                                      const SizedBox(
                                          height:
                                              8), // Space between image and text
                                      InkWell(
                                        onTap: () {},
                                        child: SizedBox(
                                          height: 45.h,
                                          child: Text(
                                            "View All",
                                            style: primaryTextStyle(size: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    if (CustomSearchController().initialized) {
                                      CustomSearchController controller =
                                          Get.find<CustomSearchController>();
                                      controller.getProductsInSection(
                                          sectionName: shopController
                                              .subCategories[index].name!,
                                          payload: {
                                            "category_ids[0]": shopController
                                                .subCategories[index].id!
                                                .toString(),
                                          });

                                      Get.to(() => const ResultView(),
                                          transition: Transition.fadeIn,
                                          curve: Curves.easeInOut,
                                          duration: const Duration(
                                              milliseconds: 800));
                                    } else {
                                      CustomSearchController controller =
                                          Get.put(CustomSearchController());
                                      controller.getProductsInSection(
                                          sectionName: shopController
                                              .subCategories[index].name!,
                                          payload: {
                                            "category_ids[0]": shopController
                                                .subCategories[index].id!
                                                .toString(),
                                          });

                                      Get.to(() => const ResultView(),
                                          transition: Transition.fadeIn,
                                          curve: Curves.easeInOut,
                                          duration: const Duration(
                                              milliseconds: 800));
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        radius:
                                            40, // Adjust the radius as needed
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          shopController
                                              .subCategories[index].image!
                                              .toString(),
                                        ), // Use your image URL here
                                      ),
                                      const SizedBox(
                                          height:
                                              8), // Space between image and text
                                      SizedBox(
                                        height: 45.h,
                                        child: Text(
                                          shopController
                                              .subCategories[index].name!,
                                          style: primaryTextStyle(size: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),

                      //     GridView.builder(
                      //   shrinkWrap: true,
                      //   gridDelegate:
                      //       const SliverGridDelegateWithFixedCrossAxisCount(
                      //           childAspectRatio: 0.5,
                      //           crossAxisCount: 3,
                      //           crossAxisSpacing: 5,
                      //           mainAxisSpacing: 5),
                      //   itemBuilder: (context, index) {
                      //     ShopController shopController =
                      //         Get.find<ShopController>();
                      //     return index == 0
                      //         ? GestureDetector(
                      //             onTap: () {
                      //               if (CustomSearchController().initialized) {
                      //                 CustomSearchController controller =
                      //                     Get.find<CustomSearchController>();
                      //                 controller.getProductsInSection(
                      //                     sectionName: shopController
                      //                         .subCategories[index].name!,
                      //                     payload: {
                      //                       "category_ids[0]": shopController
                      //                           .subCategories[index].id!
                      //                           .toString(),
                      //                     });
                      //
                      //                 Get.to(() => const ResultView(),
                      //                     transition: Transition.fadeIn,
                      //                     curve: Curves.easeInOut,
                      //                     duration:
                      //                         const Duration(milliseconds: 800));
                      //               } else {
                      //                 CustomSearchController controller =
                      //                     Get.put(CustomSearchController());
                      //                 controller.getProductsInSection(
                      //                     sectionName: shopController
                      //                         .subCategories[index].name!,
                      //                     payload: {
                      //                       "category_ids[0]": shopController
                      //                           .subCategories[index].id!
                      //                           .toString(),
                      //                     });
                      //
                      //                 Get.to(() => const ResultView(),
                      //                     transition: Transition.fadeIn,
                      //                     curve: Curves.easeInOut,
                      //                     duration:
                      //                         const Duration(milliseconds: 800));
                      //               }
                      //             },
                      //             child: Column(
                      //               crossAxisAlignment: CrossAxisAlignment.center,
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 CircleAvatar(
                      //                   backgroundColor: Colors.grey[200],
                      //                   radius: 56,
                      //                   child: SvgPicture.asset(
                      //                       "assets/images/home/grid_menu.svg"),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 4.h,
                      //                 ),
                      //                 Container(
                      //                   height: 50.h,
                      //                   constraints: BoxConstraints(
                      //                       minHeight: 50.h,
                      //                       maxHeight: 50.h,
                      //                       maxWidth: 50.w),
                      //                   child: Text(
                      //                     "View All",
                      //                     maxLines: 2,
                      //                     style: primaryTextStyle(size: 12),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ))
                      //         : GestureDetector(
                      //             onTap: () {
                      //               if (CustomSearchController().initialized) {
                      //                 CustomSearchController controller =
                      //                     Get.find<CustomSearchController>();
                      //                 controller.getProductsInSection(
                      //                     sectionName: shopController
                      //                         .subCategories[index].name!,
                      //                     payload: {
                      //                       "category_ids[0]": shopController
                      //                           .subCategories[index].id!
                      //                           .toString(),
                      //                     });
                      //
                      //                 Get.to(() => const ResultView(),
                      //                     transition: Transition.fadeIn,
                      //                     curve: Curves.easeInOut,
                      //                     duration:
                      //                         const Duration(milliseconds: 800));
                      //               } else {
                      //                 CustomSearchController controller =
                      //                     Get.put(CustomSearchController());
                      //                 controller.getProductsInSection(
                      //                     sectionName: shopController
                      //                         .subCategories[index].name!,
                      //                     payload: {
                      //                       "category_ids[0]": shopController
                      //                           .subCategories[index].id!
                      //                           .toString(),
                      //                     });
                      //
                      //                 Get.to(() => const ResultView(),
                      //                     transition: Transition.fadeIn,
                      //                     curve: Curves.easeInOut,
                      //                     duration:
                      //                         const Duration(milliseconds: 800));
                      //               }
                      //             },
                      //             child: Column(
                      //               crossAxisAlignment: CrossAxisAlignment.center,
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Container(
                      //                   height: 80,
                      //                   decoration: const BoxDecoration(
                      //                     shape: BoxShape.circle,
                      //                   ),
                      //                   child: CachedNetworkImage(
                      //                     imageUrl: shopController
                      //                         .subCategories[index].image!
                      //                         .toString(),
                      //                     imageBuilder:
                      //                         (context, imageProvider) =>
                      //                             Container(
                      //                       decoration: BoxDecoration(
                      //                         shape: BoxShape.circle,
                      //                         image: DecorationImage(
                      //                             image: imageProvider,
                      //                             fit: BoxFit.fill),
                      //                       ),
                      //                     ),
                      //                     placeholder: (context, url) =>
                      //                         placeHolderWidget(),
                      //                     errorWidget: (context, url, error) =>
                      //                         Icon(Icons.error),
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 4.h,
                      //                 ),
                      //                 Container(
                      //                   height: 50.h,
                      //                   constraints: BoxConstraints(
                      //                       maxHeight: 40.h, maxWidth: 50.w),
                      //                   child: Text(
                      //                     overflow: TextOverflow.ellipsis,
                      //                     shopController
                      //                         .subCategories[index].name!,
                      //                     maxLines: 1,
                      //                     style: primaryTextStyle(size: 12),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ));
                      //   },
                      //   itemCount: controller.subCategories.length,
                      // )

                      // GridView.count(
                      //     crossAxisCount: 4,
                      //     padding: EdgeInsets.all(8.w),
                      //     crossAxisSpacing: 10.h,
                      //
                      //     mainAxisSpacing: 10,
                      //     childAspectRatio: 6 / 7,
                      //     shrinkWrap: true,
                      //     children: controller.subCategories
                      //         .map((subCat) => GestureDetector(
                      //               onTap: () {
                      //                 if (CustomSearchController()
                      //                     .initialized) {
                      //                   CustomSearchController controller =
                      //                       Get.find<CustomSearchController>();
                      //                   controller.getProductsInSection(
                      //                       sectionName: subCat.name!,
                      //                       payload: {
                      //                         "collection_ids[0]":
                      //                             subCat.id.toString()
                      //                       });
                      //
                      //                   Get.to(() => const ResultView(),
                      //                       transition: Transition.fadeIn,
                      //                       curve: Curves.easeInOut,
                      //                       duration: const Duration(
                      //                           milliseconds: 800));
                      //                 } else {
                      //                   CustomSearchController controller =
                      //                       Get.put<CustomSearchController>(
                      //                           CustomSearchController());
                      //                   controller.getProductsInSection(
                      //                       sectionName: subCat.name!,
                      //                       payload: {
                      //                         "collection_ids[0]":
                      //                             subCat.id.toString()
                      //                       });
                      //
                      //                   Get.to(() => const ResultView(),
                      //                       transition: Transition.fadeIn,
                      //                       curve: Curves.easeInOut,
                      //                       duration: const Duration(
                      //                           milliseconds: 800));
                      //                 }
                      //               },
                      //               child: Container(
                      //                 color: Colors.white,
                      //                 child: CachedNetworkImage(
                      //                   imageUrl: subCat.image!,
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //               ),
                      //             ))
                      //         .toList())
                    ),
                  ),
                );
    });
  }
}
