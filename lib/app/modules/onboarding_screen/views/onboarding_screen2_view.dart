import 'package:flutter/material.dart';

import 'package:get/get.dart';

class OnboardingScreen2View extends GetView {
  const OnboardingScreen2View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OnboardingScreen2View'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OnboardingScreen2View is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
