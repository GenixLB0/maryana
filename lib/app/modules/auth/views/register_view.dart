import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/auth/views/login_view.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
 import '../controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  Widget registerForm(BuildContext context) {
    return Column(
      children: [
        ShowUp(
          delay: 200,
          child: SizedBox(
            width: 326.w,
            child: Text(
              'Create a new account',
              textAlign: TextAlign.center,
              style: boldTextStyle(
                color: const Color(0xFF090A0A),
                size: 28.sp.round(),
                weight: FontWeight.w400,
              ),
            ),
          ),
        ),
        SizedBox(height: 41.h),
        SizedBox(
            width: 310.w,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 2,
                      child: ShowUp(
                        delay: 400,
                        child: CustomTextField(
                          labelText: 'First Name',
                          onChanged: (value) =>
                              controller.firstName.value = value,
                          errorText: controller.firstNameError.value.isEmpty
                              ? null
                              : controller.firstNameError.value,
                        ),
                      )),
                  SizedBox(width: 20.w),
                  Flexible(
                      flex: 2,
                      child: ShowUp(
                        delay: 400,
                        child: CustomTextField(
                          labelText: 'Last Name',
                          onChanged: (value) =>
                              controller.lastName.value = value,
                          errorText: controller.lastNameError.value.isEmpty
                              ? null
                              : controller.lastNameError.value,
                        ),
                      ))
                ])),
        SizedBox(height: 20.h),
        ShowUp(
          delay: 600,
          child: CustomTextField(
            labelText: 'Email Address',
            onChanged: (value) => controller.email.value = value,
            errorText: controller.emailError.value.isEmpty
                ? null
                : controller.emailError.value,
          ),
        ),
        SizedBox(height: 20.h),
        ShowUp(
          delay: 600,
          child: CustomTextField(
            labelText: 'Password',
            onChanged: (value) => controller.password.value = value,
            errorText: controller.passwordError.value.isEmpty
                ? null
                : controller.passwordError.value,
            obscureText: true,
          ),
        ),
        SizedBox(height: 20.h),
        ShowUp(
          delay: 600,
          child: CustomTextField(
            labelText: 'Confirm Password',
            onChanged: (value) => controller.confirmPassword.value = value,
            errorText: controller.confirmPasswordError.value.isEmpty
                ? null
                : controller.confirmPasswordError.value,
            obscureText: true,
          ),
        ),
        SizedBox(height: 28.h),
        ShowUp(
          delay: 800,
          child: MyDefaultButton(
            isloading: controller.isLoading.value,
            btnText: 'SIGN UP',
            onPressed: () => controller.register(),
          ),
        ),
        SizedBox(height: 35.h),
        Opacity(
            opacity: 0.60,
            child: Text(
              'or log in with',
              textAlign: TextAlign.center,
              style: primaryTextStyle(
                color: Colors.black,
                size: 12.sp.round(),
                weight: FontWeight.w400,
                letterSpacing: 0.24,
              ),
            )),
        SizedBox(height: 23.h),
        gridSocialIcon(),
        SizedBox(height: 40.h),
        ShowUp(
          delay: 500,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Already have an account?',
                  style: primaryTextStyle(
                    color: Colors.black,
                    size: 14.sp.round(),
                    weight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: '   ',
                  style: primaryTextStyle(
                    color: const Color(0xFF979C9E),
                    size: 12.sp.round(),
                    weight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Log In',
                  style: primaryTextStyle(
                    color: const Color(0xFFAA61FF),
                    size: 14.sp.round(),
                    weight: FontWeight.w400,
                    height: 2,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      controller.clearFields();
                      Get.to(() => LoginView());
                    },
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: CustomAppBar(),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShowUp(
                  delay: 200,
                  child: SvgPicture.asset(
                    LOGO,
                    width: 124.w,
                    height: 82.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 13.h),
                registerForm(context),
              ],
            ),
          ),
        ),
      );
    });
  }
}
