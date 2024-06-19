import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:nb_utils/nb_utils.dart' hide primaryTextStyle;
import '../controllers/search_controller.dart';
import '../../global/theme/app_theme.dart';

class ResultView extends GetView<SearchController> {
  const ResultView({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Text("working")
        )
    );
  }


}
