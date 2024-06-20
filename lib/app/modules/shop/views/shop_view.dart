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
import 'package:nb_utils/nb_utils.dart'
    hide primaryTextStyle
    hide boldTextStyle;

import '../../../routes/app_pages.dart';
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
          Align(
            alignment: Alignment.center,
            child: Text(
              "Discover",
              style: primaryTextStyle(
                  size: 22.sp.round(), weight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          buildSearchAndFilter(context),
          Obx(() {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 15.h,
                    )),
                    SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Shop By Categories",
                          style: boldTextStyle(
                              weight: FontWeight.w400, size: 23.sp.round()),
                        ),
                      ),
                    ),
                    controller.isCategoryLoading.value
                        ? SliverToBoxAdapter(
                            child: loadingIndicatorWidget(),
                          )
                        : SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            1.2),
                                    mainAxisSpacing: 5.h,
                                    crossAxisSpacing: 5.w // Adjust as needed
                                    ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return controller.categories.isEmpty
                                    ? Text("No Categories Yet ...")
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 2.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4.sp),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black12,
                                                spreadRadius: 0,
                                                blurRadius: 15),
                                          ],
                                        ),
                                        child: controller
                                                    .categories[index].image !=
                                                null
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  controller.categories[index]
                                                          .image!.isEmpty
                                                      ? placeHolderWidget()
                                                      : Stack(
                                                          alignment: Alignment
                                                              .topRight,
                                                          children: [
                                                            CachedNetworkImage(
                                                              imageUrl: controller
                                                                  .categories[
                                                                      index]
                                                                  .image!,
                                                              width: 135.w,
                                                              height: 120.h,
                                                              fit: BoxFit.cover,
                                                              placeholder:
                                                                  (ctx, v) {
                                                                return placeHolderWidget();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                  SizedBox(
                                                    height: 3.h,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.w),
                                                    child: Text(
                                                      controller
                                                          .categories[index]
                                                          .name!,
                                                      style: primaryTextStyle(
                                                          weight:
                                                              FontWeight.w700,
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
                              childCount: controller.categories.length,
                            ),
                          ),
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 15.h,
                    )),
                    SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Latest Products",
                          style: boldTextStyle(
                              weight: FontWeight.w400, size: 23.sp.round()),
                        ),
                      ),
                    ),
                    controller.isProductLoading.value
                        ? SliverToBoxAdapter(
                            child: loadingIndicatorWidget(),
                          )
                        : SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            1.2),
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5.w // Adjust as needed
                                    ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return controller.products.isEmpty
                                    ? Text("No Products Yet ...")
                                    : GestureDetector(
                                        onTap: () {
                                          if (ProductController().initialized) {
                                            Get.find<ProductController>();
                                            Get.toNamed(Routes.PRODUCT,
                                                arguments:
                                                    controller.products[index]);
                                          } else {
                                            Get.put<ProductController>(
                                                ProductController());
                                            Get.toNamed(Routes.PRODUCT,
                                                arguments:
                                                    controller.products[index]);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4.sp),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  spreadRadius: 0,
                                                  blurRadius: 15),
                                            ],
                                          ),
                                          child: controller
                                                      .products[index].image !=
                                                  null
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    controller.products[index]
                                                            .image!.isEmpty
                                                        ? placeHolderWidget()
                                                        : Stack(
                                                            alignment: Alignment
                                                                .topRight,
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl: controller
                                                                    .products[
                                                                        index]
                                                                    .image!,
                                                                width: 175.w,
                                                                height: 210.h,
                                                                fit: BoxFit
                                                                    .cover,
                                                                placeholder:
                                                                    (ctx, v) {
                                                                  return placeHolderWidget();
                                                                },
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  "assets/images/home/add_to_wishlist.svg",
                                                                  width: 33.w,
                                                                  height: 33.h,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                    SizedBox(
                                                      height: 3.h,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.w),
                                                      child: Text(
                                                        controller
                                                            .products[index]
                                                            .name!,
                                                        style: primaryTextStyle(
                                                            weight:
                                                                FontWeight.w700,
                                                            size: 16.sp.round(),
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 5.w),
                                                      width: 150.w,
                                                      child: Text(
                                                        controller
                                                            .products[index]
                                                            .description!,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: primaryTextStyle(
                                                            weight:
                                                                FontWeight.w300,
                                                            size: 14.sp.round(),
                                                            color: Color(
                                                                0xff9B9B9B)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.w),
                                                      child: Text(
                                                        "\$ ${controller.products[index].price!} ",
                                                        style: primaryTextStyle(
                                                            weight:
                                                                FontWeight.w600,
                                                            size: 15.sp.round(),
                                                            color: Color(
                                                                0xff370269)),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : placeHolderWidget(),
                                        ),
                                      );
                              },
                              childCount: controller.products.length,
                            ),
                          ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    ));
  }

  buildShopByCategories(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
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
        padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                readOnly: true,
                onTap: () {
                  Get.toNamed(Routes.SEARCH,
                      arguments: [controller.products, controller.categories]);
                  // Get.toNamed(()=> Pages., arguments: controller.homeModel.value.product);
                },
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
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/camera.svg',
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
              "assets/images/home/Filter.svg",
              height: 50.h,
              width: 50.w,
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
}
