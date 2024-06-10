import 'package:flutter/material.dart';

import 'package:get/get.dart';

class OnboardingScreen3View extends GetView {
  const OnboardingScreen3View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OnboardingScreen3View'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OnboardingScreen3View is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
