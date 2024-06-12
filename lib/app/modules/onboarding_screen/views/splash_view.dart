import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maryana/app/modules/onboarding_screen/controllers/onboarding_screen_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:maryana/app/modules/onboarding_screen/views/onboarding_screen1_view.dart';

class SplashView extends GetView<OnboardingScreenController> {

  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

controller.startNavigation();
    return ScreenUtilInit(
  designSize: Size(375, 812),
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (_ , child) => Scaffold(

      body: Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              LottieBuilder.asset("assets/90751-android-app-background.json",
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height /2.62,),
                  SizedBox(

                    child: Shimmer.fromColors(
                      baseColor: Color(0xffBAA8E2),
                      highlightColor: Color(0xff4C1172),
                      child: Image.asset("assets/logo-D4X8uOTiU-transformed-removebg-preview.png" ,
                        width: 125.0.w, height: 125.h, fit: BoxFit.contain,),

                    ),
                  ),

                  SizedBox(height: 18.h,),
                  Spacer(),
                  SizedBox(

                    child: Shimmer.fromColors(
                      baseColor: Color(0xff961F19),
                      highlightColor: Colors.yellow,
                      child: Text(
                        '@MARIANELLA',
                        textAlign: TextAlign.center,
                        style: TextStyle(

                            fontSize: 23.sp ,
                            fontFamily: "Cormorant",
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 55.h,),
                ],
              )
            ],
          ),
        ),
      )


    // AnimatedSplashScreen(
    //   splash: LottieBuilder.asset("assets/90751-android-app-background.json",
    //           fit: BoxFit.cover,
    //          height: MediaQuery.of(context).size.height,
    //       width:  MediaQuery.of(context).size.width,
    //           ),
    //   // SafeArea(
    //   //   child: Stack(
    //   //     alignment: Alignment.center,
    //   //     children: [
    //   //       Container(
    //   //         height: MediaQuery.of(context).size.height,
    //   //         width:  MediaQuery.of(context).size.width,
    //   //         child: LottieBuilder.asset("assets/90751-android-app-background.json",
    //   //           fit: BoxFit.contain,
    //   //           height: MediaQuery.of(context).size.height,
    //   //           width:  MediaQuery.of(context).size.width,
    //   //         ),
    //   //       ),
    //   //       Column(
    //   //         crossAxisAlignment: CrossAxisAlignment.center,
    //   //         mainAxisAlignment: MainAxisAlignment.center,
    //   //         children: [
    //   //           // SizedBox(height: MediaQuery.of(context).size.height /3,),
    //   //           Image.asset("assets/logo-D4X8uOTiU-transformed-removebg-preview.png" , width: 55.0, height: 111, fit: BoxFit.contain,),
    //   //           Text("Marynella" , style: TextStyle(fontSize: 23),),
    //   //           SizedBox(height: 18,),
    //   //           Spacer(),
    //   //
    //   //
    //   //         ],
    //   //       )
    //   //     ],
    //   //   ),
    //   // ),
    //
    //
    //   // "assets/logo-D4X8uOTiU-transformed-removebg-preview.png",
    //   nextScreen: OnboardingScreen1View(),
    //   splashTransition: SplashTransition.fadeTransition,
    //   duration: 900,
    //   curve: Curves.easeOut,
    //  animationDuration: Duration(milliseconds: 900 ),
    //
    //
    // )
  )
);
  }
}
