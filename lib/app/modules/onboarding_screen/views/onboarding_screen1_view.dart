import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/onboarding_screen/views/onboarding_screen2_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:svg_flutter/svg.dart';

import '../controllers/onboarding_screen_controller.dart';

class OnboardingScreen1View extends GetView<OnboardingScreenController> {
  const OnboardingScreen1View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(height: 30.h,),

Center(child: Image.asset("assets/logo-D4X8uOTiU-transformed-removebg-preview.png" , width: 90.w, height: 60, fit: BoxFit.scaleDown,)),
            SizedBox(height: 20.h,),
             Center(
              child:
              Column(
                children: [
                  Text("Dress the " , style: TextStyle(
                      fontFamily: "Cormorant",
                      fontSize: 37.sp,
                      fontWeight: FontWeight.w600,
                    color: Color(0xff33302E)
                  )),
                  Text("LUXURY" , style: TextStyle(
                      fontFamily: "Cormorant",
                      fontSize: 37.sp,
                      fontWeight: FontWeight.w600,
                    color: Color(0xff370269)
                  )),


                ],
              ),

            ),

           Expanded(
             child: Stack(
               fit: StackFit.expand,
               children: [
                 SvgPicture.asset("assets/Frame 33364.svg"),
                 Image.asset(
                   "assets/firstGirl.png",
                   fit: BoxFit.cover,
                   height:MediaQuery.of(context).size.height,
                   width: MediaQuery.of(context).size.width,
                 ),
                 SvgPicture.asset("assets/Frame 33363.svg"),
                 Padding(
                   padding: EdgeInsets.only(bottom: 60.w),
                   child: Align(
                     alignment: Alignment.bottomCenter,
                       child: InkWell(
                         onTap: (){
                           Navigator.push(
                               context,
                               PageTransition(
                                   type: PageTransitionType.fade,
                                   child: OnboardingScreen2View(),
                                 curve: Curves.easeOut,
                                 duration: Duration(milliseconds: 600)

                               ));


                         },
                           child: SvgPicture.asset("assets/BUTTON.svg"))),
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
