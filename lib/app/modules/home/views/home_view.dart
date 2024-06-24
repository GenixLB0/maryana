import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/search/controllers/search_controller.dart';
import 'package:maryana/app/modules/search/views/result_view.dart';
import 'package:maryana/app/modules/search/views/search_view.dart';
import 'package:maryana/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart'
    hide boldTextStyle
    hide primaryTextStyle;

import 'package:shimmer/shimmer.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<HomeController>(() => HomeController());

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Obx(
        () => SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                buildUpperBar(context),
                buildSearchAndFilter(context),
                SizedBox(
                  height: 10.h,
                ),
                buildCatScroll(context),

                SizedBox(
                  height: 20.h,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller.scrollController,
                    scrollDirection: Axis.vertical,
                    child: Container(
                      child: Column(
                        children: [
                          buildBannerScroll(context),
                          SizedBox(
                            height: 15.h,
                          ),
                          buildCustomCatScroll(context),
                          SizedBox(
                            height: 15.h,
                          ),
                          buildProductsScroll(context),
                          SizedBox(
                            height: 25.h,
                          ),
                          AnimatedOpacity(
                            // If the widget is visible, animate to 0.0 (invisible).
                            // If the widget is hidden, animate to 1.0 (fully visible).
                            opacity: 1.0,

                            duration: const Duration(milliseconds: 500),
                            // The green box must be a child of the AnimatedOpacity widget.
                            child: buildRecommendedScroll(context),
                          )
                        ],
                      ),
                    ),
                  ),
                )

                // buildBannerScroll(context),
              ],
            )),
      ),
    );
  }

  buildBannerScroll(context) {
    print("type is ${controller.homeModel.value.banners}");
    print("value is ${controller.homeModel.value.banners.runtimeType}");
    return controller.isHomeLoading.value
        ? LoadingWidget(
            Container(
              width: MediaQuery.of(context).size.width,
              height: 450.h,
              color: Colors.grey,
            ),
          )
        : controller.homeModel.value.banners != null
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 470.h,
                child: controller.homeModel.value.banners!.isEmpty
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return Container(
                              width: MediaQuery.of(context).size.width - 2.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2.sp),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: placeHolderWidget(),
                              ));
                        },
                        separatorBuilder: (ctx, index) => SizedBox(
                              width: 55.w,
                            ),
                        itemCount: 3)
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return Container(
                              width: MediaQuery.of(context).size.width - 2.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2.sp),
                              ),
                              child:
                                  controller.homeModel.value.banners!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: controller.homeModel.value
                                              .banners![index].image!,
                                          fit: BoxFit.cover,
                                          placeholder: (ctx, v) {
                                            return placeHolderWidget();
                                          },
                                        )
                                      : placeHolderWidget());
                        },
                        separatorBuilder: (ctx, index) => SizedBox(
                              width: 1.w,
                            ),
                        itemCount: controller.homeModel.value.banners!.length),
              )
            : SizedBox();
  }

  buildcustomBannerScroll(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 450.h,
      color: Colors.green,
    );
  }

  buildCustomCatScroll(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: smallSpacing),
      child: Container(
        height: 200.h,
        width: MediaQuery.of(context).size.width,
        child: controller.isHomeLoading.value
            ? ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return LoadingWidget(
                    SizedBox(
                      width: 150.w,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.sp),
                            border: Border.all(color: Colors.grey, width: 1)),
                      ),
                    ),
                  );
                },
                separatorBuilder: (ctx, index) => SizedBox(
                      width: 10.w,
                    ),
                itemCount: 3)
            : controller.homeModel.value.categories != null
                ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      print(
                          "name is ${controller.homeModel.value.categories![index].name}");
                      return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.sp),
                          ),
                          child: controller.homeModel.value.categories![index]
                                      .image !=
                                  null
                              ? Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    controller.homeModel.value
                                            .categories![index].image!.isEmpty
                                        ? Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              placeHolderWidget(),
                                              Text(
                                                controller.homeModel.value
                                                    .categories![index].name!
                                                    .toUpperCase(),
                                                style: boldTextStyle(
                                                    weight: FontWeight.w400,
                                                    size: 22.sp.round(),
                                                    color: Colors.red),
                                              ),
                                              SizedBox(
                                                height: 20.h,
                                              )
                                            ],
                                          )
                                        : Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ColorFiltered(
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Colors.black45,
                                                        BlendMode.hardLight),
                                                child: CachedNetworkImage(
                                                  imageUrl: controller
                                                      .homeModel
                                                      .value
                                                      .categories![index]
                                                      .image!,
                                                  width: 130.w,
                                                  height: 200.h,
                                                  fit: BoxFit.cover,
                                                  placeholder: (ctx, v) {
                                                    return placeHolderWidget();
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 55.h),
                                                child: SizedBox(
                                                  width: 90.w,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.w),
                                                    child: Text(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      controller
                                                          .homeModel
                                                          .value
                                                          .categories![index]
                                                          .name!,
                                                      style: boldTextStyle(
                                                          color: Colors.white,
                                                          weight:
                                                              FontWeight.w400,
                                                          size: 34.sp.round()),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        placeHolderWidget(),
                                        Text(
                                          controller.homeModel.value
                                              .categories![index].name!
                                              .toUpperCase(),
                                          style: boldTextStyle(
                                            weight: FontWeight.w400,
                                            size: 22.sp.round(),
                                            color: Colors.white,
                                            textShadows: [
                                              const BoxShadow(
                                                  color: Colors.black,
                                                  spreadRadius: 5,
                                                  blurRadius: 25),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ));
                    },
                    separatorBuilder: (ctx, index) => SizedBox(
                          width: 10.w,
                        ),
                    itemCount: controller.homeModel.value.categories!.length)
                : SizedBox(),
      ),
    );
  }

  buildProductsScroll(context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  SvgPicture.asset(
                    "assets/images/home/star.svg",
                    width: 70.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: smallSpacing),
                    child: Text(
                      "TRENDING COLLECTION",
                      style: boldTextStyle(
                          weight: FontWeight.w400,
                          size: 20.sp.round(),
                          color: Colors.black),
                    ),
                  )
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  if (CustomSearchController().initialized) {
                    Get.find<CustomSearchController>()
                        .filterProductsAccordingToCat(
                      00,
                      true,
                      controller.homeModel.value.categories,
                    );

                    Get.to(() => const ResultView());
                  } else {
                    Get.put<CustomSearchController>(CustomSearchController())
                        .filterProductsAccordingToCat(
                      00,
                      true,
                      controller.homeModel.value.categories,
                    );

                    Get.to(() => const ResultView());
                  }
                },
                child: Text(
                  "SHOW ALL",
                  style: boldTextStyle(
                      weight: FontWeight.w400,
                      size: 20.sp.round(),
                      color: Color(0xff9B9B9B)),
                ),
              ),
              SizedBox(
                width: smallSpacing,
              )
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(smallSpacing),
            height: 340.h,
            width: MediaQuery.of(context).size.width,
            child: controller.isHomeLoading.value
                ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return LoadingWidget(
                        SizedBox(
                          width: 200.w,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.sp),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) => SizedBox(
                          width: 10.w,
                        ),
                    itemCount: 4)
                : controller.homeModel.value.product != null
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.sp),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 0,
                                      blurRadius: 10),
                                ],
                              ),
                              child: controller.homeModel.value.product![index]
                                          .image !=
                                      null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        controller.homeModel.value
                                                .product![index].image!.isEmpty
                                            ? placeHolderWidget()
                                            : Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: controller
                                                        .homeModel
                                                        .value
                                                        .product![index]
                                                        .image!,
                                                    width: 175.w,
                                                    height: 210.h,
                                                    fit: BoxFit.cover,
                                                    placeholder: (ctx, v) {
                                                      return placeHolderWidget();
                                                    },
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                            controller.homeModel.value
                                                .product![index].name!,
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
                                            controller.homeModel.value
                                                .product![index].description!,
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
                                            "\$ ${controller.homeModel.value.product![index].price!} ",
                                            style: primaryTextStyle(
                                                weight: FontWeight.w600,
                                                size: 15.sp.round(),
                                                color: Color(0xff370269)),
                                          ),
                                        ),
                                      ],
                                    )
                                  : placeHolderWidget(),
                            ),
                          );
                        },
                        separatorBuilder: (ctx, index) => SizedBox(
                              width: 10.w,
                            ),
                        itemCount: controller.homeModel.value.product!.length)
                    : SizedBox(),
          ),
        ],
      ),
    );
  }

  buildRecommendedScroll(context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: smallSpacing),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "RECOMMENDED",
                  style: boldTextStyle(
                      weight: FontWeight.w400,
                      size: 20.sp.round(),
                      color: Colors.black),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (CustomSearchController().initialized) {
                      Get.find<CustomSearchController>()
                          .filterProductsAccordingToCat(
                        00,
                        true,
                        controller.homeModel.value.categories,
                      );

                      Get.to(() => const ResultView());
                    } else {
                      Get.put<CustomSearchController>(CustomSearchController())
                          .filterProductsAccordingToCat(
                        00,
                        true,
                        controller.homeModel.value.categories,
                      );

                      Get.to(() => const ResultView());
                    }
                  },
                  child: Text(
                    "SHOW ALL",
                    style: boldTextStyle(
                        weight: FontWeight.w400,
                        size: 20.sp.round(),
                        color: Color(0xff9B9B9B)),
                  ),
                ),
                SizedBox(
                  width: smallSpacing,
                )
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Container(
              height: 65.h,
              width: MediaQuery.of(context).size.width,
              child: controller.isHomeLoading.value
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return LoadingWidget(
                          SizedBox(
                            width: 215.w,
                            height: 65.h,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.sp),
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) => SizedBox(
                            width: 10.w,
                          ),
                      itemCount: 4)
                  : controller.homeModel.value.product != null
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            return Container(
                              width: 215.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.sp),
                              ),
                              child: controller.homeModel.value.product![index]
                                          .image !=
                                      null
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        controller.homeModel.value
                                                .product![index].image!.isEmpty
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.w)),
                                                child: placeHolderWidget())
                                            : Container(
                                                width: 213.w,
                                                height: 110.h,
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 10.w,
                                                      top: 0,
                                                      child: Container(
                                                        width: 180.w,
                                                        height: 66.h,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: const Color(
                                                              0xFFF9F5FF),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            side: const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                    0xFFF9F5FF)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          shadows: const [
                                                            BoxShadow(
                                                              color: Color(
                                                                  0x26000000),
                                                              blurRadius: 14,
                                                              offset:
                                                                  Offset(0, 6),
                                                              spreadRadius: -12,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 0,
                                                      top: 0,
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: controller
                                                              .homeModel
                                                              .value
                                                              .product![index]
                                                              .image!,
                                                          fit: BoxFit.fitWidth,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: 80.0.w,
                                                            height: 80.0.h,
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.sp)),
                                                          ),
                                                          width: 65.w,
                                                          placeholder:
                                                              (ctx, v) {
                                                            return placeHolderWidget();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 75.w,
                                                      top: 12.50.h,
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 134.w,
                                                              height: 20.h,
                                                              child: Text(
                                                                  controller
                                                                      .homeModel
                                                                      .value
                                                                      .product![
                                                                          index]
                                                                      .name!,
                                                                  style:
                                                                      primaryTextStyle(
                                                                    weight:
                                                                        FontWeight
                                                                            .w500,
                                                                    letterSpacing:
                                                                        -0.12,
                                                                    size: 12
                                                                        .sp
                                                                        .round(),
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                                height: 10.h),
                                                            SizedBox(
                                                              width: 58.w,
                                                              height: 25.h,
                                                              child: Text(
                                                                  "\$ ${controller.homeModel.value.product![index].price!}",
                                                                  style:
                                                                      primaryTextStyle(
                                                                    weight:
                                                                        FontWeight
                                                                            .w700,
                                                                    letterSpacing:
                                                                        0.09.h,
                                                                    size: 13
                                                                        .sp
                                                                        .round()
                                                                        .round(),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                        // Expanded(
                                        //         flex: 2,
                                        //         child: Container(
                                        //           decoration:
                                        //               const BoxDecoration(
                                        //             shape: BoxShape.circle,
                                        //           ),
                                        //           child: CachedNetworkImage(
                                        //             imageUrl: controller
                                        //                 .homeModel
                                        //                 .value
                                        //                 .product![index]
                                        //                 .image!,
                                        //             fit: BoxFit.fitWidth,
                                        //             imageBuilder: (context,
                                        //                     imageProvider) =>
                                        //                 Container(
                                        //               width: 30.0,
                                        //               height: 80.0,
                                        //               decoration: BoxDecoration(
                                        //                   image: DecorationImage(
                                        //                       image:
                                        //                           imageProvider,
                                        //                       fit:
                                        //                           BoxFit.cover),
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(
                                        //                               15)),
                                        //             ),
                                        //             width: 35.w,
                                        //             placeholder: (ctx, v) {
                                        //               return placeHolderWidget();
                                        //             },
                                        //           ),
                                        //         ),
                                        //       ),
                                        // Expanded(
                                        //     flex: 3,
                                        //     child: Material(
                                        //       elevation: 8,
                                        //       color: Colors.white,
                                        //       shadowColor: Colors.black12,
                                        //       borderRadius:
                                        //           BorderRadius.circular(20),
                                        //       child: Container(
                                        //         decoration: const BoxDecoration(
                                        //           color: Colors.white12,
                                        //           boxShadow: [
                                        //             BoxShadow(
                                        //               color: Colors.black12,
                                        //               blurRadius: 4,
                                        //               offset: Offset(4,
                                        //                   8), // Shadow position
                                        //             ),
                                        //           ],
                                        //         ),
                                        //         child: Column(
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment.center,
                                        //           children: [
                                        //             SizedBox(
                                        //               height: 5.h,
                                        //             ),
                                        //             Text(
                                        //               controller
                                        //                   .homeModel
                                        //                   .value
                                        //                   .product![index]
                                        //                   .name!,
                                        //               style: primaryTextStyle(
                                        //                   size: 12.sp.round(),
                                        //                   weight:
                                        //                       FontWeight.w500,
                                        //                   color: Color(
                                        //                       0xff9B9B9B)),
                                        //             ),
                                        //             SizedBox(
                                        //               height: 5.h,
                                        //             ),
                                        //             Text(
                                        //               "\$ ${controller.homeModel.value.product![index].price!} ",
                                        //               style: primaryTextStyle(
                                        //                   size: 16.sp.round(),
                                        //                   weight:
                                        //                       FontWeight.w700,
                                        //                   color: Colors.black),
                                        //             ),
                                        //             SizedBox(
                                        //               height: 5.h,
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     )),
                                      ],
                                    )
                                  : placeHolderWidget(),
                            );
                          },
                          separatorBuilder: (ctx, index) => SizedBox(
                                width: 10.w,
                              ),
                          itemCount: controller.homeModel.value.product!.length)
                      : SizedBox(),
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }

  buildCatScroll(context) {
    List<Categories> myCatList = [];
    Categories allItemCategory =
        Categories(name: "All Items", slug: "", image: "", id: 00);
    // List<Categories>? catFromApi = controller.homeModel.value.categories;
    if (controller.homeModel.value.categories != null) {
      myCatList.add(allItemCategory);
      for (var cat in controller.homeModel.value.categories!) {
        myCatList.add(cat);
      }
    }

    return Padding(
      padding: EdgeInsets.only(left: smallSpacing),
      child: Container(
        height: 40.h,
        child: controller.isHomeLoading.value
            ? ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return LoadingWidget(
                    SizedBox(
                      width: 100.w,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.sp),
                            border: Border.all(color: Colors.grey, width: 1)),
                      ),
                    ),
                  );
                },
                separatorBuilder: (ctx, index) => SizedBox(
                      width: 10.w,
                    ),
                itemCount: 4)
            : controller.homeModel.value.categories != null
                ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          if (CustomSearchController().initialized) {
                            Get.find<CustomSearchController>()
                                .filterProductsAccordingToCat(
                              myCatList[index].id!,
                              true,
                              myCatList,
                            );

                            Get.to(() => const ResultView());
                          } else {
                            Get.put<CustomSearchController>(
                                    CustomSearchController())
                                .filterProductsAccordingToCat(
                              myCatList[index].id!,
                              true,
                              myCatList,
                            );

                            Get.to(() => const ResultView());
                          }
                        },
                        child: SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.sp),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: myCatList[index].image != null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      myCatList[index].image!.isEmpty
                                          ? SvgPicture.asset(
                                              "assets/images/home/cat_icon.svg")
                                          : CachedNetworkImage(
                                              imageUrl: myCatList[index].image!,
                                              width: 50.w,
                                              height: 15.h,
                                              placeholder: (ctx, v) {
                                                return placeHolderWidget();
                                              },
                                            ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(myCatList[index].name!),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      SvgPicture.asset(
                                          "assets/images/home/cat_icon.svg"),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(myCatList[index].name!),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) => SizedBox(
                          width: 10.w,
                        ),
                    itemCount: myCatList.length)
                : SizedBox(),
      ),
    );
  }

  buildUpperBar(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 65.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 150.w,
            height: 190.h,
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              width: 150.w,
              height: 65.h,
              fit: BoxFit.fitHeight,
            ),
          ),
          Spacer(),
          Container(
            height: 39.h,
            width: 90.w,
            padding: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.53, -0.85),
                end: Alignment(0.53, 0.85),
                colors: [
                  Color(0xFF7A59A5),
                  Color(0xFFA962FF),
                  Color(0xFFBA80FF)
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.85),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/home/medal.svg",
                  height: 25.h,
                  width: 25.w,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 4),
                Text('85pts',
                    textAlign: TextAlign.center,
                    style: primaryTextStyle(
                      color: Colors.white,
                      size: 15.sp.round(),
                      height: 0.08,
                      weight: FontWeight.w700,
                    )),
              ],
            ),
          ),
          SizedBox(
            width: smallSpacing,
          )
        ],
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
            width: smallSpacing,
          ),
          Flexible(
            flex: 12,
            child: Container(
              child: TextField(
                readOnly: true,
                onTap: () {
                  Get.toNamed(Routes.SEARCH, arguments: [
                    controller.homeModel.value.product,
                    controller.homeModel.value.categories
                  ]);
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
            width: smallSpacing,
          )
        ],
      ),
    );
  }
}

class CustomSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (_, constraints) {
      final t = shrinkOffset / maxExtent;
      final width = constraints.maxWidth;
      final itemMaxWidth = width / 4;

      double xFactor = -.4;
      return ColoredBox(
        color: Colors.cyanAccent.withOpacity(.3),
        child: Stack(
          children: [
            Align(
              alignment:
                  Alignment.lerp(Alignment.center, Alignment(xFactor, -.2), t)!
                    ..x,
              child: buildRow(
                  color: Colors.deepPurple, itemMaxWidth: itemMaxWidth, t: t),
            ),
            Align(
              alignment: Alignment.lerp(
                  Alignment.centerRight, Alignment(xFactor, 0), t)!,
              child:
                  buildRow(color: Colors.red, itemMaxWidth: itemMaxWidth, t: t),
            ),
            Align(
              alignment: Alignment.lerp(
                  Alignment.centerLeft, Alignment(xFactor, .2), t)!,
              child: buildRow(
                  color: Colors.amber, itemMaxWidth: itemMaxWidth, t: t),
            ),
          ],
        ),
      );
    });
  }

  Container buildRow(
      {required Color color, required double itemMaxWidth, required double t}) {
    return Container(
      width: lerpDouble(itemMaxWidth, itemMaxWidth * .3, t),
      height: lerpDouble(itemMaxWidth, itemMaxWidth * .3, t),
      color: color,
    );
  }

  /// you need to increase when it it not pinned
  @override
  double get maxExtent => 400;

  @override
  double get minExtent => 300;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
