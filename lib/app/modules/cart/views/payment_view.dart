import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maryana/app/modules/cart/views/order_result_view.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

import '../../global/theme/app_theme.dart';
import '../controllers/cart_controller.dart';

class PaymentView extends GetView<CartController> {

  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.find<CartController>();

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(

          onProgress: (int progress) {
            // Update loading bar.
            if (progress == 100) {
              print("Page finished loading");
              cartController.isWebPaymentLoading.value = false;

            } else {
              cartController.isWebPaymentLoading.value = true;
            }
          },

          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            print('Page finished loading: ${cartController.sessionId.value}');
            if (url.contains('receipt')) {
              print("caught here in page finished");
            }
          },
          onHttpError: (HttpResponseError error) {
            print('Page Error Happen : ${error.response}');
          },
          onUrlChange: (url) {
            print("caught here in inavigation change ${url.url.toString()} ");
            if (url.url.toString().contains('checkoutVersion')) {
              // Get.off(OrderResultView());
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('Page Error Happen but sourced : ${error.description}');
          },

          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('receipt')) {
              print("caught here in inavigation request ");
              return NavigationDecision.navigate;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
            'https://epayment.areeba.com/checkout/embedded/${cartController
                .sessionId.value}?checkoutVersion=1.0.0 '
        ),
      ).catchError((error) {
        print('Page Error Happen but caughted : ${error}');
      });


    return Scaffold(

      appBar:


      AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              'Order Payment', style: primaryTextStyle(size: 20.sp.round()),),
            const Spacer(),
            GestureDetector(
                onTap: () {
                  cartController.getOrderResult();
                  Get.off(() => const OrderResultView());
                },
                child: Icon(Icons.home, color: primaryColor)),
          ],
        ),
        centerTitle: true,
      ),
      body:
      Obx(() {
        return Stack(
          alignment: Alignment.center,
          children: [
            WillPopScope(
                onWillPop: () async {
                  cartController.getOrderResult();
                  Get.off(() => OrderResultView());
                  return true;
                },
                child: WebViewWidget(controller: controller)
            ),
            cartController.isWebPaymentLoading.value?
            loadingIndicatorWidget() :
                SizedBox()
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     width: double.infinity,
            //     color: Colors.blue,
            //     child: TextButton(
            //       onPressed: () {
            //         // Handle button press
            //       },
            //       child: Text(
            //         'Continue Shopping',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),

          ],
        );
      }),


    );
  }


}
