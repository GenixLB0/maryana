import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

import '../controllers/onboarding_screen_controller.dart';

class OnboardingScreen2View extends GetView<OnboardingScreenController> {
  const OnboardingScreen2View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {


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
                      SizedBox(
                        width: 10,
                      ),
                      _Indicator(
                        positionIndex: 1,
                        currentIndex: controller.currentIndex.value,
                      ),
                      SizedBox(
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
        Container(
            width : double.infinity,
            height: double.infinity,
            child: Image.asset("assets/Bg.png" , fit: BoxFit.fill,)),
        Padding(
          padding: EdgeInsets.only(left: 25.w , top: MediaQuery.of(context).size.height *0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("CLASSY " ,

                style: GoogleFonts.bebasNeue(
                    fontSize: 50.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4
                ),),
              Text("FROM HEAD" ,

                style: GoogleFonts.bebasNeue(
                    fontSize: 50.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4
                ),),
              Text("TO TOE" ,

                style: GoogleFonts.bebasNeue(
                    fontSize: 50.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4
                ),),

              InkWell(
                  onTap: (){

              controller.nextFunction();

                  },
                  child: SvgPicture.asset("assets/BUTTON (1).svg"))


            ],
          ),
        ),
      ],
    );
  }

  secondOnBoardingScreen(deviceHeight , context) {
    return  Stack(

      children: [
        Container(
            width : double.infinity,
            height: double.infinity,
            child: Image.asset("assets/Bg (1).png" , fit: BoxFit.fill,)),
        Padding(
          padding: EdgeInsets.only(left: 25.w , top: MediaQuery.of(context).size.height *0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("FLY AWAY " ,

                style: GoogleFonts.bebasNeue(
                    fontSize: 50.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4
                ),),
              Text("WITH YOUR" ,

                style: GoogleFonts.bebasNeue(
                    fontSize: 50.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4
                ),),
              Text("STYLE" ,

                style: GoogleFonts.bebasNeue(
                    fontSize: 50.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4
                ),),

              InkWell(
                onTap: (){
                  controller.nextFunction();
                },
                  child: SvgPicture.asset("assets/BUTTON (1).svg"))


            ],
          ),
        ),
      ],
    );
  }

  thirdOnBoardingScreen(deviceHeight , context) {
    return  Stack(

      children: [
        Container(
            width : double.infinity,
            height: double.infinity,
            child: Image.asset("assets/Bg (2).png" , fit: BoxFit.fill,)),
        Padding(
          padding: EdgeInsets.only(left: 25.w , top: MediaQuery.of(context).size.height *0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("CLOTHES " ,

                style: GoogleFonts.bebasNeue(
                    fontSize: 50.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4
                ),),
              Text("FOR A BIG" ,

                style: GoogleFonts.bebasNeue(
                    fontSize: 50.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4
                ),),
              Text("PLANET" ,

                style: GoogleFonts.bebasNeue(
                    fontSize: 50.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                    wordSpacing: 0.4
                ),),

              InkWell(
                onTap: (){
                //
                },
                  child: SvgPicture.asset("assets/BUTTON (2).svg" ))


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
              ? Color(0xffAA61FF)
              : Colors.white,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}
