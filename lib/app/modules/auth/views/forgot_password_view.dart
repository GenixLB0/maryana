
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';


import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/auth/views/verification_code_view.dart';
import 'package:maryana/app/modules/global/config/helpers.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:nb_utils/nb_utils.dart' hide boldTextStyle;


import '../../global/widget/widget.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
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
                'Forgot password?',
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
                  'Enter email associated with your account and  we’ll',

                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 0.12.h,

                  )


              ),
            ),
            SizedBox(height: 20.h,),
            SizedBox(
              width: 308.w,

              child: Text(
                  ' send and email with intructions to reset your ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 0.12.h,
                  )


              ),
            ),
            SizedBox(height: 20.h,),
            SizedBox(
              width: 308.w,

              child: Text(
                  'password',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 0.12.h,
                  )


              ),
            ),


            SizedBox(height: 100.h,),
            CustomTextField(
              labelText: 'enter your email here',
              onChanged: (String value) {  },
              icon: 'assets/icons/email 1.svg',

              onSubmitted: (input){
                if( controller.isEmail(input) ) {
                  controller.sendOTP(input , true).then((value){
                    if(value.toString() == "OK"){
                      Get.to(()=> const VerificationCodeView());
                    } else {
                      AppHelpers.showCustomSnackBar(context, 'Email Not Found!',  'Please Check your Email and try again!');

                    }




                  });

                } else{
                  AppHelpers.showCustomSnackBar(context,
                    'Invalid Email',
                    'Please Check your Email Expression!',
                  );


                }

              },
            ),
            SizedBox(height: 100.h,),
            Obx(()=>
            controller.isLoading.value ?

            loadingIndicatorWidget()
                :
            SizedBox()
            )


          ],
        ),
      )




    );
  }

  // customTextField(context) {
  //   return  Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 20.w),
  //     child:
  //
  //
  //     // Material(
  //     //
  //     //   elevation: 0.5,
  //     //   color: Colors.white,
  //     //   shadowColor: Colors.blue,
  //     //   child: Container(
  //     //     padding: EdgeInsets.all(8.0),
  //     //     child:
  //     //
  //     //     TextFormField(
  //     //       style: GoogleFonts.lato(
  //     //           color: Colors.black ,
  //     //           fontWeight: FontWeight.w400,
  //     //           fontSize: 12.sp
  //     //
  //     //       ),
  //     //       onFieldSubmitted: (input){
  //     //         if( controller.isEmail(input) ) {
  //     //           controller.sendOTP(input , true).then((value){
  //     //             if(value.toString() == "OK"){
  //     //               Get.to(()=> const VerificationCodeView());
  //     //             } else {
  //     //               AppHelpers.showCustomSnackBar(context, 'Email Not Found!',  'Please Check your Email and try again!');
  //     //
  //     //             }
  //     //
  //     //
  //     //
  //     //
  //     //           });
  //     //
  //     //         } else{
  //     //           AppHelpers.showCustomSnackBar(context,
  //     //             'Invalid Email',
  //     //             'Please Check your Email Expression!',
  //     //           );
  //     //
  //     //
  //     //         }
  //     //       }  ,
  //     //
  //     //       autofocus: false,
  //     //
  //     //       decoration: InputDecoration(
  //     //         enabledBorder: const UnderlineInputBorder(
  //     //           borderSide: BorderSide(color: Colors.white),
  //     //         ),
  //     //         focusedBorder: const UnderlineInputBorder(
  //     //           borderSide: BorderSide(color: Colors.white),
  //     //         ),
  //     //         icon:  const Icon(Icons.email_outlined, color: Colors.grey),
  //     //         hintText: 'enter your email here ',
  //     //         fillColor: Colors.white,
  //     //         hintStyle: GoogleFonts.lato(
  //     //             color: Colors.black ,
  //     //             fontWeight: FontWeight.w400,
  //     //             fontSize: 12.sp
  //     //
  //     //         ),
  //     //         filled: true,
  //     //
  //     //         contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  //     //
  //     //       ),
  //     //     ),
  //     //   ),
  //     // ),
  //   );
  //
  // }
}
