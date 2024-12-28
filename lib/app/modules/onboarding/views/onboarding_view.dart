import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_widget/delayed_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:maryana/app/modules/auth/bindings/auth_binding.dart';
import 'package:maryana/app/modules/auth/views/login_view.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/routes/app_pages.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery
        .of(context)
        .size
        .height;

    List<Widget> onboardingViewList = [
      // firstOnBoardingScreen(deviceHeight, context),
      // secondOnBoardingScreen(deviceHeight, context),
      // thirdOnBoardingScreen(deviceHeight, context),
    ];
    Get.lazyPut(() => OnboardingController());

    return Obx(() {
      return Scaffold(
          body:
          controller.isOnBoardingLoading.value ? Center(
              child: loadingIndicatorWidget()) :

          SafeArea(
            child: Container(
              width: 375.w,
              height: 812.h,
              child: Stack(
                children:
                [
                  // firstOnBoardingScreen(deviceHeight, context),

                  PageView(

                    onPageChanged: (index) {
                      // controller.changeIndexValue(index);
                      //  controller.nextFunction();

                    },

                    controller: controller.pageController,
                     physics: NeverScrollableScrollPhysics(),


                    scrollDirection: Axis.horizontal,

                    children: List.generate(
                      controller.splashes.length,
                          (index) =>
                          customOnBoardingScreen(deviceHeight, context,
                              controller.splashes[index].image,
                              controller.splashes[index].caption, index),
                    ),

                  ),
                  // Obx(
                  //   () => Padding(
                  //     padding: EdgeInsets.only(
                  //         top: MediaQuery.of(context).size.height - 100.h,
                  //         left: MediaQuery.of(context).size.width - 200.w),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.max,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: <Widget>[
                  //         _Indicator(
                  //           positionIndex: 0,
                  //           currentIndex: controller.currentIndex.value,
                  //         ),
                  //         const SizedBox(
                  //           width: 10,
                  //         ),
                  //         _Indicator(
                  //           positionIndex: 1,
                  //           currentIndex: controller.currentIndex.value,
                  //         ),
                  //         const SizedBox(
                  //           width: 10,
                  //         ),
                  //         _Indicator(
                  //           positionIndex: 2,
                  //           currentIndex: controller.currentIndex.value,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ));
    });
  }

  // firstOnBoardingScreen(deviceHeight, context) {
  //   return Stack(
  //     children: [
  //       SizedBox(
  //           width: double.infinity,
  //           height: double.infinity,
  //           child: Image.asset(
  //             "assets/images/onboarding/Bg.png",
  //             fit: BoxFit.fill,
  //           )),
  //       Padding(
  //         padding: EdgeInsets.only(
  //             left: 25.w, top: MediaQuery
  //             .of(context)
  //             .size
  //             .height * 0.55),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text("CLASSY  ",
  //                 style: boldTextStyle(
  //                     color: Colors.white,
  //                     size: 54.sp.round(),
  //                     weight: FontWeight.w400,
  //                     height: 0.52.h)),
  //             Text("FROM HEAD",
  //                 style: boldTextStyle(
  //                   color: Colors.white,
  //                   size: 54.sp.round(),
  //                   weight: FontWeight.w400,
  //                 )),
  //             Text("TO TOE",
  //                 style: boldTextStyle(
  //                     color: Colors.white,
  //                     size: 54.sp.round(),
  //                     weight: FontWeight.w400,
  //                     height: 0.52.h)),
  //             Padding(
  //               padding: EdgeInsets.only(top: 25.h),
  //               child: Hero(
  //                 tag: 'id',
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     Navigator.push(
  //                       context,
  //                       PageRouteBuilder(
  //                         pageBuilder: (_, __, ___) =>
  //                             secondOnBoardingScreen(deviceHeight, context),
  //                         transitionDuration: const Duration(milliseconds: 500),
  //                         transitionsBuilder: (_, a, __, c) =>
  //                             FadeTransition(opacity: a, child: c),
  //                       ),
  //                     );
  //                   },
  //                   child: SvgPicture.asset(
  //                     "assets/images/onboarding/BUTTON (1).svg",
  //                     width: 160.w,
  //                     height: 60.h,
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //       Padding(
  //         padding:
  //         EdgeInsets.only(left: MediaQuery
  //             .of(context)
  //             .size
  //             .width - 95.w),
  //         child: Align(
  //           alignment: Alignment.bottomRight,
  //           child: Container(
  //             height: 50.h,
  //             child: Column(
  //               children: [
  //                 Row(
  //                   mainAxisSize: MainAxisSize.max,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: <Widget>[
  //                     Hero(
  //                       tag: 'dot',
  //                       child: _Indicator(
  //                         positionIndex: 0,
  //                         currentIndex: controller.currentIndex.value,
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       width: 10,
  //                     ),
  //                     _Indicator(
  //                       positionIndex: 1,
  //                       currentIndex: controller.currentIndex.value,
  //                     ),
  //                     const SizedBox(
  //                       width: 10,
  //                     ),
  //                     _Indicator(
  //                       positionIndex: 2,
  //                       currentIndex: controller.currentIndex.value,
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 20.h,
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // secondOnBoardingScreen(deviceHeight, context) {
  //   return Material(
  //     child: Stack(
  //       children: [
  //         SizedBox(
  //             width: double.infinity,
  //             height: double.infinity,
  //             child: Image.asset(
  //               "assets/images/onboarding/Bg (1).png",
  //               fit: BoxFit.fill,
  //             )),
  //         Padding(
  //           padding: EdgeInsets.only(
  //               left: 25.w, top: MediaQuery
  //               .of(context)
  //               .size
  //               .height * 0.61),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text("FLY AWAY ",
  //                   style: boldTextStyle(
  //                       color: Colors.white,
  //                       size: 50.sp.round(),
  //                       weight: FontWeight.w400,
  //                       height: 0.52.h)),
  //               Text("WITH YOUR",
  //                   style: boldTextStyle(
  //                     color: Colors.white,
  //                     size: 50.sp.round(),
  //                     weight: FontWeight.w400,
  //                   )),
  //               Text("STYLE",
  //                   style: boldTextStyle(
  //                       color: Colors.white,
  //                       size: 50.sp.round(),
  //                       weight: FontWeight.w400,
  //                       height: 0.52.h)),
  //               Padding(
  //                 padding: EdgeInsets.only(top: 25.h),
  //                 child: Hero(
  //                   tag: 'id',
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       Navigator.push(
  //                         context,
  //                         PageRouteBuilder(
  //                           pageBuilder: (_, __, ___) =>
  //                               thirdOnBoardingScreen(deviceHeight, context),
  //                           transitionDuration:
  //                           const Duration(milliseconds: 500),
  //                           transitionsBuilder: (_, a, __, c) =>
  //                               FadeTransition(opacity: a, child: c),
  //                         ),
  //                       );
  //                     },
  //                     child: SvgPicture.asset(
  //                       "assets/images/onboarding/BUTTON (1).svg",
  //                       width: 148.w,
  //                       height: 53.h,
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding:
  //           EdgeInsets.only(left: MediaQuery
  //               .of(context)
  //               .size
  //               .width - 95.w),
  //           child: Align(
  //             alignment: Alignment.bottomRight,
  //             child: Container(
  //               height: 50.h,
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     mainAxisSize: MainAxisSize.max,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       _Indicator(
  //                         positionIndex: 0,
  //                         currentIndex: 2,
  //                       ),
  //                       SizedBox(
  //                         width: 10,
  //                       ),
  //                       Hero(
  //                         tag: 'dot',
  //                         child: _Indicator(
  //                           positionIndex: 1,
  //                           currentIndex: 1,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         width: 10,
  //                       ),
  //                       _Indicator(
  //                         positionIndex: 2,
  //                         currentIndex: 3,
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 20.h,
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // thirdOnBoardingScreen(deviceHeight, context) {
  //   return Material(
  //     child: Stack(
  //       children: [
  //         SizedBox(
  //             width: double.infinity,
  //             height: double.infinity,
  //             child: Image.asset(
  //               "assets/images/onboarding/Bg (2).png",
  //               fit: BoxFit.fill,
  //             )),
  //         Padding(
  //           padding: EdgeInsets.only(
  //               left: 25.w, top: MediaQuery
  //               .of(context)
  //               .size
  //               .height * 0.61),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text("CLOTHES ",
  //                   style: boldTextStyle(
  //                       color: Colors.white,
  //                       size: 50.sp.round(),
  //                       weight: FontWeight.w400,
  //                       height: 0.52.h)),
  //               Text("FOR A BIG",
  //                   style: boldTextStyle(
  //                     color: Colors.white,
  //                     size: 50.sp.round(),
  //                     weight: FontWeight.w400,
  //                   )),
  //               Text("PLANET",
  //                   style: boldTextStyle(
  //                       color: Colors.white,
  //                       size: 50.sp.round(),
  //                       weight: FontWeight.w400,
  //                       height: 0.52.h)),
  //               Padding(
  //                 padding: EdgeInsets.only(top: 25.h),
  //                 child: Hero(
  //                   tag: 'id',
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       // Navigator.push(
  //                       //   context,
  //                       //   PageRouteBuilder(
  //                       //     pageBuilder: (_, __, ___) =>
  //                       //         thirdOnBoardingScreen(deviceHeight, context),
  //                       //     transitionDuration: Duration(seconds: 1),
  //                       //     transitionsBuilder: (_, a, __, c) =>
  //                       //         FadeTransition(opacity: a, child: c),
  //                       //   ),
  //                       // );
  //                       Get.to(LoginView());
  //                     },
  //                     child: SvgPicture.asset(
  //                       "assets/images/onboarding/BUTTON (2).svg",
  //                       width: 253.w,
  //                       height: 53.h,
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding:
  //           EdgeInsets.only(left: MediaQuery
  //               .of(context)
  //               .size
  //               .width - 95.w),
  //           child: Align(
  //             alignment: Alignment.bottomRight,
  //             child: Container(
  //               height: 50.h,
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     mainAxisSize: MainAxisSize.max,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       _Indicator(
  //                         positionIndex: 0,
  //                         currentIndex: 2,
  //                       ),
  //                       SizedBox(
  //                         width: 10,
  //                       ),
  //                       _Indicator(
  //                         positionIndex: 2,
  //                         currentIndex: 1,
  //                       ),
  //                       SizedBox(
  //                         width: 10,
  //                       ),
  //                       Hero(
  //                         tag: 'dot',
  //                         child: _Indicator(
  //                           positionIndex: 3,
  //                           currentIndex: 3,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 20.h,
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }


  customOnBoardingScreen(deviceHeight, context, image, text, index) {
    return Obx(() {
      return Stack(
        children: [
          SizedBox(
              width: double.infinity,
              height: double.infinity,
              child:
              CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.fill,
                placeholder: (context, url) => placeHolderWidget(),
              )).animate()
              .slideX(duration: const Duration(milliseconds: 200), curve: Curves.easeIn),


          Padding(
            padding: EdgeInsets.only(
                left: 25.w, top: MediaQuery
                .of(context)
                .size
                .height * 0.55),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [



                // Text("CLASSY  ",
                //     style: boldTextStyle(
                //         color: Colors.white,
                //         size: 54.sp.round(),
                //         weight: FontWeight.w400,
                //         height: 0.52.h)),
                // Text("FROM HEAD",
                //     style: boldTextStyle(
                //       color: Colors.white,
                //       size: 54.sp.round(),
                //       weight: FontWeight.w400,
                //     )),
                // Text("TO TOE",
                //     style: boldTextStyle(
                //         color: Colors.white,
                //         size: 54.sp.round(),
                //         weight: FontWeight.w400,
                //         height: 0.52.h)),
                Padding(
                  padding: EdgeInsets.only(top: 25.h),
                  child: Hero(
                    tag: 'id',
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder: (_, __, ___) =>
                        //         secondOnBoardingScreen(deviceHeight, context),
                        //     transitionDuration: const Duration(milliseconds: 500),
                        //     transitionsBuilder: (_, a, __, c) =>
                        //         FadeTransition(opacity: a, child: c),
                        //   ),
                        // );
                        // controller.changeIndexValue(index);
                        controller.nextFunction();

                      },
                      child: SvgPicture.asset(
                        "assets/images/onboarding/BUTTON (1).svg",
                        width: 160.w,
                        height: 60.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                SizedBox(
                  width: 250.w,

                  child: Padding(
                    padding: EdgeInsets.only(top: 25.h,
                    right: 25.w

                    ),
                    child: Text(text,

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: boldTextStyle(
                          color: Colors.white,
                          size: 44.sp.round(),
                          weight: FontWeight.w400,
                          height: 0.952.h),
                      textAlign: TextAlign.start,).animate()
                        .slideY(duration: const Duration(milliseconds: 500), curve: Curves.easeInCubic ,),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
            EdgeInsets.only(left: MediaQuery
                .of(context)
                .size
                .width - 95.w),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 50.h,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:
                      List.generate(controller.splashes.length, (index) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: _Indicator(
                          positionIndex: index,
                          currentIndex: controller.currentIndex.value,
                          isActive: index == controller.currentIndex.value,
                        ),
                      )),


                      // <Widget>[
                      //   Hero(
                      //     tag: 'dot',
                      //     child: _Indicator(
                      //       positionIndex: 0,
                      //       currentIndex: controller.currentIndex.value,
                      //     ),
                      //   ),
                      //   const SizedBox(
                      //     width: 10,
                      //   ),
                      //   _Indicator(
                      //     positionIndex: 1,
                      //     currentIndex: controller.currentIndex.value,
                      //   ),
                      //   const SizedBox(
                      //     width: 10,
                      //   ),
                      //   _Indicator(
                      //     positionIndex: 2,
                      //     currentIndex: controller.currentIndex.value,
                      //   ),
                      // ],
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

}

class _Indicator extends StatelessWidget {
  final int positionIndex, currentIndex;
final bool isActive;
  const _Indicator({required this.currentIndex, required this.positionIndex, required this.isActive});

  @override
  Widget build(BuildContext context) {
   print("positionIndex: $positionIndex, currentIndex: $currentIndex, isActive: $isActive");
    return Container(
      height: positionIndex == currentIndex ? 12 : 10,
      width: positionIndex == currentIndex ? 12 : 10,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: isActive
              ? const Color(0xffAA61FF)
              : Colors.white,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}

class AnimatedContainerExample extends StatefulWidget {
  AnimatedContainerExample(this.currentPage);

  final int currentPage;

  @override
  _AnimatedContainerExampleState createState() =>
      _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  double _containerWidth = 100;
  double _containerHeight = 100;
  Color _containerColor = Colors.blue;

  void _toggleSize() {
    if (widget.currentPage == 0) {
      setState(() {
        _containerWidth = _containerWidth = 100;
        _containerHeight = 100;
      });
    }

    if (widget.currentPage == 1) {
      setState(() {
        _containerWidth = 200;
        _containerHeight = 200;
      });
    }

    if (widget.currentPage == 2) {
      setState(() {
        _containerWidth = 300;
        _containerHeight = 300;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          OnboardingController onboardingController =
          Get.find<OnboardingController>();

          onboardingController.nextFunction();
          _toggleSize;
        },
        child: AnimatedContainer(
            width: _containerWidth,
            height: _containerHeight,
            color: Colors.transparent,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            child: widget.currentPage == 0
                ? SvgPicture.asset(
              "assets/images/onboarding/BUTTON (1).svg",
              width: _containerWidth,
              height: _containerHeight,
            )
                : widget.currentPage == 1
                ? SvgPicture.asset(
              "assets/images/onboarding/BUTTON (1).svg",
              width: _containerWidth,
              height: _containerHeight,
            )
                : SvgPicture.asset(
              "assets/images/onboarding/BUTTON (2).svg",
              width: _containerWidth,
              height: _containerHeight,
            )),
      ),
    );
  }
}
