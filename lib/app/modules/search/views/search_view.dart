import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/search/views/result_view.dart';
import 'package:pinput/pinput.dart';

import '../../global/config/configs.dart';
import '../../global/model/model_response.dart';
import '../../home/views/home_view.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<CustomSearchController> {
  SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CustomSearchController());
    controller.setArgs();
    print("switching to search ${controller.products.length}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                          "assets/images/forgot_password/BackBTN.svg"),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Reset",
                    style: primaryTextStyle(
                        weight: FontWeight.w600,
                        size: 14.sp.round(),
                        color: Color(0xffFF5247)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            buildSearchAndFilter(
                context: context,
                isSearch: true,
                onSubmitted: (v) {
                  controller.addSearchKeywords(v);
                  controller.getSearchResultsFromApi();

                  Get.to(() => const ResultView(),
                      transition: Transition.fadeIn,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 400));
                }),
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
              height: 15.h,
            ),
            GetBuilder<CustomSearchController>(
                builder: (_) => ShowUp(
                      child: buildSearchKeywords(context),
                      delay: 400,
                    )),
            Spacer(),
            GetBuilder<CustomSearchController>(
                builder: (cont) => ShowUp(
                      child: buildProductsScroll(context),
                      delay: 400,
                    )),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }

  buildProductsScroll(context) {
    return controller.products.isNotEmpty
        ? Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: smallSpacing),
                      child: Text(
                        "POPULAR THIS WEEK",
                        style: boldTextStyle(
                            weight: FontWeight.w400,
                            size: 20.sp.round(),
                            color: Colors.black),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (CustomSearchController().initialized) {
                          CustomSearchController controller =
                              Get.find<CustomSearchController>();
                          controller.getProductsInSection(
                              sectionName: "RECOMMENDED", payload: {});

                          Get.to(() => const ResultView(),
                              transition: Transition.fadeIn,
                              curve: Curves.easeInOut,
                              duration: const Duration(milliseconds: 400));
                        } else {
                          CustomSearchController controller =
                              Get.put<CustomSearchController>(
                                  CustomSearchController());
                          controller.getProductsInSection(
                              sectionName: "RECOMMENDED", payload: {});

                          Get.to(() => const ResultView(),
                              transition: Transition.fadeIn,
                              curve: Curves.easeInOut,
                              duration: const Duration(milliseconds: 400));
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
                  padding: EdgeInsets.all(smallSpacing),
                  height: 330.h,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return buildProductCard(
                            product: controller.products[index]);
                      },
                      separatorBuilder: (ctx, index) => SizedBox(
                            width: 10.w,
                          ),
                      itemCount: 5),
                ),
              ],
            ),
          )
        : SizedBox();
  }

  buildSearchKeywords(context) {
    return Container(
        padding: EdgeInsets.all(15),
        height: 150.h,
        width: MediaQuery.of(context).size.width,
        child: controller.searchKeywords.isEmpty
            ? Center(
                child: Text(
                  "No Search Words Yet ...",
                  style: primaryTextStyle(),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3.1,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    width: 166.w,
                    height: 38.h,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 166.w,
                            height: 45.h,
                            decoration: ShapeDecoration(
                              color: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 22.40,
                          top: 8,
                          child: Text(controller.searchKeywords[index],
                              style: secondaryTextStyle(
                                  weight: FontWeight.w600,
                                  size: 16.sp.round())),
                        ),
                        Positioned(
                          left: 127.30.w,
                          top: 9.h,
                          child: GestureDetector(
                            onTap: () {
                              controller.deleteSearchKeyword(
                                  controller.searchKeywords[index]);
                            },
                            child: Container(
                              width: 21.39.w,
                              height: 21.h,
                              child: Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: controller.searchKeywords.length,
              ));
  }
}
