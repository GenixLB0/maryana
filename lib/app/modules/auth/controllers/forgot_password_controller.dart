import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:maryana/app/modules/auth/views/create_new_password_view.dart';

class ForgotPasswordController extends GetxController {


  final count = 0.obs;
  RxBool isResetDone = false.obs;


  RxBool isConfirmPasswordTyping = false.obs;
  RxBool isNewPasswordTyping = false.obs;
  RxBool isValid = false.obs;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool isNewPasswordObsecure = true.obs;
  RxBool isConfirmPasswordObsecure = true.obs;

  RxBool isEnded = false.obs;
  RxInt timer = 20.obs;
  RxInt tweenId = 0.obs;
  int randomId = 0;

  RxBool isLoading = false.obs;

  String myEmail = "";

    String emptyEmailError = 'Email cannot be empty';

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;


  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp =  RegExp(p);


    return regExp.hasMatch(em);

  }

  Future<dynamic> sendOTP(email , isFirstPhase) async {
    if(isFirstPhase){
      myEmail = email;
    }else {
      null;
    }

    print(myEmail);
    isLoading.value = true;
    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'x-guest': '****',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', Uri.parse('https://mariana.genixarea.pro/api/password/forget'));
    request.bodyFields = {
      'email': '${myEmail}'
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      isLoading.value = false;
      if (kDebugMode) {
        print("${response.statusCode}");
      }
      return  response.reasonPhrase;
    }
    else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
      isLoading.value = false;
      if (kDebugMode) {
        print("${response.statusCode}");
      }
      return response.reasonPhrase;
    }

  }




  endTimer(){
    isEnded.value = true;
  }

  startTimer() async{
    randomTheId();
    tweenId.value = randomId;
    isEnded.value = false;

    await sendOTP(myEmail , false);

  }

  randomTheId(){
    randomId = Random().nextInt(999999);
  }

  validateOTP(otp){
    if(otp == "1111"){
      Get.to(()=> const CreateNewPasswordView());
    }
  }


  changeConfirmPasswordTypingStatus(){
    isConfirmPasswordTyping.value = true;
  }
  endConfirmPasswordTypingStatus(){
    isConfirmPasswordTyping.value = false;
  }

  changeNewPasswordTypingStatus(){
    isNewPasswordTyping.value = true;
  }
  endNewPasswordTypingStatus(){
    isNewPasswordTyping.value = false;
  }


  validatePassword(newpasssword , confirmpassword){
    if(newpasssword == confirmpassword){
      isValid.value = true;
    } else{
      isValid.value = false;

    }
  }


  Future<dynamic> changePassword()async{
    if(isValid.value){
      print(newPasswordController.text);
      print(confirmPasswordController.text);
      var headers = {
        'Accept': 'application/json',
        'x-from': 'app',
        'x-lang': 'en',
        'x-guest': '****',
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request = http.Request('POST', Uri.parse('https://mariana.genixarea.pro/api/password/reset'));
      request.bodyFields = {
        'token': '1111',
        'password': newPasswordController.text,
        'password_confirmation': confirmPasswordController.text,
      };
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        return response.reasonPhrase;
      }
      else {
        print(response.reasonPhrase);
        return response.reasonPhrase;
      }
    }


  }
  changeReset(){
    isResetDone.value = true;
  }


  switchNewPasswordVisibility(){
    isNewPasswordObsecure.value =! isNewPasswordObsecure.value;
  }

  switcConfirmPasswordVisibility(){
    isConfirmPasswordObsecure.value  =! isConfirmPasswordObsecure.value ;
  }

}
