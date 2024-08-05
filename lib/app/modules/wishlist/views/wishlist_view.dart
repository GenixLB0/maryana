import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart' hide primaryTextStyle;

import '../../global/config/configs.dart';
import '../../global/model/test_model_response.dart';
import '../../global/theme/app_theme.dart';
import '../../global/widget/widget.dart';
import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (WishlistController().initialized) {
      print("true done yes");
    } else {
      print("true done no");

      Get.lazyPut<WishlistController>(() => WishlistController());
    }
    print(
        "starting wishlist view with a list of ${controller.resultSearchProducts.length}");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: controller.isAuth.value
              ? SingleChildScrollView(
                  key: const PageStorageKey<String>("pageThree"),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 120.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // InkWell(
                                //   onTap: () {
                                //     Get.back();
                                //   },
                                //   child: Container(
                                //     height: 40.h,
                                //     width: 40.w,
                                //     decoration: BoxDecoration(
                                //       color: Colors.white,
                                //       borderRadius: BorderRadius.all(Radius.circular(30)),
                                //       boxShadow: [
                                //         BoxShadow(
                                //           color: Colors.grey.withOpacity(0.4),
                                //           spreadRadius: 5,
                                //           blurRadius: 7,
                                //           offset:
                                //               Offset(0, 3), // changes position of shadow
                                //         ),
                                //       ],
                                //     ),
                                //     child: SvgPicture.asset(
                                //         "assets/images/forgot_password/BackBTN.svg"),
                                //   ),
                                // ),
                                Expanded(
                                  child: Center(
                                    child: Text("My Wishlist",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: GoogleFonts.cormorant().fontFamily,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 22.sp)),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        buildSearchAndFilter(
                          context: context,
                          isSearch: false,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Obx(() {
                          print(
                              "loading value is ${controller.isWishlistLoading}");
                          return controller.isWishlistLoading.value
                              ? Expanded(child: loadingIndicatorWidget())
                              : Expanded(
                                  child: ShowUp(
                                    child: buildProductGrid(context),
                                    delay: 400,
                                  ),
                                );
                        })
                      ],
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.center, child: socialMediaPlaceHolder()),
        ));
  }

  buildProductGrid(context) {
    print("product grid are ${controller.resultSearchProducts}");

    return Obx(() {
      return Container(
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.1),
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.w),
                  itemBuilder: (context, index) {
                    return buildProductCard(
                      product:
                          // ViewProductData.fromJson(
                          //     controller.resultSearchProducts[index])
                          controller.resultSearchProducts[index],
                      isInWishlist: true,
                    );
                  },
                  itemCount: controller.resultSearchProducts.length,
                ));
    });
  }
}
