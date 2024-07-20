import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:maryana/app/modules/main/views/main_view.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/main.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Animate(
                  effects: [FadeEffect(), ScaleEffect()],
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/logo.svg",
                      width: 90.w,
                      height: 60.h,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Animate(
                  effects: const [FadeEffect(), ScaleEffect()],
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Dress the ",
                          style: TextStyle(
                            fontFamily: GoogleFonts.cormorant().fontFamily,
                            color: const Color(0xff33302E),
                            fontSize: 37.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "LUXURY",
                          style: TextStyle(
                            fontFamily: GoogleFonts.cormorant().fontFamily,
                            color: const Color(0xff370269),
                            fontSize: 37.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DelayedWidget(
                        delayDuration: const Duration(milliseconds: 900),
                        animationDuration: const Duration(seconds: 2),
                        animation: DelayedAnimations.SLIDE_FROM_LEFT,
                        child: SvgPicture.asset(
                          "assets/images/splash/Frame 33364.svg",
                        ),
                      ),
                      DelayedWidget(
                        delayDuration: const Duration(milliseconds: 900),
                        animationDuration: const Duration(seconds: 2),
                        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                        child: Image.asset(
                          "assets/images/splash/firstGirl.png",
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      DelayedWidget(
                        delayDuration: const Duration(milliseconds: 900),
                        animationDuration: const Duration(seconds: 2),
                        animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                        child: SvgPicture.asset(
                          "assets/images/splash/Frame 33363.svg",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Animate(
                  effects: [FadeEffect(), ScaleEffect()],
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/logo.svg",
                      width: 90.w,
                      height: 60.h,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Animate(
                  effects: const [FadeEffect(), ScaleEffect()],
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Dress the ",
                          style: TextStyle(
                            fontFamily: GoogleFonts.cormorant().fontFamily,
                            color: const Color(0xff33302E),
                            fontSize: 37.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "LUXURY",
                          style: TextStyle(
                            fontFamily: GoogleFonts.cormorant().fontFamily,
                            color: const Color(0xff370269),
                            fontSize: 37.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DelayedWidget(
                        delayDuration: const Duration(milliseconds: 900),
                        animationDuration: const Duration(seconds: 2),
                        animation: DelayedAnimations.SLIDE_FROM_LEFT,
                        child: SvgPicture.asset(
                          "assets/images/splash/Frame 33364.svg",
                        ),
                      ),
                      DelayedWidget(
                        delayDuration: const Duration(milliseconds: 900),
                        animationDuration: const Duration(seconds: 2),
                        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                        child: Image.asset(
                          "assets/images/splash/firstGirl.png",
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      DelayedWidget(
                        delayDuration: const Duration(milliseconds: 900),
                        animationDuration: const Duration(seconds: 2),
                        animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                        child: SvgPicture.asset(
                          "assets/images/splash/Frame 33363.svg",
                        ),
                      ),
                      DelayedWidget(
                        delayDuration: const Duration(milliseconds: 900),
                        animationDuration: const Duration(seconds: 2),
                        animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 60.w),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () async {
                                navigateToOnboarding();
                              },
                              child: SvgPicture.asset(
                                "assets/images/splash/BUTTON.svg",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
