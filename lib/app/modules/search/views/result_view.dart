import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:nb_utils/nb_utils.dart' hide primaryTextStyle;
import '../../global/widget/widget.dart';
import '../controllers/search_controller.dart';
import '../../global/theme/app_theme.dart';

class ResultView extends GetView<CustomSearchController> {
  const ResultView({super.key});

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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3.5,
                      ),
                      GetBuilder<CustomSearchController>(
                        builder: (_) => Text(controller.titleResult,
                            style: TextStyle(
                                fontFamily: fontCormoantFont,
                                fontWeight: FontWeight.w700,
                                fontSize: 22.sp)),
                      ),
                    ]),
              ),
              SizedBox(
                height: 15.h,
              ),
              Obx(() {
                print("categories value is ${controller.categories}");
                return controller.categories.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 9),
                        child: loadingIndicatorWidget(),
                      )
                    : buildCatScroll(context);
              }),
              Obx(() {
                print("loading value is ${controller.isSearchLoading}");
                return controller.isSearchLoading.value
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 3),
                        child: loadingIndicatorWidget(),
                      )
                    : buildProductGrid(context);
              })
            ],
          ),
        ));
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
      padding: EdgeInsets.symmetric(horizontal: 15.w),
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
            height: 100.h,
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
                            return controller.activeCats[index] == 1
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

    return GetBuilder<CustomSearchController>(
        builder: (_) => Expanded(
              child: Container(
                  padding: EdgeInsets.all(15),
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              1.2),
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
                              child: controller
                                          .resultSearchProducts[index].image !=
                                      null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        controller.resultSearchProducts[index]
                                                .image!.isEmpty
                                            ? placeHolderWidget()
                                            : Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: controller
                                                        .resultSearchProducts[
                                                            index]
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
                                            controller
                                                .resultSearchProducts[index]
                                                .name!,
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
                                            controller
                                                .resultSearchProducts[index]
                                                .description!,
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
                                            "\$ ${controller.resultSearchProducts[index].price!} ",
                                            style: primaryTextStyle(
                                                weight: FontWeight.w600,
                                                size: 15.sp.round(),
                                                color: Color(0xff370269)),
                                          ),
                                        ),
                                      ],
                                    )
                                  : placeHolderWidget(),
                            );
                          },
                          itemCount: controller.resultSearchProducts.length,
                        )
                  // GetBuilder<SearchController>(builder: (_)=>
                  //
                  //     GridView.builder(
                  //       gridDelegate:
                  //       SliverGridDelegateWithFixedCrossAxisCount(
                  //           childAspectRatio: MediaQuery.of(context).size.width /
                  //               (MediaQuery.of(context).size.height / 1.2), crossAxisCount: 2,
                  //           crossAxisSpacing: 5.w
                  //
                  //
                  //       ),
                  //       itemBuilder: (context, index) {
                  //         if(controller.selectedId == 0){
                  //           return Container(
                  //
                  //             decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(4.sp),
                  //               boxShadow: const [
                  //                 BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 15),
                  //               ],
                  //
                  //             ),
                  //             child:
                  //             controller.resultSearchProducts[index].image != null ?
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //
                  //                 controller.resultSearchProducts[index].image!.isEmpty?
                  //                 Image.asset("assets/images/placeholder.png",
                  //                   width: 160.w,
                  //                   height: 210.h,
                  //                 )
                  //                     :
                  //                 Stack(
                  //                   alignment: Alignment.topRight,
                  //                   children: [
                  //                     CachedNetworkImage(
                  //                       imageUrl:
                  //
                  //                       controller.resultSearchProducts[index].image! ,
                  //                       width: 175.w,
                  //                       height: 210.h,
                  //                       fit: BoxFit.cover,
                  //                       placeholder: (ctx , v){
                  //                         return Image.asset("assets/images/placeholder.png",
                  //                           width: 100.w,
                  //                           height: 200.h,
                  //                         );
                  //                       },
                  //
                  //                     ),
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(8.0),
                  //                       child: SvgPicture.asset(
                  //                         "assets/images/home/add_to_wishlist.svg",
                  //                         width: 33.w,
                  //                         height: 33.h,
                  //                         fit: BoxFit.cover,
                  //
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 3.h,),
                  //                 Padding(
                  //                   padding:  EdgeInsets.only(left: 5.w),
                  //                   child: Text(
                  //                     controller.resultSearchProducts[index].name!,
                  //                     style: primaryTextStyle(
                  //                         weight: FontWeight.w700,
                  //                         size: 16.sp.round(),
                  //                         color: Colors.black
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 1.h,),
                  //                 Container(
                  //                   padding:  EdgeInsets.only(left: 5.w),
                  //                   width: 150.w,
                  //                   child: Text(
                  //                     controller.resultSearchProducts[index].description!,
                  //                     overflow: TextOverflow.ellipsis,
                  //                     style: primaryTextStyle(
                  //                         weight: FontWeight.w300,
                  //                         size: 14.sp.round(),
                  //                         color: Color(0xff9B9B9B)
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 1.h,),
                  //                 Padding(
                  //                   padding:  EdgeInsets.only(left: 5.w),
                  //                   child: Text(
                  //                     "\$ ${controller.resultSearchProducts[index].price!} ",
                  //                     style: primaryTextStyle(
                  //                         weight: FontWeight.w600,
                  //                         size: 15.sp.round(),
                  //                         color: Color(0xff370269)
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             )
                  //                 :
                  //             Image.asset("assets/images/placeholder.png",
                  //               width: 200.w,
                  //               height: 200.h,
                  //             ),
                  //           );
                  //         } else if(controller.selectedId == controller.products[index].id){
                  //           Container(
                  //
                  //             decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(4.sp),
                  //               boxShadow: const [
                  //                 BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 15),
                  //               ],
                  //
                  //             ),
                  //             child:
                  //             controller.resultSearchProducts[index].image != null ?
                  //             Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //
                  //                 controller.resultSearchProducts[index].image!.isEmpty?
                  //                 Image.asset("assets/images/placeholder.png",
                  //                   width: 160.w,
                  //                   height: 210.h,
                  //                 )
                  //                     :
                  //                 Stack(
                  //                   alignment: Alignment.topRight,
                  //                   children: [
                  //                     CachedNetworkImage(
                  //                       imageUrl:
                  //
                  //                       controller.resultSearchProducts[index].image! ,
                  //                       width: 175.w,
                  //                       height: 210.h,
                  //                       fit: BoxFit.cover,
                  //                       placeholder: (ctx , v){
                  //                         return Image.asset("assets/images/placeholder.png",
                  //                           width: 100.w,
                  //                           height: 200.h,
                  //                         );
                  //                       },
                  //
                  //                     ),
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(8.0),
                  //                       child: SvgPicture.asset(
                  //                         "assets/images/home/add_to_wishlist.svg",
                  //                         width: 33.w,
                  //                         height: 33.h,
                  //                         fit: BoxFit.cover,
                  //
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 3.h,),
                  //                 Padding(
                  //                   padding:  EdgeInsets.only(left: 5.w),
                  //                   child: Text(
                  //                     controller.resultSearchProducts[index].name!,
                  //                     style: primaryTextStyle(
                  //                         weight: FontWeight.w700,
                  //                         size: 16.sp.round(),
                  //                         color: Colors.black
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 1.h,),
                  //                 Container(
                  //                   padding:  EdgeInsets.only(left: 5.w),
                  //                   width: 150.w,
                  //                   child: Text(
                  //                     controller.resultSearchProducts[index].description!,
                  //                     overflow: TextOverflow.ellipsis,
                  //                     style: primaryTextStyle(
                  //                         weight: FontWeight.w300,
                  //                         size: 14.sp.round(),
                  //                         color: Color(0xff9B9B9B)
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 1.h,),
                  //                 Padding(
                  //                   padding:  EdgeInsets.only(left: 5.w),
                  //                   child: Text(
                  //                     "\$ ${controller.resultSearchProducts[index].price!} ",
                  //                     style: primaryTextStyle(
                  //                         weight: FontWeight.w600,
                  //                         size: 15.sp.round(),
                  //                         color: Color(0xff370269)
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             )
                  //                 :
                  //             Image.asset("assets/images/placeholder.png",
                  //               width: 200.w,
                  //               height: 200.h,
                  //             ),
                  //           );
                  //         } else {
                  //           return const SizedBox();
                  //         }
                  //         return const SizedBox();
                  //
                  //
                  //
                  //       },
                  //       itemCount: controller.resultSearchProducts.length,
                  //     )
                  //
                  // )
                  ),
            ));
  }
}
