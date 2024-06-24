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
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
              buildSearchAndFilter(context),
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
        ));
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
                onSubmitted: (v) {
                  controller.addSearchKeywords(v);
                  controller.getSearchResultsFromApi();

                  Get.to(() => ResultView());
                },
                autofocus: true,
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

  buildProductsScroll(context) {
    return Container(
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
              Text(
                "SHOW ALL",
                style: boldTextStyle(
                    weight: FontWeight.w400,
                    size: 20.sp.round(),
                    color: Color(0xff9B9B9B)),
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
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.sp),
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
                                  ? Image.asset(
                                      "assets/images/placeholder.png",
                                      width: 160.w,
                                      height: 210.h,
                                    )
                                  : Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              controller.products[index].image!,
                                          width: 165.w,
                                          height: 210.h,
                                          fit: BoxFit.cover,
                                          placeholder: (ctx, v) {
                                            return Image.asset(
                                              "assets/images/placeholder.png",
                                              width: 100.w,
                                              height: 200.h,
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
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
                        : Image.asset(
                            "assets/images/placeholder.png",
                            width: 200.w,
                            height: 200.h,
                          ),
                  );
                },
                separatorBuilder: (ctx, index) => SizedBox(
                      width: 10.w,
                    ),
                itemCount: controller.products.length),
          ),
        ],
      ),
    );
  }

  buildSearchKeywords(context) {
    return Container(
        padding: EdgeInsets.all(15),
        height: 150.h,
        width: MediaQuery.of(context).size.width,
        child: GridView.builder(
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
                            weight: FontWeight.w600, size: 16.sp.round())),
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
