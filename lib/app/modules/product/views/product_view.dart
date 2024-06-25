import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:nb_utils/nb_utils.dart'
    hide primaryTextStyle
    hide boldTextStyle
    hide secondaryTextStyle;

import '../../global/theme/app_theme.dart';
import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(child: Center(child: Text("Working")));
  }
}
