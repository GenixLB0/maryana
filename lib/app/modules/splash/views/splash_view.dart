import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:page_transition/page_transition.dart';



import '../../onboarding/views/onboarding_view.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:

        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: 30.h,),
              Animate(
                effects: [FadeEffect(), ScaleEffect()],
                child:   Center(

                    child: SvgPicture.asset("assets/images/logo.svg",

                      width: 90.w, height: 60.h, fit: BoxFit.scaleDown,
                    )
),

              ),


              SizedBox(height: 20.h,),
              Animate(
                effects: const [FadeEffect(), ScaleEffect()],
                child:    Center(
                  child:
                  Column(
                    children: [
                      Text("Dress the " , style:
                      TextStyle(
                        fontFamily: fontCormoantFont,
                        color: Color(0xff33302E),
                        fontSize: 37.sp,
                        fontWeight: FontWeight.w600,
                      ),

                      ),
                      Text("LUXURY" , style:
                      TextStyle(
                        fontFamily: fontCormoantFont,
                        color: Color(0xff370269),
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
                      delayDuration: Duration(milliseconds: 900),// Not required
                      animationDuration: Duration(seconds: 2),// Not required
                      animation: DelayedAnimations.SLIDE_FROM_LEFT,
                      child:  SvgPicture.asset("assets/images/splash/Frame 33364.svg"),// Not required

                    ),


                    DelayedWidget(
                      delayDuration: const Duration(milliseconds: 900),// Not required
                      animationDuration: const Duration(seconds: 2),// Not required
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child: Image.asset(
                        "assets/images/splash/firstGirl.png",
                        fit: BoxFit.cover,
                        height:MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      ),// Not required

                    ),
                    DelayedWidget(
                      delayDuration: const Duration(milliseconds: 900),// Not required
                      animationDuration: const Duration(seconds: 2),// Not required
                      animation: DelayedAnimations.SLIDE_FROM_RIGHT,
                      child:  SvgPicture.asset("assets/images/splash/Frame 33363.svg"),// Not required

                    ),



                    DelayedWidget(
                      delayDuration: const Duration(milliseconds: 900),// Not required
                      animationDuration: const Duration(seconds: 2),// Not required
                      animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                      child:   Padding(
                        padding: EdgeInsets.only(bottom: 60.w),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                                onTap: (){

                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: const OnboardingView(),
                                          curve: Curves.easeOut,
                                          duration: const Duration(milliseconds: 600)

                                      ));


                                },
                                child: SvgPicture.asset("assets/images/splash/BUTTON.svg"))),
                      ),// Not required

                    ),



                  ],
                ),
              )





            ],
          ),

        )

    );
  }
}
