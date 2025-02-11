import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/auth/controllers/forgot_password_controller.dart';
import 'package:maryana/app/modules/global/config/helpers.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/main/views/main_view.dart';

import '../../../routes/app_pages.dart';
import '../../global/widget/widget.dart';
import '../../home/views/home_view.dart';

class CreateNewPasswordView extends GetView<ForgotPasswordController> {
  const CreateNewPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 50.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35.h,
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       right: MediaQuery.of(context).size.width / 1.3),
                //   child: InkWell(
                //     onTap: () {
                //       Get.back();
                //     },
                //     child: Container(
                //       height: 40.h,
                //       width: 40.w,
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius:
                //             BorderRadius.all(Radius.circular(30)),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.grey.withOpacity(0.4),
                //             spreadRadius: 5,
                //             blurRadius: 7,
                //             offset: Offset(
                //                 0, 3), // changes position of shadow
                //           ),
                //         ],
                //       ),
                //       child: SvgPicture.asset(
                //           "assets/images/forgot_password/Bac.svg"),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 60.h,
                // ),
                Text('Create new password',
                    style: boldTextStyle(
                      color: Colors.black,
                      size: 24.sp.round(),
                      weight: FontWeight.w400,
                      height: 0.08.h,
                    )),
                SizedBox(
                  height: 35.h,
                ),
                Text('Your new password must be different',
                    textAlign: TextAlign.center,
                    style: primaryTextStyle(
                      color: Colors.black,
                      size: 12.sp.round(),
                      weight: FontWeight.w400,
                      height: 0.12.h,
                    )),
                SizedBox(
                  height: 20.h,
                ),
                Text('from previously used password',
                    textAlign: TextAlign.center,
                    style: primaryTextStyle(
                      color: Colors.black,
                      size: 14.sp.round(),
                      weight: FontWeight.w400,
                      height: 0.12.h,
                    )),
                SizedBox(
                  height: 59.h,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 30.w),

                  child: TextField(
                    decoration: InputDecoration(

                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        label: Text("New Password" , style: secondaryTextStyle(color: Colors.grey , size: 12.sp.round()),)
                    ),

                    controller:
                    controller.newPasswordController,


                    onChanged: (String value) {
                      controller.validatePassword(
                          controller.newPasswordController.text,
                          controller.confirmPasswordController.text);
                      if (value.isNotEmpty) {
                        controller.changeConfirmPasswordTypingStatus();
                      } else {
                        controller.endConfirmPasswordTypingStatus();
                      }
                    },
                    obscureText: true,
                  ),

                  // Material(
                  //
                  //   elevation: 0.2,
                  //   color: Colors.white,
                  //   shadowColor: Colors.blue,
                  //   child: Container(
                  //
                  //     padding: EdgeInsets.all(8.0),
                  //     child: TextFormField(
                  //       obscureText: controller.isNewPasswordObsecure.value,
                  //
                  //       onTap: (){
                  //         controller.changeNewPasswordTypingStatus();
                  //       },
                  //       controller: controller.newPasswordController,
                  //       onChanged: (value){
                  //         if(value.isNotEmpty){
                  //           controller.changeNewPasswordTypingStatus();
                  //         }else{
                  //           controller.endNewPasswordTypingStatus();
                  //         }
                  //
                  //       },
                  //       style: GoogleFonts.lato(
                  //           color: Colors.black ,
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 12.sp
                  //
                  //       ),
                  //
                  //       autofocus: false,
                  //
                  //       decoration: InputDecoration(
                  //
                  //
                  //         enabledBorder: const UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.white),
                  //         ),
                  //         focusedBorder: const UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.white),
                  //         ),
                  //
                  //
                  //         hintText: 'New Password',
                  //         labelText: "New Password",
                  //         suffixIcon:  IconButton(
                  //           icon:   Icon(
                  //               controller.isNewPasswordObsecure.value ?
                  //               Icons.visibility
                  //                   :
                  //
                  //               Icons.visibility_off), color: Colors.grey,
                  //           onPressed: () {
                  //             controller.switchNewPasswordVisibility();
                  //
                  //           },),
                  //
                  //
                  //         labelStyle: GoogleFonts.lato(
                  //             color: const Color(0xFFA6AAC3),
                  //             fontSize: 13.sp
                  //         ),
                  //         floatingLabelBehavior:
                  //         controller.isNewPasswordTyping.value?
                  //         FloatingLabelBehavior.always
                  //             :
                  //         FloatingLabelBehavior.never
                  //         ,
                  //         fillColor: Colors.white,
                  //         hintStyle: GoogleFonts.lato(
                  //             color: Colors.black ,
                  //             fontWeight: FontWeight.w400,
                  //             fontSize: 12.sp
                  //
                  //         ),
                  //         filled: true,
                  //
                  //         contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  //
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 30.w),
                  child: TextField(

decoration: InputDecoration(

  enabledBorder: const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  ),
  focusedBorder: const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  ),
  label: Text("Confirm New Password" , style: secondaryTextStyle(color: Colors.grey , size: 12.sp.round()),)
),
                    controller:
                    controller.confirmPasswordController,

                    onChanged: (String value) {
                      controller.validatePassword(
                          controller.newPasswordController.text,
                          controller.confirmPasswordController.text);
                      if (value.isNotEmpty) {
                        controller.changeConfirmPasswordTypingStatus();
                      } else {
                        controller.endConfirmPasswordTypingStatus();
                      }
                    },
                    obscureText: true,
                  ),
                  // Material(
                  //
                  //
                  //   elevation: 0.2,
                  //   color: Colors.white,
                  //   shadowColor: Colors.blue,
                  //   child: Container(
                  //
                  //     padding: EdgeInsets.all(8.0),
                  //     child: TextFormField(
                  //       obscureText: controller.isConfirmPasswordObsecure.value,
                  //       controller: controller.confirmPasswordController,
                  //       onTap: (){
                  //         controller.changeConfirmPasswordTypingStatus();
                  //       },
                  //       style: GoogleFonts.lato(
                  //           color: Colors.black ,
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 12.sp
                  //
                  //       ),
                  //       onFieldSubmitted: (input){
                  //
                  //       }  ,
                  //
                  //       autofocus: false,
                  //       onChanged: (value){
                  //         controller.validatePassword(
                  //             controller.newPasswordController.text,
                  //             controller.confirmPasswordController.text);
                  //         if(value.isNotEmpty){
                  //           controller.changeConfirmPasswordTypingStatus();
                  //         }else{
                  //           controller.endConfirmPasswordTypingStatus();
                  //         }

                  //       },
                  //       decoration: InputDecoration(
                  //
                  //         enabledBorder: const UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.white),
                  //         ),
                  //         focusedBorder: const UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.white),
                  //         ),
                  //         suffixIcon:  IconButton(
                  //           icon:   Icon(
                  //               controller.isConfirmPasswordObsecure.value ?
                  //               Icons.visibility
                  //                   :
                  //
                  //               Icons.visibility_off), color: Colors.grey,
                  //           onPressed: () {
                  //             controller.switcConfirmPasswordVisibility();
                  //           },),
                  //         hintText: 'Confirm Password',
                  //         labelText: "Confirm Password",
                  //         labelStyle: GoogleFonts.lato(
                  //             color: const Color(0xFFA6AAC3),
                  //             fontSize: 13.sp
                  //         ),
                  //         floatingLabelBehavior:
                  //         controller.isConfirmPasswordTyping.value?
                  //         FloatingLabelBehavior.always
                  //             :
                  //         FloatingLabelBehavior.never
                  //         ,
                  //         fillColor: Colors.white,
                  //         hintStyle: GoogleFonts.lato(
                  //             color: Colors.black ,
                  //             fontWeight: FontWeight.w400,
                  //             fontSize: 12.sp
                  //
                  //         ),
                  //         filled: true,
                  //
                  //         contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  //
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
                SizedBox(
                  height: 100.h,
                ),
                Obx(() => Padding(
                  padding: EdgeInsets.only(right: 30.w),
                  child: InkWell(
                    onTap: () {
                      controller.changePassword().then((value) {
                        if (value.toString() == "OK") {
                          controller.changeReset();
                          print('teasdsadsadsa');
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (ctx) {
                                return Container(
                                  height: 300.h,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      // or some other color
                                      borderRadius: BorderRadius.only(
                                          topLeft:
                                          Radius.circular(40.0),
                                          topRight:
                                          Radius.circular(40.0))),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/forgot_password/Oval.png",
                                            width: 120.w,
                                            height: 120.h,
                                            color: Color(0xffFAFAFA),
                                          ),
                                          Image.asset(
                                            "assets/images/forgot_password/wired-gradient-1676-telephone-call-hand 1.png",
                                            width: 100.w,
                                            height: 100.h,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                          'Your password has been changed',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              fontWeight:
                                              FontWeight.w400,
                                              fontSize: 15.sp,
                                              color: Colors.black)),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                          'Welcome back! Discover now!',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                            color: Colors.grey,
                                          )),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Get.offAll(() => MainView());
                                          Get.offNamedUntil(Routes.MAIN,
                                                  (Route) => false);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/images/forgot_password/BUTTON (5).svg",
                                          width: MediaQuery.of(context)
                                              .size
                                              .width -
                                              80.w,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        } else {
                          Get.snackbar('Error',
                              'Something went Wrong please try again!');
                          // AppHelpers.showCustomSnackBar(
                          //     context,
                          //     'Error !',
                          //     'Something went Wrong please try again!');
                        }
                      });
                    },
                    child: SvgPicture.asset(
                      controller.isValid.value
                          ? "assets/images/forgot_password/BUTTON (4).svg"
                          : "assets/images/forgot_password/BUTTON (3).svg",
                      width: MediaQuery.of(context).size.width - 44.w,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )),
              ],
            ),
          ),
        )
    );
  }
}
