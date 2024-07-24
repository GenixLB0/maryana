import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/auth/views/register_view.dart';
import 'package:maryana/app/modules/global/config/configs.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/main/views/main_view.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../routes/app_pages.dart';
import 'forgot_password_view.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  Widget loginbyPasswordView(context) {
    return Column(
      children: [
        ShowUp(
            delay: 200,
            child: SizedBox(
                width: 326.w,
                child: Text(
                  'login with your account',
                  textAlign: TextAlign.center,
                  style: boldTextStyle(
                      color: const Color(0xFF090A0A),
                      size: 28.sp.round(),
                      weight: FontWeight.w400),
                ))),
        SizedBox(
          height: 41.h,
        ),
        ShowUp(
            delay: 400,
            child: CustomTextField(
              labelText: 'Email address',
              onChanged: (value) => controller.email.value = value,
              errorText: controller.emailError.value.isEmpty
                  ? null
                  : controller.emailError.value,
            )),
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
            )),
        SizedBox(height: 28.h),
        SizedBox(
            width: 310.w,
            child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.FORGOT_PASSWORD);
                },
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Text(
                    'Forgot Password?',
                    textAlign: TextAlign.center,
                    style: primaryTextStyle(
                      color: Colors.black,
                      size: 12.sp.round(),
                      weight: FontWeight.w400,
                    ),
                  ),
                ))),
        SizedBox(height: 25.h),
        ShowUp(
            delay: 800,
            child: MyDefaultButton(
              isloading: controller.isLoading.value,
              btnText: 'LOGIN',
              onPressed: () => controller.login(),
            )),
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
        SizedBox(height: 109.h),
        ShowUp(
            delay: 500,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Don’t have an account?',
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
                    text: 'Sign Up',
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

                        Get.to(() => RegisterView());
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            )),
      ],
    );
  }

  Widget socialMediaView() {
    return Column(
      children: [
        ShowUp(
            delay: 400,
            child: Text(
              'Welcome to Marianella',
              textAlign: TextAlign.center,
              style: boldTextStyle(
                  color: const Color(0xFF090A0A),
                  size: 32.sp.round(),
                  weight: FontWeight.w400),
            )),
        Text(
          'Please log in or sign up to continue shopping',
          textAlign: TextAlign.center,
          style: secondaryTextStyle(
            color: const Color(0xFFCDCFD0),
            size: 16.sp.round(),
            weight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 32.h,
        ),
        buttonSocialMedia(
            icon: 'assets/icons/google.svg',
            index: 0,
            text: 'Continue with Google',
            color: 0xffFFFFFF,
            txtColor: 0xFF090A0A,
            borderColor: 0xFFE3E4E5),
        SizedBox(
          height: 16.h,
        ),
        buttonSocialMedia(
            icon: 'assets/icons/facebook.svg',
            index: 1,
            text: 'Continue with Facebook',
            color: 0xFF0066DA,
            txtColor: 0xffFFFFFF,
            borderColor: 0xFF0066DA),
        SizedBox(
          height: 16.h,
        ),
        buttonSocialMedia(
            icon: 'assets/icons/apple.svg',
            index: 2,
            text: 'Continue with Apple',
            color: 0xFF090A0A,
            txtColor: 0xffFFFFFF,
            borderColor: 0xFFE3E4E5),
        SizedBox(
          height: 35.h,
        ),
        DividerSocial(),
        SizedBox(
          height: 34.h,
        ),
        InkWell(
            onTap: () {
              controller.socialView.value = false;
              controller.password.value = '';
              controller.email.value = '';
            },
            child: buttonSocialMedia(
                icon: 'assets/icons/login.svg',
                index: 3,
                text: 'Sign in with password',
                color: 0xFFD4B0FF,
                txtColor: 0xFF21034F,
                borderColor: 0xFFD4B0FF)),
        SizedBox(
          height: 34.h,
        ),
        InkWell(
            onTap: () {
              Get.snackbar('Guest Mode', 'You\'re Acting As A Guest');
              Get.to(MainView());
            },
            child: buttonSocialMedia(
                icon: 'assets/images/onboarding/person.svg',
                index: 3,
                text: 'Sign in As a Guest',
                color: 0xFFD4B0FF,
                txtColor: 0xFF21034F,
                borderColor: 0xFFD4B0FF)),
        SizedBox(
          height: 26.h,
        ),
        ShowUp(
            delay: 500,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Don’t have an account?',
                    style: primaryTextStyle(
                      color: const Color(0xFFCDCFD0),
                      size: 16.sp.round(),
                      weight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: primaryTextStyle(
                      color: const Color(0xFF979C9E),
                      size: 16.sp.round(),
                      weight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Sign up',
                    style: primaryTextStyle(
                      color: const Color(0xFFAA61FF),
                      size: 16.sp.round(),
                      weight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.clearFields();
                        Get.to(() => RegisterView());
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            )),
      ],
    );
  }

  void back() {
    controller.socialView.value = true;

    controller.password.value = '';
    controller.email.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          appBar: CustomAppBar(
            function: controller.socialView.value == true ? null : back,
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: controller.socialView.value ? 60.h : 0,
                ),
                ShowUp(
                    delay: 200,
                    child: SvgPicture.asset(
                      LOGO,
                      width: 124.w,
                      height: 82.h,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  height: 13.h,
                ),
                if (controller.socialView.value)
                  socialMediaView()
                else
                  loginbyPasswordView(context),
              ],
            )),
          ));
    });
  }
}
