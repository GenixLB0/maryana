import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import '../../global/config/configs.dart';
import '../../global/model/test_model_response.dart';
import '../../global/widget/widget.dart';
import '../controllers/search_controller.dart';
import '../../global/theme/app_theme.dart';

class ResultView extends GetView<CustomSearchController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.attachScroll();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 35.h,
                        width: 35.w,
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
                    GetBuilder<CustomSearchController>(
                      builder: (_) => Center(
                        child: Text(controller.titleResult,
                            overflow: TextOverflow.ellipsis,
                            style: primaryTextStyle(
                              weight: FontWeight.w900,
                              size: 18.sp.round(),
                            )),
                      ),
                    ),
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            SvgPicture.asset(
                              "assets/images/home/star.svg",
                              width: 30.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12.w, top: 1.h),
                              child: Obx(() {
                                return Text(
                                  "${controller.resultCount.value} Results",
                                  style: primaryTextStyle(
                                      size: 16.sp.round(),
                                      weight: FontWeight.w700),
                                );
                              }),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     // Text(
                              //     //   "Found",
                              //     //   style: primaryTextStyle(
                              //     //       size: 16.sp.round(),
                              //     //       weight: FontWeight.w700),
                              //     // ),
                              //     Obx(() {
                              //       return Text(
                              //         "${controller.resultCount.value} Results",
                              //         style: primaryTextStyle(
                              //             size: 16.sp.round(),
                              //             weight: FontWeight.w700),
                              //       );
                              //     }),
                              //   ],
                              // ),
                            ),
                          ],
                        ),

                        // Container(
                        //   width: 100.w,
                        //   height: 40.h,
                        //   decoration: BoxDecoration(
                        //       border:
                        //           Border.all(color: Colors.grey[400]!, width: 1.w),
                        //       borderRadius: BorderRadius.circular(30.sp)),
                        //   child: const Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [Text("Filter"), Icon(Icons.arrow_drop_down)],
                        //   ),
                        // ),
                      ],
                    ),
                  ]),
            ),

            // Obx(() {
            //   print("categories value is ${controller.categories}");
            //   return controller.isFromSearch.value
            //       ? controller.categories.isEmpty
            //           ? LoadingWidget(
            //               Padding(
            //                 padding: EdgeInsets.only(left: 16.w),
            //                 child: Align(
            //                   alignment: Alignment.topLeft,
            //                   child: ShowUp(
            //                     delay: 400,
            //                     child: Padding(
            //                       padding: EdgeInsets.symmetric(
            //                           horizontal: smallSpacing),
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           SizedBox(
            //                             height: 15.h,
            //                           ),
            //                           Text(
            //                             "Categories",
            //                             style: GoogleFonts.lora(
            //                               fontSize: 23.sp,
            //                               fontWeight: FontWeight.w500,
            //                             ),
            //                           ),
            //                           SizedBox(
            //                             height: 10.h,
            //                           ),
            //                           Container(
            //                             height: 100.h,
            //                             child: ListView.separated(
            //                                 shrinkWrap: true,
            //                                 scrollDirection: Axis.horizontal,
            //                                 itemBuilder: (ctx, index) =>
            //                                     GestureDetector(
            //                                       onTap: () {},
            //                                       child: Column(
            //                                         children: [
            //                                           Text(
            //                                             "",
            //                                             style: GoogleFonts.lora(
            //                                                 fontSize: 15.sp,
            //                                                 color: Colors.grey),
            //                                           ),
            //                                           const SizedBox(
            //                                             height: 1,
            //                                           ),
            //                                           Container(
            //                                             width: 4,
            //                                             height: 4,
            //                                             decoration:
            //                                                 const ShapeDecoration(
            //                                               color:
            //                                                   Color(0xFF090A0A),
            //                                               shape: OvalBorder(),
            //                                             ),
            //                                           )
            //                                         ],
            //                                       ),
            //                                     ),
            //                                 separatorBuilder: (ctx, index) =>
            //                                     SizedBox(
            //                                       width: 10.w,
            //                                     ),
            //                                 itemCount: 5),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             )
            //           : Padding(
            //               padding: EdgeInsets.only(left: 16.w),
            //               child: Align(
            //                 alignment: Alignment.topLeft,
            //                 child: ShowUp(
            //                   child: buildCatScroll(context),
            //                   delay: 400,
            //                 ),
            //               ),
            //             )
            //       : const SizedBox();
            // }),

            Obx(() {
              print("loading value is ${controller.isSearchLoading}");
              return controller.isSearchLoading.value
                  ? Expanded(child: loadingIndicatorWidget()
                      // LoadingWidget(
                      //   Container(
                      //       padding: EdgeInsets.all(15),
                      //       width: MediaQuery.of(context).size.width,
                      //       child: GridView.builder(
                      //         shrinkWrap: true,
                      //         gridDelegate:
                      //             SliverGridDelegateWithFixedCrossAxisCount(
                      //                 childAspectRatio: MediaQuery.of(context)
                      //                         .size
                      //                         .width /
                      //                     (MediaQuery.of(context)
                      //                             .size
                      //                             .height /
                      //                         1.4),
                      //                 crossAxisCount: 2,
                      //                 crossAxisSpacing: 5.w),
                      //         itemBuilder: (context, index) {
                      //           return buildProductCard(product:
                      //             image: "",
                      //             name: "",
                      //             description: "",
                      //             price: "",
                      //           );
                      //         },
                      //         itemCount: 8,
                      //       )),
                      // ),
                      )
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: ShowUp(
                          child: buildProductGrid(context),
                          delay: 400,
                        ),
                      ),
                    );
            }),
            Obx(() {
              return controller.isPaginationSearchLoading.value
                  ? loadingIndicatorWidget()
                  : const SizedBox();
            })
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        return !controller.isEndScroll.value
            ? const SizedBox()
            : InkWell(
                onTap: () {
                  controller.scrollToTop();
                },
                child: Container(
                  height: 45.h,
                  width: 45.w,
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
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(child: child, scale: animation);
                    },
                    child: Icon(
                      Icons.arrow_upward,
                      key: ValueKey<bool>(controller.isEndScroll.value),
                      size: 30.0,
                    ),
                  ),
                ),
                // Icon(
                //   Icons.arrow_upward,
                //   size: 20.w,
                // ),
              );

        // Container(
        //         width: 60.w,
        //         height: 60.h,
        //         child: FloatingActionButton(
        //           backgroundColor: Colors.white,
        //           onPressed: controller.scrollToTop,
        //           child: Icon(
        //             Icons.arrow_upward,
        //             color: primaryColor,
        //             size: 22,
        //           ),
        //         ),
        //       );
      }),
    );
  }

  buildCatScroll(context) {
    List<Categories> myCatList = [];
    Categories allItemCategory =
        Categories(name: "All", slug: "", image: "", id: 00);

    myCatList.add(allItemCategory);

    for (var cat in controller.categories) {
      myCatList.add(cat);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: smallSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15.h,
          ),
          Text(
            "Categories",
            style: GoogleFonts.lora(
              fontSize: 23.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 50.h,
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) => GestureDetector(
                      onTap: () {
                        controller.changeActiveCats(index);
                        controller.filterProductsAccordingToCat(
                            myCatList[index].id!, false, null);
                      },
                      child: Column(
                        children: [
                          Text(
                            myCatList[index].name != null
                                ? myCatList[index].name!
                                : "",
                            style: GoogleFonts.lora(
                                fontSize: 15.sp, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          GetBuilder<CustomSearchController>(builder: (cont) {
                            print("active cats ${cont.activeCats}");
                            return controller.activeCats.isEmpty
                                ? SizedBox()
                                : controller.activeCats[index] == 1
                                    ? Container(
                                        width: 4,
                                        height: 4,
                                        decoration: const ShapeDecoration(
                                          color: Color(0xFF090A0A),
                                          shape: OvalBorder(),
                                        ),
                                      )
                                    : const SizedBox();
                          })
                        ],
                      ),
                    ),
                separatorBuilder: (ctx, index) => SizedBox(
                      width: 10.w,
                    ),
                itemCount: myCatList.length),
          ),
        ],
      ),
    );
  }

  buildProductGrid(context) {
    print("product grid are ${controller.resultSearchProducts}");

    return Obx(() {
      return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: controller.resultSearchProducts.isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Sorry , No Products Found",
                    style: primaryTextStyle(
                        size: 20.sp.round(),
                        color: Colors.black,
                        weight: FontWeight.w400),
                  ),
                )
              : GridView.builder(
                  controller: controller.scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height *
                              heightDevidedRatio),
                      crossAxisCount: 2,
                      crossAxisSpacing: crossAxisSpacing,
                      mainAxisSpacing: mainAxisSpacing),
                  itemBuilder: (context, index) {
                    return buildProductCard(
                        product: controller.resultSearchProducts[index]);
                  },
                  itemCount: controller.resultSearchProducts.length,
                ));
    });
  }
}
