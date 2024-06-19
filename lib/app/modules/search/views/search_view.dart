import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:maryana/app/modules/global/theme/app_theme.dart';
import 'package:maryana/app/modules/search/views/result_view.dart';
import 'package:pinput/pinput.dart';

import '../../global/model/model_response.dart';
import '../../home/views/home_view.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {

   SearchView({Key? key} ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Text("Working")
      )
    );
  }

}
