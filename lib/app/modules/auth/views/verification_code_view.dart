import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/auth/controllers/forgot_password_controller.dart';
import 'package:pinput/pinput.dart';

import '../../global/theme/app_theme.dart';


class VerificationCodeView extends GetView<ForgotPasswordController> {
  const VerificationCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 60.h,

      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffA5A7AC)),
        borderRadius: BorderRadius.circular(50),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.black54),
      borderRadius: BorderRadius.circular(50),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,

        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: 35.h,),
              Padding(
                padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width/1.3),

                child: InkWell(
                  onTap: (){
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
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SvgPicture.asset("assets/images/forgot_password/Frame 361.svg"),
                  ),
                ),
              ),
              SizedBox(height: 45.h,),
              Center(child:
              Text(
                  'Verification code',
                  style:
                  boldTextStyle(
                    color: Colors.black,
                    size: 24.sp.round(),
                    weight: FontWeight.w400,
                    height: 0.08.h,
                  )



              )),
              SizedBox(height: 35.h,),
              SizedBox(
                width: 350.w,

                child: Text(
                    'Please enter the verification code we sent to your ',

                    textAlign: TextAlign.center,
                    style:
                        primaryTextStyle(
                          color: Colors.black,
                          size: 12.sp.round(),
                          weight: FontWeight.w400,
                          height: 0.12.h,
                        )




                ),
              ),
              SizedBox(height: 20.h,),
              SizedBox(
                width: 308.w,

                child: Text(
                    'email address',
                    textAlign: TextAlign.center,
                    style:
                    primaryTextStyle(
                      color: Colors.black,
                      size: 12.sp.round(),
                      weight: FontWeight.w400,
                      height: 0.12.h,
                    )



                ),
              ),
              SizedBox(height: 20.h,),



              SizedBox(height: 100.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Pinput(
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  validator: (s) {
                    controller.validateOTP(s);
                    return s == '1111' ? null : 'Pin is incorrect';

                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin) => print(pin),
                )
              ),
              SizedBox(height: 20.h,),
Align(
  alignment: Alignment.centerLeft,
  child:  Padding(
    padding:  EdgeInsets.only(left: 30.w),
    child: Obx(()=>
        Column(
          children: [
            TweenAnimationBuilder<Duration>(
                key: ValueKey(controller.tweenId.value),

                duration: Duration(seconds: 10),
                tween: Tween(begin: Duration(seconds: 10), end: Duration.zero),
                onEnd: () {
                  controller.endTimer();
                  print('Timer ended');
                },
                builder: (BuildContext context, Duration value, Widget? child) {
                  final minutes = value.inMinutes;
                  final seconds = value.inSeconds % 60;
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child:
                      controller.isEnded.value?
                      InkWell(
                        onTap: (){
                          controller.startTimer();
                        },
                        child: Text('Resend',
                            textAlign: TextAlign.center,

                            style:
                            TextStyle(
                                decoration: TextDecoration.underline,
                                color: const Color(0x7F121420),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp)),
                      )
                      :
               controller.isLoading.value ?
               Align(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: EdgeInsets.only(left: 2.w),
                   child:SizedBox(
                     width: 50.w,
                       height: 50.h,

                       child: SpinKitThreeInOut(size: 12.sp, color: Color(0x7F121420),))
                 ),

               )
                   :
               Text('Resend in $minutes:$seconds',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color(0x7F121420),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp)));
                }),

          ],
        ),)
  ),
),

              SizedBox(height: 100.h,),



            ],
          ),
        )




    );
  }
}
