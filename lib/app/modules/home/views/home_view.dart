import 'dart:ui';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:maryana/app/modules/gift_card/views/gift_card_view.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart'
    hide Brands;
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/search/controllers/search_controller.dart';
import 'package:maryana/app/modules/search/views/result_view.dart';

import 'package:nb_utils/nb_utils.dart'
    hide boldTextStyle
    hide primaryTextStyle;

import 'package:shimmer/shimmer.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:video_player/video_player.dart';

import '../../../routes/app_pages.dart';
import '../../global/theme/colors.dart';
import '../../search/views/search_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (HomeController().initialized) {
      print("true done yes");
    } else {
      print("true done no");

      Get.lazyPut<HomeController>(() => HomeController());
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: Obx(
        () => SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              buildUpperBar(context),
              // buildSearchAndFilter(
              //   products: controller.homeModel.value.product,
              //   categories: controller.homeModel.value.categories,
              //   context: context,
              //   isSearch: false,
              // ),
              SizedBox(
                height: 5.h,
              ),

              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const RangeMaintainingScrollPhysics(),
                  controller: controller.scrollController,
                  restorationId: "set",
                  scrollDirection: Axis.vertical,
                  child: Container(
                    child: Column(
                      children: [
                        buildCatScroll(context),
                        SizedBox(
                          height: 5.h,
                        ),
                        buildBannerScroll(context),
                        SizedBox(
                          height: 15.h,
                        ),
                        buildCustomCatScroll(context),

                        //here we need collections
                        GetBuilder<HomeController>(
                            id: 'collections',
                            builder: (logic) {
                              return controller.isCollectionsReached
                                  ? buildCollectionItems(context)
                                  : Container(
                                      height: 100.h,
                                      child:
                                          LoadingWidget(placeHolderWidget()));
                            }),

                        SizedBox(
                          height: 15.h,
                        ),

                        // here we need brands
                        GetBuilder<HomeController>(
                            id: 'brands',
                            builder: (logic) {
                              return buildBrandItems(context);
                            }),

                        SizedBox(
                          height: 15.h,
                        ),

                        //here we need coupons

                        GetBuilder<HomeController>(
                            id: 'coupons',
                            builder: (logic) {
                              return buildCoupon(context);
                            }),

                        // here we need Gift Cards

                        GetBuilder<HomeController>(
                            id: 'gift-cards',
                            builder: (logic) {
                              return buildGiftCards(context);
                            }),

                        // here we need styles

                        GetBuilder<HomeController>(
                            id: 'styles',
                            builder: (logic) {
                              return buildStyles(context);
                            }),

                        SizedBox(
                          height: 30.h,
                        ),

                        //here we need other Brands
                        GetBuilder<HomeController>(
                            id: 'other-brands',
                            builder: (logic) {
                              return buildOtherBrands(context);
                            }),

                        //here we need other brands Products
                        GetBuilder<HomeController>(
                            id: 'products-in-other-brands',
                            builder: (logic) {
                              return buildProductsInBrands(context);
                            }),

                        // buildProductsScroll(context),
                        SizedBox(
                          height: 15.h,
                        ),

                        //here we need recommended section

                        GetBuilder<HomeController>(builder: (logic) {
                          return buildRecommendedScroll(context);
                        }),
                      ],
                    ),
                  ),
                ),
              )

              // buildBannerScroll(context),
            ],
          ),
        ),
      ),
    );
  }

  buildBannerScroll(context) {
    print("type is ${controller.homeModel.value.banners}");
    print("value is ${controller.homeModel.value.banners.runtimeType}");

    return GetBuilder<HomeController>(
        id: 'home-video',
        builder: (logic) {
          return logic.isVideoInit
              ? ShowUp(
                  delay: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 9 / 16,
                        child: VideoPlayer(logic.videoController),
                      ),
                      Transform.translate(
                        offset: Offset(0, -50.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("SUMMER ",
                                style: boldTextStyle(
                                  color: Colors.white,
                                  size: 50.sp.round(),
                                  weight: FontWeight.w400,
                                )),
                            Text("COLLECTION",
                                style: boldTextStyle(
                                  color: Colors.white,
                                  size: 50.sp.round(),
                                  weight: FontWeight.w400,
                                )),
                            Text("2024",
                                style: boldTextStyle(
                                  color: Colors.white,
                                  size: 50.sp.round(),
                                  weight: FontWeight.w400,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox();
        });
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
                                        : GestureDetector(
                                            onTap: () {
                                              if (CustomSearchController()
                                                  .initialized) {
                                                CustomSearchController
                                                    myController = Get.find<
                                                        CustomSearchController>();
                                                myController
                                                    .getProductsInSection(
                                                        sectionName: controller
                                                            .homeModel
                                                            .value
                                                            .categories![index]
                                                            .name!,
                                                        payload: controller
                                                                    .homeModel
                                                                    .value
                                                                    .categories![
                                                                        index]
                                                                    .id ==
                                                                0
                                                            ? {}
                                                            : {
                                                                "category_ids[0]": controller
                                                                    .homeModel
                                                                    .value
                                                                    .categories![
                                                                        index]
                                                                    .id
                                                                    .toString()
                                                              });
                                                Get.to(() => const ResultView(),
                                                    transition:
                                                        Transition.fadeIn,
                                                    curve: Curves.easeInOut,
                                                    duration: const Duration(
                                                        milliseconds: 800));
                                              } else {
                                                CustomSearchController
                                                    myController =
                                                    Get.put<CustomSearchController>(
                                                        CustomSearchController());
                                                myController
                                                    .getProductsInSection(
                                                        sectionName: controller
                                                            .homeModel
                                                            .value
                                                            .categories![index]
                                                            .name!,
                                                        payload: controller
                                                                    .homeModel
                                                                    .value
                                                                    .categories![
                                                                        index]
                                                                    .id ==
                                                                0
                                                            ? {}
                                                            : {
                                                                "category_ids[0]": controller
                                                                    .homeModel
                                                                    .value
                                                                    .categories![
                                                                        index]
                                                                    .id
                                                                    .toString()
                                                              });

                                                Get.to(() => const ResultView(),
                                                    transition:
                                                        Transition.fadeIn,
                                                    curve: Curves.easeInOut,
                                                    duration: const Duration(
                                                        milliseconds: 800));
                                              }
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.sp),
                                                  child: ColorFiltered(
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            Colors.black45,
                                                            BlendMode
                                                                .hardLight),
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
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 55.h),
                                                  child: SizedBox(
                                                    width: 90.w,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.w),
                                                      child: Text(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        controller
                                                            .homeModel
                                                            .value
                                                            .categories![index]
                                                            .name!,
                                                        style: boldTextStyle(
                                                            color: Colors.white,
                                                            weight:
                                                                FontWeight.w400,
                                                            size:
                                                                34.sp.round()),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
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

  buildRecommendedScroll(context) {
    return ShowUp(
        delay: 300,
        child: controller.isHomeLoading.value
            ? Container(
                height: 100.h, child: LoadingWidget(placeHolderWidget()))
            : controller.homeModel.value.product == null
                ? SizedBox()
                : Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                    CustomSearchController controller =
                                        Get.find<CustomSearchController>();
                                    controller.getProductsInSection(
                                        sectionName: "RECOMMENDED",
                                        payload: {});

                                    Get.to(() => const ResultView(),
                                        transition: Transition.fadeIn,
                                        curve: Curves.easeInOut,
                                        duration:
                                            const Duration(milliseconds: 800));
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
                                        duration:
                                            const Duration(milliseconds: 800));
                                  }
                                },
                                child: Text(
                                  "SHOW ALL",
                                  style: boldTextStyle(
                                      weight: FontWeight.w400,
                                      size: 16.sp.round(),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.sp),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1)),
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
                                          return GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                Routes.PRODUCT,
                                                arguments: controller.homeModel
                                                    .value.product![index],
                                              );
                                            },
                                            child: Container(
                                              width: 215.w,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.sp),
                                              ),
                                              child:
                                                  controller
                                                              .homeModel
                                                              .value
                                                              .product![index]
                                                              .image !=
                                                          null
                                                      ? Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            controller
                                                                    .homeModel
                                                                    .value
                                                                    .product![
                                                                        index]
                                                                    .image!
                                                                    .isEmpty
                                                                ? Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(25
                                                                                .w)),
                                                                    child:
                                                                        placeHolderWidget())
                                                                : Container(
                                                                    width:
                                                                        213.w,
                                                                    height:
                                                                        110.h,
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8)),
                                                                    ),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Positioned(
                                                                          left:
                                                                              10.w,
                                                                          top:
                                                                              0,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                180.w,
                                                                            height:
                                                                                66.h,
                                                                            decoration:
                                                                                ShapeDecoration(
                                                                              color: const Color(0xFFF9F5FF),
                                                                              shape: RoundedRectangleBorder(
                                                                                side: const BorderSide(width: 1, color: Color(0xFFF9F5FF)),
                                                                                borderRadius: BorderRadius.circular(8),
                                                                              ),
                                                                              shadows: const [
                                                                                BoxShadow(
                                                                                  color: Color(0x26000000),
                                                                                  blurRadius: 14,
                                                                                  offset: Offset(0, 6),
                                                                                  spreadRadius: -12,
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          left:
                                                                              0,
                                                                          top:
                                                                              0,
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              imageUrl: controller.homeModel.value.product![index].image!,
                                                                              fit: BoxFit.fitWidth,
                                                                              imageBuilder: (context, imageProvider) => Container(
                                                                                width: 80.0.w,
                                                                                height: 80.0.h,
                                                                                decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover), borderRadius: BorderRadius.circular(15.sp)),
                                                                              ),
                                                                              width: 65.w,
                                                                              placeholder: (ctx, v) {
                                                                                return placeHolderWidget();
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          left:
                                                                              75.w,
                                                                          top: 12.50
                                                                              .h,
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: 100.w,
                                                                                  height: 20.h,
                                                                                  child: Text(
                                                                                    controller.homeModel.value.product![index].name!,
                                                                                    style: primaryTextStyle(
                                                                                      weight: FontWeight.w500,
                                                                                      letterSpacing: -0.12,
                                                                                      size: 12.sp.round(),
                                                                                    ),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: 10.h),
                                                                                SizedBox(
                                                                                  width: 58.w,
                                                                                  height: 25.h,
                                                                                  child: Text("\$ ${controller.homeModel.value.product![index].price!}",
                                                                                      style: primaryTextStyle(
                                                                                        weight: FontWeight.w700,
                                                                                        letterSpacing: 0.09.h,
                                                                                        size: 13.sp.round().round(),
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                          ],
                                                        )
                                                      : placeHolderWidget(),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (ctx, index) =>
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                        itemCount: controller.homeModel.value
                                                    .product!.length >
                                                5
                                            ? 5
                                            : controller.homeModel.value
                                                .product!.length)
                                    : SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ));
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
        padding: EdgeInsets.only(left: 20.w),
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
                                CustomSearchController controller =
                                    Get.find<CustomSearchController>();
                                controller.getProductsInSection(
                                    sectionName: myCatList[index].name!,
                                    payload: myCatList[index].id == 0
                                        ? {}
                                        : {
                                            "category_ids[0]":
                                                "${myCatList[index].id.toString()}"
                                          });
                                Get.to(() => const ResultView(),
                                    transition: Transition.fadeIn,
                                    curve: Curves.easeInOut,
                                    duration:
                                        const Duration(milliseconds: 800));
                              } else {
                                CustomSearchController controller =
                                    Get.put<CustomSearchController>(
                                        CustomSearchController());
                                controller.getProductsInSection(
                                    sectionName: myCatList[index].name!,
                                    payload: myCatList[index].id == 0
                                        ? {}
                                        : {
                                            "category_ids[0]":
                                                "${myCatList[index].id.toString()}"
                                          });

                                Get.to(() => const ResultView(),
                                    transition: Transition.fadeIn,
                                    curve: Curves.easeInOut,
                                    duration:
                                        const Duration(milliseconds: 800));
                              }
                            },
                            child: SizedBox(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                decoration: BoxDecoration(
                                    color: controller.activeCats[index] == 1
                                        ? Color(0xffE7D3FF)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10.sp),
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: myCatList[index].image != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          myCatList[index].image!.isEmpty
                                              ? SvgPicture.asset(
                                                  "assets/images/home/cat_icon.svg",
                                                  width: 20.w,
                                                  height: 20.h,
                                                  fit: BoxFit.cover,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl:
                                                      myCatList[index].image!,
                                                  width: 20.w,
                                                  height: 20.h,
                                                  fit: BoxFit.cover,
                                                  placeholder: (ctx, v) {
                                                    return placeHolderWidget();
                                                  },
                                                ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            myCatList[index].name!,
                                          ),
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
                                            "assets/images/home/cat_icon.svg",
                                            width: 20.w,
                                            height: 20.h,
                                            fit: BoxFit.cover,
                                          ),
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
                            ));
                      },
                      separatorBuilder: (ctx, index) => SizedBox(
                            width: 10.w,
                          ),
                      itemCount: myCatList.length)
                  : SizedBox(),
        ));
  }

  buildUpperBar(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 115.w,
            height: 165.h,
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              width: 150.w,
              height: 65.h,
              fit: BoxFit.fitHeight,
            ),
          ),
          Spacer(),
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
                  duration: const Duration(milliseconds: 800));
            },
          ),
          // Container(
          //   height: 40.h,
          //   width: 85.w,
          //   padding: const EdgeInsets.all(8),
          //   decoration: ShapeDecoration(
          //     gradient: const LinearGradient(
          //       begin: Alignment(-0.53, -0.85),
          //       end: Alignment(0.53, 0.85),
          //       colors: [
          //         Color(0xFF7A59A5),
          //         Color(0xFFA962FF),
          //         Color(0xFFBA80FF)
          //       ],
          //     ),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(28.85),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       SvgPicture.asset(
          //         "assets/images/home/medal.svg",
          //         height: 23.h,
          //         width: 23.w,
          //         fit: BoxFit.cover,
          //       ),
          //       const SizedBox(width: 4),
          //       Text('85pts',
          //           textAlign: TextAlign.center,
          //           style: primaryTextStyle(
          //             color: Colors.white,
          //             size: 13.sp.round(),
          //             height: 0.08,
          //             weight: FontWeight.w700,
          //           )),
          //     ],
          //   ),
          // ),
          SizedBox(
            width: 20.w,
          )
        ],
      ),
    );
  }

  ///////////Collections////////////////////////
  buildCollectionItems(context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) =>
            _buildCollectionItem(context, controller.collections[index]),
        separatorBuilder: (context, index) => SizedBox(
              height: 15.h,
            ),
        itemCount: controller.collections.length);
  }

  _buildCollectionItem(context, Collections collection) {
    final typeController = TypeWriterController(
      text: collection.name!,
      duration: const Duration(milliseconds: 150),
      repeat: true,
    );

    return ShowUp(
      delay: 300,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Stack(
            alignment: Alignment.centerRight,
            children: [
              CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                height: 255.h,
                imageUrl: collection.image!,
                fit: BoxFit.cover,
              ),
              SizedBox(
                  width: 180.w,
                  height: 150.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30.w),
                        child: Text(
                          'SHOP OUR',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF9B9B9B),
                            fontSize: 17.sp,
                            fontFamily: fontCormoantFont,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TypeWriter(
                          controller: typeController,
                          builder: (context, value) {
                            return Text(
                              overflow: TextOverflow.ellipsis,
                              value.text,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 27.sp,
                                fontFamily: fontCormoantFont,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                              maxLines: 2,
                            );
                          }),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(left: 50.w),
                        child: GestureDetector(
                          onTap: () {
                            if (CustomSearchController().initialized) {
                              CustomSearchController controller =
                                  Get.find<CustomSearchController>();
                              controller.getProductsInSection(
                                  sectionName: collection.name!,
                                  payload: {
                                    "collection_ids[0]":
                                        collection.id.toString()
                                  });

                              Get.to(() => const ResultView(),
                                  transition: Transition.fadeIn,
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 800));
                            } else {
                              CustomSearchController controller =
                                  Get.put<CustomSearchController>(
                                      CustomSearchController());
                              controller.getProductsInSection(
                                  sectionName: collection.name!,
                                  payload: {
                                    "collection_ids[0]":
                                        collection.id.toString()
                                  });
                              Get.to(() => const ResultView(),
                                  transition: Transition.fadeIn,
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 800));
                            }
                          },
                          child: Text('SHOW ALL',
                              overflow: TextOverflow.ellipsis,
                              style: boldTextStyle(
                                  decoration: TextDecoration.underline,
                                  weight: FontWeight.w400,
                                  color: const Color(0xff53178C),
                                  size: 16.sp.round(),
                                  letterSpacing: 0.3)),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
          FutureBuilder(
              future: controller.getProductsInCollection(collection),
              builder: (ctx, snapshot) {
                // Checking if future is resolved
                if (snapshot.connectionState == ConnectionState.done) {
                  print("snap done !!!!!");
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(
                          height: 50.h,
                          child: Row(
                            children: [
                              Text(
                                collection.name!,
                                style: boldTextStyle(
                                    weight: FontWeight.w400,
                                    size: 18.sp.round(),
                                    color: Colors.black),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  if (CustomSearchController().initialized) {
                                    CustomSearchController controller =
                                        Get.find<CustomSearchController>();
                                    controller.getProductsInSection(
                                        sectionName: collection.name!,
                                        payload: {
                                          "collection_ids[0]":
                                              collection.id.toString()
                                        });

                                    Get.to(() => const ResultView(),
                                        transition: Transition.fadeIn,
                                        curve: Curves.easeInOut,
                                        duration: Duration(milliseconds: 800));
                                  } else {
                                    CustomSearchController controller =
                                        Get.put<CustomSearchController>(
                                            CustomSearchController());
                                    controller.getProductsInSection(
                                        sectionName: collection.name!,
                                        payload: {
                                          "collection_ids[0]":
                                              collection.id.toString()
                                        });
                                    Get.to(() => const ResultView(),
                                        transition: Transition.fadeIn,
                                        curve: Curves.easeInOut,
                                        duration: Duration(milliseconds: 800));
                                  }
                                },
                                child: Text(
                                  "SHOW ALL",
                                  style: boldTextStyle(
                                      weight: FontWeight.w400,
                                      size: 16.sp.round(),
                                      color: Color(0xff9B9B9B)),
                                ),
                              ),
                              SizedBox(
                                width: smallSpacing,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 320.h,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) {
                              return index != snapshot.data!.length
                                  ? buildProductCard(
                                      product: ViewProductData.fromJson(
                                          snapshot.data![index]),
                                    )
                                  : buildProductShowAll(() {
                                      if (CustomSearchController()
                                          .initialized) {
                                        CustomSearchController controller =
                                            Get.find<CustomSearchController>();
                                        controller.getProductsInSection(
                                            sectionName: collection.name!,
                                            payload: {
                                              "collection_ids[0]":
                                                  collection.id.toString()
                                            });

                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration:
                                                Duration(milliseconds: 800));
                                      } else {
                                        CustomSearchController controller =
                                            Get.put<CustomSearchController>(
                                                CustomSearchController());
                                        controller.getProductsInSection(
                                            sectionName: collection.name!,
                                            payload: {
                                              "collection_ids[0]":
                                                  collection.id.toString()
                                            });
                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration:
                                                Duration(milliseconds: 800));
                                      }
                                    });
                            },
                            separatorBuilder: (ctx, index) => SizedBox(
                              width: 10.w,
                            ),
                            itemCount: snapshot.data!.length + 1,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.active) {
                  return Container(
                      height: 60.h, child: LoadingWidget(placeHolderWidget()));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: TextStyle(fontSize: 18),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  // Extracting data from snapshot object

                  return SizedBox();
                }
                return SizedBox();
              }),
        ],
      ),
    );
  }

