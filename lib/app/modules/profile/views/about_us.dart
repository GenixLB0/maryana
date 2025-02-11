import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/profile/controllers/profile_controller.dart';

class AboutUs extends StatelessWidget {
  AboutUs({super.key});

  ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'About Us'),
      body: Obx(() {


        return
          controller.isLoading.value?
          Center(child: CircularProgressIndicator(),)
          :

          SafeArea(
            child:


            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(

                children: [
              SizedBox(height: 20.h,),
                  Text(controller.aboutUs.value, style: primaryTextStyle(
                      color: Colors.black,
                    wordSpacing: 5.w,

                  ),)


                ],
              ),
            ));
      }),
    );
  }
}
