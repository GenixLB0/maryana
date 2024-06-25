import 'dart:convert';

import 'package:get/get.dart';
import 'package:maryana/app/modules/global/model/model_response.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../global/model/test_model_response.dart';
import '../../services/api_consumer.dart';
import '../../services/api_service.dart';

class ShopController extends GetxController {
RxList<Categories> categories = <Categories>[].obs;
RxBool isCategoryLoading = false.obs;
RxBool isProductLoading = false.obs;
RxList<Product> products = <Product>[].obs;
ApiConsumer apiConsumer = sl();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getCategories();
    getProducts();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

   getCategories() async{
     print("searching 1");

     categories.clear();
     print('search api successful');
     isCategoryLoading.value = true;


     final response = await apiConsumer.post(
       'categories',
       formDataIsEnabled: true,

     );



     try {
       final apiResponse = ApiCategoryResponse.fromJson(response);
       if (apiResponse.status == 'success') {
         print('search data successful');

         for (var category in apiResponse.data!) {
           categories.add(category);
         }
         ;
       } else {
         handleApiErrorUser(apiResponse.message);
         handleApiError(response.statusCode);

       }
       isCategoryLoading.value = false;
       update();
     } catch (e, stackTrace) {

       print('search api failed:  ${e} $stackTrace');

       print(e.toString() + stackTrace.toString());
       isCategoryLoading.value = false;
       update();
     }
  }

  getProducts()async{
    isProductLoading.value = true;
    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'

    };

    var bodyFields = {};

    final response = await http.post(Uri.parse('https://mariana.genixarea.pro/api/products'),
      headers:headers,
      body: bodyFields , );
    try{

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        for(var product in responseData['data']){
          products.add(Product.fromJson(product));
        }


        isProductLoading.value = false;
      }
      else {
        print(response.reasonPhrase);
        isProductLoading.value = false;
      }

      print("produc are ${products}");
    }catch(e, stackTrace){
      isProductLoading.value = false;
      print('filter failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }


  }
}
