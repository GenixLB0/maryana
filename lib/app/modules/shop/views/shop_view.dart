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
import '../../global/model/model_response.dart';
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
          SizedBox(
            height: 2.h,
          ),
          Obx(() {
            return SizedBox(
                height: 55.h,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  child: _buildUpperCategoriesList(context),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                ));
          }),

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
    List<Categories> filteredCategories = [];
    for (var category in controller.categories) {
      if (category.name!.toLowerCase() == "men" ||
          category.name!.toLowerCase() == "women" ||
          category.name!.toLowerCase() == "home") {
      } else {
        filteredCategories.add(category);
      }
    }
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
                              filteredCategories[index].id.toString()) {
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
                                              filteredCategories[index]
                                                  .id!
                                                  .toString()
                                          ? Colors.white
                                          : Colors.grey[200],
                                      child: AnimatedOpacity(
                                          opacity: 1,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeInOut,
                                          child: InkWell(
                                            onTap:
                                                controller
                                                        .isSubCategoriesLoading
                                                        .value
                                                    ? () {}
                                                    : () {
                                                        print(
                                                            "second ${controller.choosenCatId.value}");
                                                        print(
                                                            "second 2  ${filteredCategories[index].id!.toString()}");
                                                        controller.switchAll(
                                                            isFromAll: false);
                                                        controller.changeChoosenCatId(
                                                            filteredCategories[
                                                                    index]
                                                                .id!
                                                                .toString(),
                                                            filteredCategories[
                                                                    index]
                                                                .name!);

                                                        controller
                                                            .getSubCategoriesInCategory(
                                                                filteredCategories[
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
                                                            filteredCategories[
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
                                                          filteredCategories[
                                                                  index]
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
                                                                      filteredCategories[
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
                            : filteredCategories.length),
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
          : controller.isAll.value
              ? controller.allSubCategories.isEmpty
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
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 10.0, // Spacing between columns
                          mainAxisSpacing: 10.0, // Spacing between rows
                          childAspectRatio: 0.56, // Aspect ratio of each item
                        ),
                        itemCount: controller
                            .allSubCategories.length, // Number of items
                        itemBuilder: (context, index) {
                          ShopController shopController =
                              Get.find<ShopController>();
                          return index == 0
                              ? InkWell(
                                  onTap: () {
                                    //if All is Activated
                                    if (controller.isAll.value) {
                                      if (CustomSearchController()
                                          .initialized) {
                                        CustomSearchController controller =
                                            Get.find<CustomSearchController>();
                                        controller.getProductsInSection(
                                            sectionName: "RECOMMENDED",
                                            payload: {});

                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 400));
                                      } else {
                                        CustomSearchController controller =
                                            Get.put<CustomSearchController>(
                                                CustomSearchController());
                                        controller.getProductsInSection(
                                            sectionName: "RECOMMENDED",
                                            payload: {});

                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 400));
                                      }
                                    }
                                    //if any other value than all is activated
                                    else {
                                      Map<String, dynamic> payload = {};
                                      int i = 0;
                                      for (var category
                                          in controller.subCategories) {
                                        payload["category_ids[${i}]"] =
                                            category.id.toString();
                                        i++;
                                      }
                                      if (CustomSearchController()
                                          .initialized) {
                                        CustomSearchController controller =
                                            Get.find<CustomSearchController>();
                                        controller.getProductsInSection(
                                            sectionName: shopController
                                                .choosenCatName.value,
                                            payload: payload);
                                        controller.titleResult =
                                            shopController.choosenCatName.value;
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
                                        controller.titleResult =
                                            shopController.choosenCatName.value;
                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 800));
                                      }
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
                                              .allSubCategories[index].name!,
                                          payload: {
                                            "category_ids[0]": shopController
                                                .allSubCategories[index].id!
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
                                              .allSubCategories[index].image!
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
                                              .allSubCategories[index].name!,
                                          style: primaryTextStyle(size: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),
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
                                    //if All is Activated
                                    if (controller.isAll.value) {
                                      if (CustomSearchController()
                                          .initialized) {
                                        CustomSearchController controller =
                                            Get.find<CustomSearchController>();
                                        controller.getProductsInSection(
                                            sectionName: "RECOMMENDED",
                                            payload: {});

                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 400));
                                      } else {
                                        CustomSearchController controller =
                                            Get.put<CustomSearchController>(
                                                CustomSearchController());
                                        controller.getProductsInSection(
                                            sectionName: "RECOMMENDED",
                                            payload: {});
                                        controller.titleResult =
                                            shopController.choosenCatName.value;
                                        print(
                                            controller.titleResult.toString() +
                                                ' test title reust');
                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 400));
                                      }
                                    }

                                    //any chosen categories other than all
                                    else {
                                      Map<String, dynamic> payload = {};
                                      int i = 0;
                                      for (var category
                                          in controller.subCategories) {
                                        payload["category_ids[${i}]"] =
                                            category.id.toString();
                                        i++;
                                      }
                                      if (CustomSearchController()
                                          .initialized) {
                                        CustomSearchController controller =
                                            Get.find<CustomSearchController>();
                                        controller.getProductsInSection(
                                            sectionName: shopController
                                                .choosenCatName.value,
                                            payload: payload);
                                        controller.titleResult =
                                            shopController.choosenCatName.value;
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
                                        controller.titleResult =
                                            shopController.choosenCatName.value;
                                        print(
                                            controller.titleResult.toString() +
                                                ' test title reust');
                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 800));
                                      }
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
                                      SizedBox(
                                        height: 45.h,
                                        child: Text(
                                          "View All",
                                          style: primaryTextStyle(size: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : controller.subCategories[index].image == null
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: () {
                                        if (CustomSearchController()
                                            .initialized) {
                                          CustomSearchController controller =
                                              Get.find<
                                                  CustomSearchController>();
                                          controller.getProductsInSection(
                                              sectionName: shopController
                                                  .subCategories[index].name!,
                                              payload: {
                                                "category_ids[0]":
                                                    shopController
                                                        .subCategories[index]
                                                        .id!
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
                                                "category_ids[0]":
                                                    shopController
                                                        .subCategories[index]
                                                        .id!
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.grey[200],
                                            radius:
                                                40, // Adjust the radius as needed
                                            backgroundImage: shopController
                                                        .subCategories[index]
                                                        .image ==
                                                    null
                                                ? const CachedNetworkImageProvider(
                                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                                  )
                                                : CachedNetworkImageProvider(
                                                    shopController
                                                        .subCategories[index]
                                                        .image
                                                        .toString(),
                                                  ), // Use your image URL here
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Space between image and text
                                          shopController.subCategories[index]
                                                      .name ==
                                                  null
                                              ? SizedBox()
                                              : SizedBox(
                                                  height: 45.h,
                                                  child: Text(
                                                    shopController
                                                        .subCategories[index]
                                                        .name!,
                                                    style: primaryTextStyle(
                                                        size: 12),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    );
                        },
                      ),
                    );
    });
  }

  _buildUpperCategoriesList(BuildContext context) {
    List<Categories> upperList = [];
    for (var cat in controller.categories) {
      if (cat.name?.toLowerCase() == "men" ||
          cat.name?.toLowerCase() == "women" ||
          cat.name?.toLowerCase() == "home") {
        upperList.add(cat);
      }
    }

    return controller.isCategoryLoading.value
        ? loadingIndicatorWidget()
        : ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              int myIndex = index - 1;
              if (index == 0) {
                // First item is "All"
                return Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: InkWell(
                    onTap: () {
                      controller.switchAll(isFromAll: true);
                    },
                    child: Obx(() {
                      return Column(
                        children: [
                          Text(
                            'All',
                            style: primaryTextStyle(
                              size: 14.sp.round(),
                              color: controller.isAll.value
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          Container(
                            height: 2.h,
                            width: 18.w,
                            color: controller.isAll.value
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ],
                      );
                    }),
                  ),
                );
              } else {
                return InkWell(
                  onTap: controller.isSubCategoriesLoading.value
                      ? () {
                          print("sorry loading");
                        }
                      : () {
                          controller.switchAll(isFromAll: false);
                          controller.changeChoosenCatId(
                              upperList[myIndex].id!.toString(),
                              upperList[myIndex].name!);

                          controller.getSubCategoriesInCategory(
                              upperList[myIndex].id!);

                          print("fourth ${controller.choosenCatId.value}");
                          print(
                              "fourth 2  ${upperList[myIndex].id!.toString()}");
                        },
                  child: Obx(() {
                    return Container(
                        padding: EdgeInsets.only(left: 5.w),
                        // width: 90.w,
                        child: Column(
                          children: [
                            Text(upperList[myIndex].name!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: primaryTextStyle(
                                  size: 14.sp.round(),
                                  color: controller.choosenCatId.value ==
                                          upperList[myIndex].id!.toString()
                                      ? Colors.black
                                      : Colors.grey,
                                )),
                            Container(
                              height: 2.h,
                              width: 55.w,
                              color: controller.choosenCatId.value ==
                                      upperList[myIndex].id!.toString()
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                          ],
                        ));
                  }),
                );
              }
            },
            separatorBuilder: (context, index) => SizedBox(
                  width: 5.w,
                ),
            itemCount: upperList.length + 1);
  }
}