/////////////////////////////////////////

  ///////////Brands////////////////////////
  buildBrandItems(context) {
    return Container(
      color: Color(0xffF9F5FF),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) =>
              _buildBrandItem(context, controller.brands[index]),
          separatorBuilder: (context, index) => SizedBox(
                height: 15.h,
              ),
          itemCount: controller.brands.length),
    );
  }

  _buildBrandItem(context, Brands brand) {
    final typeController = TypeWriterController(
      text: brand.name!,
      duration: const Duration(milliseconds: 150),
      repeat: true,
    );

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: Text(
              "new",
              style: TextStyle(
                  fontFamily: fontCormoantFont,
                  fontSize: 14.sp,
                  color: Colors.grey[300],
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Center(
            child: Text(
              "${brand.name} BRAND",
              style: TextStyle(
                  fontFamily: fontCormoantFont,
                  fontSize: 28.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: 255.h,
            imageUrl: brand.image!,
            fit: BoxFit.cover,
          ),
          FutureBuilder(
              future: controller.getProductsInBrand(brand),
              builder: (ctx, snapshot) {
                // Checking if future is resolved
                if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(
                          height: 50.h,
                          child: Row(
                            children: [
                              Text(
                                "${brand.name!} BEST SELLING",
                                style: boldTextStyle(
                                    weight: FontWeight.w400,
                                    size: 18.sp.round(),
                                    color: Colors.black),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  if (CustomSearchController().initialized) {
                                    CustomSearchController controller =
                                        Get.find<CustomSearchController>();
                                    controller.getProductsInSection(
                                        sectionName: brand.name!,
                                        payload: {
                                          "brand_ids[0]": brand.id.toString()
                                        });

                                    Get.to(() => const ResultView(),
                                        transition: Transition.fadeIn,
                                        curve: Curves.easeInOut,
                                        duration: Duration(milliseconds: 800));
                                  } else {
                                    CustomSearchController controller =
                                        Get.put<CustomSearchController>(
                                            CustomSearchController());
                                    controller.getProductsInSection(
                                        sectionName: brand.name!,
                                        payload: {
                                          "brand_ids[0]": brand.id.toString()
                                        });
                                    Get.to(() => const ResultView(),
                                        transition: Transition.fadeIn,
                                        curve: Curves.easeInOut,
                                        duration: Duration(milliseconds: 800));
                                  }
                                },
                                child: Text(
                                  "SHOW ALL",
                                  style: boldTextStyle(
                                      weight: FontWeight.w400,
                                      size: 16.sp.round(),
                                      color: Color(0xff9B9B9B)),
                                ),
                              ),
                              SizedBox(
                                width: smallSpacing,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 320.h,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                return index != snapshot.data!.length
                                    ? buildProductCard(
                                        product: ViewProductData.fromJson(
                                            snapshot.data![index]))
                                    : buildProductShowAll(() {
                                        if (CustomSearchController()
                                            .initialized) {
                                          CustomSearchController controller =
                                              Get.find<
                                                  CustomSearchController>();
                                          controller.getProductsInSection(
                                              sectionName: brand.name!,
                                              payload: {
                                                "brand_ids[0]":
                                                    brand.id.toString()
                                              });

                                          Get.to(() => const ResultView(),
                                              transition: Transition.fadeIn,
                                              curve: Curves.easeInOut,
                                              duration:
                                                  Duration(milliseconds: 800));
                                        } else {
                                          CustomSearchController controller =
                                              Get.put<CustomSearchController>(
                                                  CustomSearchController());
                                          controller.getProductsInSection(
                                              sectionName: brand.name!,
                                              payload: {
                                                "brand_ids[0]":
                                                    brand.id.toString()
                                              });
                                          Get.to(() => const ResultView(),
                                              transition: Transition.fadeIn,
                                              curve: Curves.easeInOut,
                                              duration:
                                                  Duration(milliseconds: 800));
                                        }
                                      });
                              },
                              separatorBuilder: (ctx, index) => SizedBox(
                                    width: 10.w,
                                  ),
                              itemCount: snapshot.data!.length + 1),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.active) {
                  return Container(
                      height: 60.h, child: LoadingWidget(placeHolderWidget()));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: TextStyle(fontSize: 18),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  // Extracting data from snapshot object

                  return const SizedBox();
                }
                return const SizedBox();
              }),
        ],
      ),
    );
  }

/////////////////////////////////////////

/////////////////////Coupons////////////////////////////////////////////
  buildCoupon(context) {
    return controller.isCouponLoading
        ? Container(height: 100.h, child: LoadingWidget(placeHolderWidget()))
        : ShowUp(
            delay: 300,
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: controller.coupons.isEmpty
                    ? SizedBox()
                    : CouponsSliderWithIndicators(
                        couponsList: controller.coupons,
                      )),
          );
  }

  buildStyles(BuildContext context) {
    return ShowUp(
      delay: 300,
      child: controller.isStylesLoading
          ? Container(height: 100.h, child: LoadingWidget(placeHolderWidget()))
          : controller.styles.isEmpty
              ? SizedBox()
              : Container(
                  height: 400.h,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "What's Your Vibe?",
                        style: TextStyle(
                            fontFamily: fontCormoantFont,
                            fontSize: 14.sp,
                            color: Colors.grey[300]),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "Shop By Style",
                        style: TextStyle(
                            fontFamily: fontCormoantFont,
                            fontSize: 28.sp,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Expanded(
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      Styles style = controller.styles[index];
                                      if (CustomSearchController()
                                          .initialized) {
                                        CustomSearchController controller =
                                            Get.find<CustomSearchController>();
                                        controller.getProductsInSection(
                                            sectionName: style.name!,
                                            payload: {
                                              "style_ids[0]":
                                                  style.id.toString()
                                            });

                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 800));
                                      } else {
                                        CustomSearchController controller =
                                            Get.put<CustomSearchController>(
                                                CustomSearchController());
                                        controller.getProductsInSection(
                                            sectionName: style.name!,
                                            payload: {
                                              "style_ids[0]":
                                                  style.id.toString()
                                            });

                                        Get.to(() => const ResultView(),
                                            transition: Transition.fadeIn,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 800));
                                      }
                                    },
                                    child: SizedBox(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7.sp),
                                            child: ColorFiltered(
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.black45,
                                                      BlendMode.hardLight),
                                              child: CachedNetworkImage(
                                                imageUrl: controller
                                                    .styles[index].image!,
                                                width: 165.w,
                                                height: 290.h,
                                                fit: BoxFit.cover,
                                                placeholder: (ctx, v) {
                                                  return placeHolderWidget();
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 55.h),
                                            child: SizedBox(
                                              width: 90.w,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w),
                                                child: Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  controller
                                                      .styles[index].name!,
                                                  style: boldTextStyle(
                                                      color: Colors.white,
                                                      weight: FontWeight.w400,
                                                      size: 34.sp.round()),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            separatorBuilder: (context, index) => SizedBox(
                                  width: 8.w,
                                ),
                            itemCount: controller.styles.length),
                      )
                    ],
                  ),
                ),
    );
  }

  buildGiftCards(BuildContext context) {
    return ShowUp(
      delay: 300,
      child: controller.isGiftCardLoading
          ? Container(height: 100.h, child: LoadingWidget(placeHolderWidget()))
          : controller.giftCards.isEmpty
              ? SizedBox()
              : Container(
                  color: Color(0xffF9F5FF),
                  height: 300.h,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Text("Buy Your E-Gift Card",
                                style: boldTextStyle(
                                    size: 28.sp.round(),
                                    color: Colors.black,
                                    weight: FontWeight.w400)),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Get.to(() => GiftCardView());
                              },
                              child: Icon(
                                Icons.arrow_forward_outlined,
                                color: Colors.black,
                                size: 15.sp,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Expanded(
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => GestureDetector(
                                    onTap: () {},
                                    child: Stack(
                                      alignment: Alignment.topLeft,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.sp),
                                          child: ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                                Colors.black45,
                                                BlendMode.hardLight),
                                            child: CachedNetworkImage(
                                              imageUrl: controller
                                                  .giftCards[index].image!,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30.w,
                                              height: 210.h,
                                              fit: BoxFit.cover,
                                              placeholder: (ctx, v) {
                                                return placeHolderWidget();
                                              },
                                            ),
                                          ),
                                        ),
                                        // Container(
                                        //   height: 400.h,
                                        //   child: Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.start,
                                        //     children: [
                                        //       Padding(
                                        //         padding:
                                        //             EdgeInsets.only(top: 55.h),
                                        //         child: SizedBox(
                                        //           child: Padding(
                                        //             padding:
                                        //                 EdgeInsets.symmetric(
                                        //                     horizontal: 5.w),
                                        //             child: Text(
                                        //               maxLines: 1,
                                        //               overflow:
                                        //                   TextOverflow.ellipsis,
                                        //               "Gift Card".toString(),
                                        //               style: boldTextStyle(
                                        //                   color: Colors.white,
                                        //                   weight:
                                        //                       FontWeight.w400,
                                        //                   size: 34.sp.round()),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       SizedBox(
                                        //         height: 50.h,
                                        //       ),
                                        //       Padding(
                                        //         padding:
                                        //             EdgeInsets.only(top: 55.h),
                                        //         child: SizedBox(
                                        //           child: Padding(
                                        //             padding:
                                        //                 EdgeInsets.symmetric(
                                        //                     horizontal: 5.w),
                                        //             child: Text(
                                        //               maxLines: 1,
                                        //               overflow:
                                        //                   TextOverflow.ellipsis,
                                        //               controller
                                        //                   .giftCards[index]
                                        //                   .amount
                                        //                   .toString(),
                                        //               style: boldTextStyle(
                                        //                   color: Colors.white,
                                        //                   weight:
                                        //                       FontWeight.w400,
                                        //                   size: 34.sp.round()),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       SizedBox(
                                        //         height: 10.h,
                                        //       )
                                        //     ],
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                              separatorBuilder: (context, index) => SizedBox(
                                    width: 8.w,
                                  ),
                              itemCount: controller.giftCards.length),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: controller.giftCards
                                .map((card) => Padding(
                                      padding: EdgeInsets.only(bottom: 4.h),
                                      child: Container(
                                        margin: EdgeInsets.all(3.w),
                                        height: 5,
                                        width: 5,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black12),
                                            shape: BoxShape.circle),
                                      ),
                                    ))
                                .toList())
                      ],
                    ),
                  ),
                ),
    );
  }

  buildOtherBrands(BuildContext context) {
    return ShowUp(
      delay: 300,
      child: controller.isOtherBrandLoading
          ? Container(height: 100.h, child: LoadingWidget(placeHolderWidget()))
          : controller.otherBrands.isEmpty
              ? SizedBox()
              : Container(
                  color: const Color(0xffF9F5FF),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "LUXURIAS  BRANDS ",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            fontFamily: fontCormoantFont,
                            color: Colors.grey[400]),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Brands You'll Love !",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 28.sp,
                            fontFamily: fontCormoantFont),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 4 / 5,
                            children: controller.otherBrands.map((brand) {
                              return GestureDetector(
                                onTap: () {
                                  if (CustomSearchController().initialized) {
                                    CustomSearchController controller =
                                        Get.find<CustomSearchController>();
                                    controller.getProductsInSection(
                                        sectionName: brand.name!,
                                        payload: {
                                          "brand_ids[0]": brand.id.toString()
                                        });

                                    Get.to(() => const ResultView(),
                                        transition: Transition.fadeIn,
                                        curve: Curves.easeInOut,
                                        duration:
                                            const Duration(milliseconds: 800));
                                  } else {
                                    CustomSearchController controller =
                                        Get.put<CustomSearchController>(
                                            CustomSearchController());
                                    controller.getProductsInSection(
                                        sectionName: brand.name!,
                                        payload: {
                                          "brand_ids[0]": brand.id.toString()
                                        });

                                    Get.to(() => const ResultView(),
                                        transition: Transition.fadeIn,
                                        curve: Curves.easeInOut,
                                        duration:
                                            const Duration(milliseconds: 800));
                                  }
                                },
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      width: 190.w,
                                      height: 250.h,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(20.sp),
                                      ),
                                      child: Center(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.sp),
                                              child: ColorFiltered(
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Colors.black45,
                                                        BlendMode.hardLight),
                                                child: CachedNetworkImage(
                                                  imageUrl: brand.image!,
                                                  width: 190.w,
                                                  height: 250.h,
                                                  fit: BoxFit.cover,
                                                  placeholder: (ctx, v) {
                                                    return placeHolderWidget();
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 55.h, left: 25.w),
                                              child: SizedBox(
                                                width: 90.w,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w),
                                                  child: Text(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    brand.name!,
                                                    style: boldTextStyle(
                                                        color: Colors.white,
                                                        weight: FontWeight.w400,
                                                        size: 34.sp.round()),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              );
                            }).toList()),
                      ),
                    ],
                  ),
                ),
    );

    //   GridView.builder(
    //   shrinkWrap: true,
    //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    //     maxCrossAxisExtent: 200,
    //     childAspectRatio: 3 / 2,
    //     crossAxisSpacing: 20,
    //     mainAxisSpacing: 20,
    //   ),
    //   itemCount: controller.otherBrands.value.length,
    //   itemBuilder: (BuildContext ctx, int index) {
    //     return Container(
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //         color: Colors.amber,
    //         borderRadius: BorderRadius.circular(15),
    //       ),
    //       child: Text(controller.otherBrands.value[index].name!),
    //     );
    //   },
    // );
  }

  buildProductsInBrands(BuildContext context) {
    return ShowUp(
      delay: 300,
      child: controller.isProductsInBrandsLoading
          ? Container(height: 100.h, child: LoadingWidget(placeHolderWidget()))
          : controller.productsInBrands.isEmpty
              ? SizedBox()
              : Container(
                  color: const Color(0xffF9F5FF),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.w),
                            child: Text(
                              "TRENDING BRANDS ITEMS",
                              style: boldTextStyle(
                                  weight: FontWeight.w400,
                                  size: 20.sp.round(),
                                  color: Colors.black),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              String otherBrandsId =
                                  controller.otherBrandsId.join(",");

                              if (CustomSearchController().initialized) {
                                CustomSearchController controller =
                                    Get.find<CustomSearchController>();
                                controller.getProductsInSection(
                                    sectionName: "TRENDING BRANDS ITEMS",
                                    payload: {"brand_ids[0]": otherBrandsId});

                                Get.to(() => const ResultView(),
                                    transition: Transition.fadeIn,
                                    curve: Curves.easeInOut,
                                    duration:
                                        const Duration(milliseconds: 800));
                              } else {
                                CustomSearchController controller =
                                    Get.put<CustomSearchController>(
                                        CustomSearchController());
                                controller.getProductsInSection(
                                    sectionName: "TRENDING BRANDS ITEMS",
                                    payload: {"brand_ids[0]": otherBrandsId});

                                Get.to(() => const ResultView(),
                                    transition: Transition.fadeIn,
                                    curve: Curves.easeInOut,
                                    duration:
                                        const Duration(milliseconds: 800));
                              }
                            },
                            child: Text(
                              "SHOW ALL",
                              style: boldTextStyle(
                                  weight: FontWeight.w400,
                                  size: 16.sp.round(),
                                  color: Color(0xff9B9B9B)),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          )
                        ],
                      ),
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(2),
                          height: 340.h,
                          width: MediaQuery.of(context).size.width,
                          child: controller.isProductsInBrandsLoading
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return LoadingWidget(
                                      SizedBox(
                                        width: 200.w,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15.sp),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1)),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (ctx, index) => SizedBox(
                                        width: 10.w,
                                      ),
                                  itemCount: 4)
                              : Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctx, index) {
                                        return index !=
                                                controller
                                                    .productsInBrands.length
                                            ? buildProductCard(
                                                product: ViewProductData
                                                    .fromJson(controller
                                                            .productsInBrands[
                                                        index]))
                                            : buildProductShowAll(() {
                                                String otherBrandsId =
                                                    controller.otherBrandsId
                                                        .join(",");

                                                if (CustomSearchController()
                                                    .initialized) {
                                                  CustomSearchController
                                                      controller = Get.find<
                                                          CustomSearchController>();
                                                  controller.getProductsInSection(
                                                      sectionName:
                                                          "TRENDING BRANDS ITEMS",
                                                      payload: {
                                                        "brand_ids[0]":
                                                            otherBrandsId
                                                      });

                                                  Get.to(
                                                      () => const ResultView(),
                                                      transition:
                                                          Transition.fadeIn,
                                                      curve: Curves.easeInOut,
                                                      duration: const Duration(
                                                          milliseconds: 800));
                                                } else {
                                                  CustomSearchController
                                                      controller =
                                                      Get.put<CustomSearchController>(
                                                          CustomSearchController());
                                                  controller.getProductsInSection(
                                                      sectionName:
                                                          "TRENDING BRANDS ITEMS",
                                                      payload: {
                                                        "brand_ids[0]":
                                                            otherBrandsId
                                                      });

                                                  Get.to(
                                                      () => const ResultView(),
                                                      transition:
                                                          Transition.fadeIn,
                                                      curve: Curves.easeInOut,
                                                      duration: const Duration(
                                                          milliseconds: 800));
                                                }
                                              });
                                      },
                                      separatorBuilder: (ctx, index) =>
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                      itemCount:
                                          controller.productsInBrands.length +
                                              1),
                                )),
                    ],
                  ),
                ),
    );
  }

