import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/onboarding_screen_controller.dart';

class OnboardingScreen1View extends GetView<OnboardingScreenController> {
  const OnboardingScreen1View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OnboardingScreen1View'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OnboardingScreenView1 is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
