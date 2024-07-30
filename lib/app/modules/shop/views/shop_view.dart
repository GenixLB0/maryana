import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/home/controllers/home_controller.dart';
import 'package:maryana/app/modules/product/controllers/product_controller.dart';
import 'package:maryana/app/modules/product/views/product_view.dart';
import 'package:maryana/app/modules/search/controllers/search_controller.dart';
import 'package:nb_utils/nb_utils.dart'
    hide primaryTextStyle
    hide boldTextStyle;
import 'package:shimmer/shimmer.dart';

import '../../../routes/app_pages.dart';
import '../../global/config/configs.dart';
import '../../global/theme/app_theme.dart';
import '../../search/views/result_view.dart';
import '../../search/views/search_view.dart';
import '../controllers/shop_controller.dart';

class ShopView extends GetView<ShopController> {
  const ShopView({Key? shopKey}) : super(key: shopKey);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ShopController());

    return Scaffold(
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: _buildAppBar(),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.white, // Customize background color
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: primaryColor, // Customize header background color
                  ),
                  child: Text(
                    'Categories',
                    style: primaryTextStyle(
                        size: 25.sp.round(), color: Colors.white),
                  ),
                ),
                GetBuilder<ShopController>(
                    id: "drawer_cats",
                    builder: (logic) {
                      return Column(
                        children: controller.categories
                            .map(
                              (cat) => InkWell(
                                onTap: () {
                                  Get.back();
                                  controller.getBrandsInCategory(cat.id!);
                                  controller.getProductsInCategory(cat.id!, "");
                                  controller.changeChoosenCat(cat);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 14.w,
                                      left: 14.w,
                                      top: 10.h,
                                      bottom: 10.h),
                                  child: Row(
                                    children: [
                                      Text(
                                        cat.name!,
                                        style: primaryTextStyle(),
                                      ),
                                      Spacer(),
                                      CachedNetworkImage(
                                        imageUrl: cat.image!,
                                        width: 50.w,
                                        height: 50.h,
                                        fit: BoxFit.cover,
                                        placeholder: (context, v) =>
                                            placeHolderWidget(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    })
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),

                  SizedBox(
                    height: 10.h,
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Row(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.purple,
                              highlightColor: primaryColor,
                              child: Obx(() {
                                return Text(
                                  controller.selectedCat.value.name ?? "",
                                  style: primaryTextStyle(
                                      weight: FontWeight.w700,
                                      size: 14.sp.round()),
                                );
                              }),
                            ),
                            Icon(Icons.keyboard_arrow_down_outlined)
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "TOP BRANDS",
                    style: boldTextStyle(
                        size: 16.sp.round(), weight: FontWeight.w400),
                  ),
                  _buildTopBrands(context),
                  Container(
                    height: 50.h,
                    child: Row(
                      children: [
                        Text("SHOP BY PRODUCTS",
                            style: boldTextStyle(
                                size: 16.sp.round(), weight: FontWeight.w400)),
                        Spacer(),
                        GetBuilder<ShopController>(
                            id: "products_in_categories",
                            builder: (logic) {
                              return Container(
                                  width: 90.w,
                                  height: 45.h,
                                  padding: EdgeInsets.all(5.0.w),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.grey[200]!),
                                      borderRadius:
                                          BorderRadius.circular(35.sp)),
                                  child: Center(
                                    child: PopupMenuButton<String>(
                                      color: Colors.white,
                                      elevation: 5,
                                      initialValue: "Filter",
                                      itemBuilder: (context) {
                                        return <String>[
                                          "featured",
                                          "best_selling",
                                          "latest",
                                          "oldest",
                                          "low-high",
                                          "high-low",
                                          "a-z",
                                          "z-a"
                                        ].map((str) {
                                          return PopupMenuItem(
                                            value: str,
                                            child: Text(str),
                                          );
                                        }).toList();
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            width: 50.w,
                                            child: Text(
                                              controller.selectedOption,
                                              overflow: TextOverflow.ellipsis,
                                              style: primaryTextStyle(
                                                  size: 10.sp.round()),
                                            ),
                                          ),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                      onSelected: (v) {
                                        controller.changeDropDownValue(
                                            controller.selectedCatId, v);
                                      },
                                    ),
                                  ));
                            }),
                        SizedBox(
                          width: 6.w,
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 6.h), // Add spacing if needed
                  _buildProductsInCategories(context) // Your grid view
                  // More widgets go here
                ],
              ),
            ),
          ),

          // Column(
          //   children: [

          //     SizedBox(
          //       height: 5.h,
          //     ),
          //     SingleChildScrollView(
          //       child: Column(
          //         children: [

          //           Expanded(child: Obx(() {
          //             return controller.isProductsInCategoryLoading.value
          //                 ? LoadingWidget(Container(
          //                     height: MediaQuery.of(context).size.height / 3,
          //                     child: GridView.count(
          //                       crossAxisCount: 2,
          //                       padding: EdgeInsets.all(8.w),
          //                       crossAxisSpacing: 10.h,
          //                       mainAxisSpacing: 10,
          //                       childAspectRatio: 6 / 7,
          //                       shrinkWrap: true,
          //                       children: <Widget>[
          //                         for (int i = 0; i < 12; ++i)
          //                           Container(
          //                               width: 100.w,
          //                               color: Color.fromARGB(
          //                                   255, 10 * i, 1 * i, 50))
          //                       ],
          //                     )))
          //                 : controller.productsInCategories.isEmpty
          //                     ? Padding(
          //                         padding: EdgeInsets.only(
          //                           left: MediaQuery.of(context).size.width / 9,
          //                           top: MediaQuery.of(context).size.height / 9,
          //                         ),
          //                         child: Text(
          //                           "No Products Yet ..",
          //                           style: primaryTextStyle(
          //                               size: 12.sp.round(),
          //                               color: Colors.black,
          //                               weight: FontWeight.w400),
          //                         ),
          //                       )
          //                     : GridView.builder(
          //                         gridDelegate:
          //                             SliverGridDelegateWithFixedCrossAxisCount(
          //                                 childAspectRatio:
          //                                     MediaQuery.of(context)
          //                                             .size
          //                                             .width /
          //                                         (MediaQuery.of(context)
          //                                                 .size
          //                                                 .height /
          //                                             1.1),
          //                                 crossAxisCount: 2,
          //                                 crossAxisSpacing: 5.w),
          //                         itemBuilder: (context, index) {
          //                           return buildProductCard(
          //                               product: controller
          //                                   .productsInCategories[index]);
          //                         },
          //                         itemCount:
          //                             controller.productsInCategories.length,
          //                       );
          //           })),
          //         ],
          //       ),
          //     )
          //     // _buildCategories(context),
          //   ],
          // ),
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
      flex: 5,
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
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4, child: _buildBrandsAndSubCategories(context))
          ],
        ),
      ),
    );
  }

  _buildBrandsAndSubCategories(context) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildProductsInCategories(context),
            // Obx(() {
            //   if (controller.showText.value &&
            //       controller.currentCatIndex.value !=
            //           (controller.categories.length - 1)) {
            //     return ShowUp(
            //       delay: 150,
            //       child: GestureDetector(
            //         onTap: () {
            //           controller.changeCurrentCat(true);
            //         },
            //         child: Padding(
            //           padding: EdgeInsets.only(left: 20.w, bottom: 5.h),
            //           child: Container(
            //             width: 170.w,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Icon(Icons.arrow_circle_down_rounded),
            //                 Text(
            //                   "Click To see ",
            //                   style: primaryTextStyle(
            //                       size: 12.sp.round(), color: Colors.grey[300]),
            //                 ),
            //                 Text(
            //                   "Products in ",
            //                   style: primaryTextStyle(
            //                       size: 12.sp.round(), color: Colors.grey[300]),
            //                 ),
            //                 Text(
            //                   "${controller.categories[controller.currentCatIndex.value + 1].name}",
            //                   style: primaryTextStyle(
            //                       size: 12.sp.round(), color: Colors.grey[300]),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     );
            //   } else {
            //     return const SizedBox();
            //   }
            // })
          ],
        ),
      ),
    );
  }

  _buildTopBrands(context) {
    return Obx(() {
      return controller.isBrandsLoading.value
          ? LoadingWidget(
              Container(
                  height: 120.h,
                  child: GridView.count(
                    crossAxisCount: 4,
                    padding: EdgeInsets.all(8.w),
                    crossAxisSpacing: 10.h,
                    mainAxisSpacing: 10,
                    childAspectRatio: 6 / 7,
                    shrinkWrap: true,
                    children: <Widget>[
                      for (int i = 0; i < 4; ++i)
                        Container(
                            width: 100.w,
                            color: Color.fromARGB(255, 10 * i, 1 * i, 50))
                    ],
                  )),
            )
          : controller.brands.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "No Brands Yet ..",
                        style: primaryTextStyle(
                            size: 12.sp.round(),
                            color: Colors.black,
                            weight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 35.h,
                      )
                    ],
                  ),
                )
              : Container(
                  height: 120.h,
                  child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      padding: EdgeInsets.all(8.w),
                      crossAxisSpacing: 10.h,
                      mainAxisSpacing: 10,
                      childAspectRatio: 6 / 7,
                      shrinkWrap: true,
                      children: controller.brands
                          .map((brand) => GestureDetector(
                                onTap: () {
                                  if (CustomSearchController().initialized) {
                                    CustomSearchController mycontroller =
                                        Get.find<CustomSearchController>();
                                    mycontroller.getProductsInSection(
                                        sectionName: brand.name!,
                                        payload: {
                                          "brand_ids[0]": brand.id.toString(),
                                          "category_ids[0]": controller
                                              .choosenCatId
                                              .toString(),
                                        });

                                    Get.to(() => const ResultView(),
                                        transition: Transition.fadeIn,
                                        curve: Curves.easeInOut,
                                        duration:
                                            const Duration(milliseconds: 400));
                                  } else {
                                    CustomSearchController mycontroller =
                                        Get.put<CustomSearchController>(
                                            CustomSearchController());
                                    mycontroller.getProductsInSection(
                                        sectionName: brand.name!,
                                        payload: {
                                          "brand_ids[0]": brand.id.toString(),
                                          "category_ids[0]": controller
                                              .choosenCatId
                                              .toString(),
                                        });

                                    Get.to(() => const ResultView(),
                                        transition: Transition.fadeIn,
                                        curve: Curves.easeInOut,
                                        duration:
                                            const Duration(milliseconds: 400));
                                  }
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: CachedNetworkImage(
                                    imageUrl: brand.image!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, val) =>
                                        placeHolderWidget(),
                                  ),
                                ),
                              ))
                          .toList()));
    });
  }

  _buildProductsInCategories(context) {
    return Obx(() {
      return controller.isProductsInCategoryLoading.value
          ? LoadingWidget(Container(
              height: MediaQuery.of(context).size.height,
              child: GridView.count(
                crossAxisCount: 2,
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
              )))
          : controller.productsInCategories.isEmpty
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
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.1),
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.w),
                  itemBuilder: (context, index) {
                    return buildProductCard(
                        product: controller.productsInCategories[index]);
                  },
                  itemCount: controller.productsInCategories.length,
                );
    });
  }

  _buildAppBar() {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          ShowUp(
            delay: 200,
            child: Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(
                    "Discover",
                    style: primaryTextStyle(
                        size: 22.sp.round(), weight: FontWeight.w600),
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
                      HomeController homeController =
                          HomeController().initialized
                              ? Get.find<HomeController>()
                              : Get.put(HomeController());
                      var products = homeController.homeModel.value.product;
                      var categories =
                          homeController.homeModel.value.categories;

                      Get.to(SearchView(),
                          arguments: [products, categories],
                          transition: Transition.fadeIn,
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 400));
                    },
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                ],
              ),
            ),
          ),
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
                  offset: Offset(-5, 0), // changes position of shadow
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
