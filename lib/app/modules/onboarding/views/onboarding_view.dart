import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:maryana/app/modules/auth/bindings/auth_binding.dart';
import 'package:maryana/app/modules/auth/views/login_view.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/routes/app_pages.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {

  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>OnboardingController());
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(

        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(

                  child: Stack(

                    children: [
                      PageView(
                        onPageChanged: (index) {
                          controller.changeIndexValue(index);
                        },
                        controller: controller.pageController,
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          firstOnBoardingScreen(deviceHeight , context ),
                          secondOnBoardingScreen(deviceHeight, context ),
                          thirdOnBoardingScreen(deviceHeight, context),



                        ],
                      ),
                      Obx(()=>
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height -100.h,
                                left:  MediaQuery.of(context).size.width -200.w
                            ),

                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _Indicator(
                                  positionIndex: 0,
                                  currentIndex: controller.currentIndex.value,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                _Indicator(
                                  positionIndex: 1,
                                  currentIndex: controller.currentIndex.value,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                _Indicator(
                                  positionIndex: 2,
                                  currentIndex: controller.currentIndex.value,
                                ),
                              ],
                            ),
                          ),
                      )

                    ],)
              ),

            ],
          ),
        )
    );
  }

  firstOnBoardingScreen(deviceHeight , context) {
    return  Stack(

      children: [
        SizedBox(
            width : double.infinity,
            height: double.infinity,
            child: Image.asset("assets/images/onboarding/Bg.png" , fit: BoxFit.fill,)),
        Padding(
          padding: EdgeInsets.only(left: 25.w , top: MediaQuery.of(context).size.height *0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("CLASSY " ,

                style:
                boldTextStyle(
                    color: Colors.white,
                    size: 50.sp.round(),
                    weight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4

                )

              ),
              Text("FROM HEAD" ,

                style:  boldTextStyle(
                  color: Colors.white,
                  size: 50.sp.round(),
                  weight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4

                )),
              Text("TO TOE" ,

                style:boldTextStyle(
                    color: Colors.white,
                    size: 50.sp.round(),
                    weight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4

                )),

              InkWell(
                  onTap: (){

                    controller.nextFunction();

                  },
                  child: SvgPicture.asset("assets/images/onboarding/BUTTON (1).svg"))


            ],
          ),
        ),
      ],
    );
  }

  secondOnBoardingScreen(deviceHeight , context) {
    return  Stack(

      children: [
        SizedBox(
            width : double.infinity,
            height: double.infinity,
            child: Image.asset("assets/images/onboarding/Bg (1).png" , fit: BoxFit.fill,)),
        Padding(
          padding: EdgeInsets.only(left: 25.w , top: MediaQuery.of(context).size.height *0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("FLY AWAY " ,

                style:
                boldTextStyle(
                    color: Colors.white,
                    size: 50.sp.round(),
                    weight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4

                )

              ),
              Text("WITH YOUR" ,

                style:

                boldTextStyle(
                    color: Colors.white,
                    size: 50.sp.round(),
                    weight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4

                )
              ),
              Text("STYLE" ,

                style:
                boldTextStyle(
                    color: Colors.white,
                    size: 50.sp.round(),
                    weight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4

                )

              ),

              InkWell(
                  onTap: (){
                    controller.nextFunction();
                  },
                  child: SvgPicture.asset("assets/images/onboarding/BUTTON (1).svg"))


            ],
          ),
        ),
      ],
    );
  }

  thirdOnBoardingScreen(deviceHeight , context) {
    return  Stack(

      children: [
        SizedBox(
            width : double.infinity,
            height: double.infinity,
            child: Image.asset("assets/images/onboarding/Bg (2).png" , fit: BoxFit.fill,)),
        Padding(
          padding: EdgeInsets.only(left: 25.w , top: MediaQuery.of(context).size.height *0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("CLOTHES " ,

                style:
                boldTextStyle(
                    color: Colors.white,
                    size: 50.sp.round(),
                    weight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4

                )
              ),
              Text("FOR A BIG" ,

                style:
                boldTextStyle(
                    color: Colors.white,
                    size: 50.sp.round(),
                    weight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4

                )

                ),
              Text("PLANET" ,

                style:
                boldTextStyle(
                    color: Colors.white,
                    size: 50.sp.round(),
                    weight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4

                )
               ),

              InkWell(
                  onTap: (){
          Get.to(()=> LoginView());
                  },
                  child: SvgPicture.asset("assets/images/onboarding/BUTTON (2).svg" ))


            ],
          ),
        ),
      ],
    );
  }
}
class _Indicator extends StatelessWidget {
  final int positionIndex, currentIndex;
  const _Indicator({required this.currentIndex, required this.positionIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: positionIndex == currentIndex ? 12 : 10,
      width: positionIndex == currentIndex ? 12 : 10,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: positionIndex == currentIndex
              ? const Color(0xffAA61FF)
              : Colors.white,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}
