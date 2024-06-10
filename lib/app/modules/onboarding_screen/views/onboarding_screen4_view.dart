import 'package:flutter/material.dart';

import 'package:get/get.dart';

class OnboardingScreen4View extends GetView {
  const OnboardingScreen4View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OnboardingScreen4View'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OnboardingScreen4View is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