///////////////////////////////////////////////////////////////////
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

class CouponsSliderWithIndicators extends StatefulWidget {
  const CouponsSliderWithIndicators({required this.couponsList});

  final List<Coupons> couponsList;

  @override
  _ImageSliderWithIndicatorsState createState() =>
      _ImageSliderWithIndicatorsState();
}

class _ImageSliderWithIndicatorsState
    extends State<CouponsSliderWithIndicators> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> child = widget.couponsList.map((coupon) {
      return InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: coupon.code!));
          Get.snackbar('Copied !', 'Copied To Clipboard',
              backgroundColor: primaryColor,
              icon: Icon(
                Icons.content_paste_outlined,
                color: Colors.white,
                size: 33.sp,
              ),
              isDismissible: true);
          // copied successfully
        },
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Container(
              padding: EdgeInsets.all(8),
              width: 350.w,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(left: 35.w),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 15.h,
                                  width: 2.w,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                coupon.amount == null
                                    ? Text(
                                        'Free Delivery',
                                        style: primaryTextStyle(
                                            size: 11.sp.round(),
                                            color: Colors.white,
                                            weight: FontWeight.w900),
                                      )
                                    : Text(
                                        "${coupon.amount} % Off",
                                        style: primaryTextStyle(
                                            color: Colors.white,
                                            size: 11.sp.round()),
                                      )
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                                width: 170.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "GET YOUR",
                                      style: boldTextStyle(
                                          size: 22.sp.round(),
                                          color: const Color(0xffE7D3FF),
                                          weight: FontWeight.w400),
                                    ),
                                    Text(
                                      "MARIANNELA",
                                      style: boldTextStyle(
                                          size: 22.sp.round(),
                                          color: const Color(0xffE7D3FF),
                                          weight: FontWeight.w400),
                                    ),
                                    Text(
                                      "COUPON",
                                      style: boldTextStyle(
                                          size: 22.sp.round(),
                                          color: const Color(0xffE7D3FF),
                                          weight: FontWeight.w400),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(right: 3.w),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                padding: EdgeInsets.only(top: 20.h, left: 15.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.sp),
                                    topLeft: Radius.circular(10.sp),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: coupon.amount == null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Free',
                                              style: primaryTextStyle(
                                                  size: 15.sp.round(),
                                                  color: Colors.black,
                                                  weight: FontWeight.w900),
                                            ),
                                            Text(
                                              'Delivery',
                                              style: primaryTextStyle(
                                                  size: 15.sp.round(),
                                                  color: Colors.black,
                                                  weight: FontWeight.w900),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${coupon.amount} %',
                                              style: primaryTextStyle(
                                                  size: 25.sp.round(),
                                                  weight: FontWeight.w900),
                                            ),
                                            Text(
                                              'Off',
                                              style: primaryTextStyle(
                                                  size: 12.sp.round(),
                                                  weight: FontWeight.w900),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Code : ${coupon.code}',
                                style: primaryTextStyle(
                                    color: Colors.white,
                                    weight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
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
                aspectRatio: 1.8,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  _current = index;
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              height: 25.h,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.couponsList.map((image) {
                    int index = widget.couponsList.indexOf(image);
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
            ),
          ],
        ),
      ],
    );
  }
}
