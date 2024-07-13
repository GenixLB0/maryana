import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maryana/app/modules/global/theme/colors.dart';
import 'package:maryana/app/modules/global/widget/widget.dart';
import 'package:maryana/app/modules/search/controllers/search_controller.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../global/config/constant.dart';
import '../../global/model/model_response.dart';
import '../../global/model/test_model_response.dart' hide Brands;
import '../../services/api_consumer.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();

  ApiService apiService = Get.find();
  ApiConsumer apiConsumer = sl();
  Rx<TestData> homeModel = TestData().obs;
  late VideoPlayerController videoController;
  List<int> activeCats = [];
  RxBool isHomeLoading = false.obs;
  final wishlistProductIds = <int>[].obs;

////////////////collections//////////////////////////
  bool isCollectionLoading = false;
  List<Collections> collections = [];

  bool isCollectionProductsLoading = false;
  List<CollectionProducts> collectionProducts = <CollectionProducts>[];

  bool isProductAddedToCollection = false;
  bool isCollectionsReached = false;
  bool isCollectionDataGotten = false;

  /////////////////////////////////////////////////

  ////////////////brands//////////////////////////
  bool isBrandLoading = false;
  bool isBrandsDataGotten = false;
  List<Brands> brands = [];
  bool isBrandProductsLoading = false;
  List<BrandProducts> brandProducts = [];

  bool isProductAddedToBrand = false;
  bool isBrandsReached = false;

  bool isOtherBrandLoading = false;
  List<String> otherBrandsId = [];
  List<Brands> otherBrands = [];
  bool isOtherBrandReached = false;
  bool otherBrandsDataGotten = false;

  /////////////////////////////////////////////////

  ////////////////Coupons////////////////////////////////
  bool isCouponLoading = false;
  List<Coupons> coupons = [];
  bool isCouponsAdded = false;
  bool couponsDataGotten = false;
  bool isCouponReached = false;

  //////////////////////////////////////////////////////////

  ////////////////Styles////////////////////////////////
  bool isStylesLoading = false;
  List<Styles> styles = [];
  bool isStylesAdded = false;
  bool stylesDataGotten = false;
  bool isStyleReached = false;

  //////////////////////////////////////////////////////////

  /////////////GiftCard////////////////////////////

  bool isGiftCardLoading = false;
  List<GiftCards> giftCards = [];

  bool isGiftCardsAdded = false;
  bool isGiftCardsDataGotten = false;
  bool isGiftCardReached = false;

  //////////////////////////////////////////////////

  ////////////////products In Brands////////////////////////////////
  bool isProductsInBrandsLoading = false;
  List<dynamic> productsInBrands = [];
  bool isProductsInBrandsAdded = false;

  bool isProductsInBrandsReached = false;
  bool productsInBrandsGotten = false;

  //////////////////////////////////////////////////////////

  //////////////////////recommended////////////////////////
  bool isRecommendedReached = false;

  //////////////////////////////////////////////////////////

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getHomeApi();
    listenForFirstScroll();
    runVideo();
    // mimicCatsForActiveCats(false, null);
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    print("on close ....");
  }

  getHomeApi() async {
    isHomeLoading.value = true;
    print('home api successful');

    final response = await apiConsumer.get(
      'homepage',
    );

    try {
      final apiResponse = CustomHomeModel.fromJson(response);
      if (apiResponse.status == 'success') {
        print('home data successful');
        isHomeLoading.value = false;
        homeModel.value = apiResponse.data!;
        List<String> banners = [];
        print("the type is ${homeModel.value.banners.runtimeType}");

        // Handle successful home data
        // await _cacheUser(apiResponse.data!);
        // AppConstants.userData = apiResponse.data!;

        print("the categories are ${apiResponse.data!.categories}");
        mimicCatsForActiveCats(false, null);
        // await getHomeScreenCollections();
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
        print('Registration failed: ${response.statusMessage}');
      }
      // isLoading.value = false;
    } catch (e, stackTrace) {
      isHomeLoading.value = false;
      // isLoading.value = false;
      print('home api failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
    }

    await getWishlistProducts();
  }

  setCats() {
    homeModel.value.categories!.toSet().toList();
    print("the setted cats are ${homeModel.value.categories!}");
    update();
  }

  runVideo() {
    print("started... 1");
    videoController = VideoPlayerController.asset(
        'assets/images/home/home_video.mp4',
        videoPlayerOptions: VideoPlayerOptions())
      ..initialize().then((_) {
        print("started... 2");
      });
    videoController.play(); // Autoplay the video
    videoController.setLooping(true); // Enable video looping
  }

  void mimicCatsForActiveCats(bool isCategoryFilter, int? incomingId) {
    print("testing ..");
    List<Categories> myCatList = [];
    activeCats = [];
    Categories allItemCategory =
        Categories(name: "All", slug: "", image: "", id: 0);

    myCatList.add(allItemCategory);

    for (var cat in homeModel.value.categories!) {
      myCatList.add(cat);
    }
    print("all cats are ${myCatList}");

    for (var cat in myCatList) {
      if (cat.name == "All") {
        activeCats.add(1);
      } else {
        activeCats.add(0);
      }
    }
    print("active cats are ${activeCats}");
    addActiveCats(activeCats);
  }

  addActiveCats(List<int> incomingActiveCats) {
    Future.delayed((Duration(seconds: 1)), () {
      activeCats = incomingActiveCats;
      update();
    });
  }

  changeActiveCats(int incomingIndex) {
    for (var i = 0; i < activeCats.length; i++) {
      if (i != incomingIndex) {
        activeCats[i] = 0;
      } else {
        activeCats[i] = 1;
      }
    }

    print(activeCats);
    update();
  }

//////////Collections////////////////
  getHomeScreenCollections() async {
    if (isCollectionDataGotten == false) {
      isCollectionLoading = true;
      isCollectionDataGotten = true;
      print('Collections api loading ...');

      var formData = dio.FormData.fromMap({
        'home': "1",
      });

      final response = await apiConsumer.post(
        'collections',
        formDataIsEnabled: true,
        formData: formData,
      );

      try {
        final apiResponse = ApiCollectionsResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Collections data successful');
          isCollectionLoading = false;
          collections = apiResponse.data!.collections!;
          collections.isEmpty ? isProductAddedToCollection = true : null;
          print("collections are ${collections}");
          isCollectionDataGotten = true;
          update();
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Collections fetch failed: ${response.statusMessage}');
          isCollectionLoading = false;
          update();
        }
      } catch (e, stackTrace) {
        isCollectionLoading = false;

        print('Collections fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        update();
      }
    }
  }

  Future<List<dynamic>> getProductsInCollection(
      Collections mycollection) async {
    isProductAddedToCollection = false;
    List<dynamic> _products = [];

    var bodyFields = {
      'collection_ids[0]': "${mycollection.id}",
      'per_page': "4"
    };

    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final response = await http.post(
      Uri.parse('https://mariana.genixarea.pro/api/products'),
      headers: headers,
      body: bodyFields,
    );

    if (mycollection.id != null && mycollection.id != 0) {
      isCollectionProductsLoading = true;
      try {
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);

          for (var product in responseData['data']) {
            _products.add(product);
          }

          isProductAddedToCollection = true;
          print("your collection pro are ${responseData['data']}");

          return _products;
        } else {
          print(response.reasonPhrase);
          isCollectionProductsLoading = false;
          print('the prod are failed2 :  ${response.reasonPhrase}');

          return [];
        }
      } catch (e, stackTrace) {
        isCollectionProductsLoading = false;
        print('the prod are failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());

        return [];
      }
    } else {
      print("sorry the prod are empty");

      return [];
    }
  }

////////////////////////////////////

////////Brands///////////////////////////////
  getHomeScreenBrands() async {
    if (isBrandsDataGotten == false) {
      isBrandsDataGotten = true;
      isBrandLoading = true;
      print('Brands api loading ...');

      var formData = dio.FormData.fromMap({
        'home': "1",
      });

      final response = await apiConsumer.post(
        'brands',
        formDataIsEnabled: true,
        formData: formData,
      );

      try {
        final apiResponse = ApiBrandsResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Brands data successful');
          isBrandLoading = false;
          brands = apiResponse.data!.brands!;
          isProductAddedToBrand = true;

          print("brands are ${brands}");
          update();
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Brands fetch failed: ${response.statusMessage}');
          isBrandLoading = false;
          update();
        }
      } catch (e, stackTrace) {
        isBrandLoading = false;

        print('Brands fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        update();
      }
    }
  }

  Future<List<dynamic>> getProductsInBrand(Brands mybrand) async {
    isProductAddedToBrand = false;
    List _products = [];

    var bodyFields = {'brand_ids[0]': "${mybrand.id}", 'per_page': "4"};

    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final response = await http.post(
      Uri.parse('https://mariana.genixarea.pro/api/products'),
      headers: headers,
      body: bodyFields,
    );

    try {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        for (var product in responseData['data']) {
          _products.add(product);
        }

        return _products;
      } else {
        print(response.reasonPhrase);

        return [];
      }
    } catch (e, stackTrace) {
      print('brand fetch failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());

      return [];
    }
  }

  getHomeScreenOtherBrands() async {
    if (otherBrandsDataGotten == false) {
      otherBrandsDataGotten = true;
      otherBrandsId.clear();
      isOtherBrandLoading = true;
      print('Other Brands api loading ...');

      var formData = dio.FormData.fromMap({
        'home': "0",
      });

      final response = await apiConsumer.post(
        'brands',
        formDataIsEnabled: true,
        formData: formData,
      );

      try {
        final apiResponse = ApiBrandsResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Other Brands data successful');
          isOtherBrandLoading = false;
          otherBrands = apiResponse.data!.brands!;
          print("brands are ${otherBrands}");
          for (var brand in otherBrands) {
            otherBrandsId.add(brand.id.toString());
          }
          await getProductsInBrands();
          update();
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Other Brands fetch failed: ${response.statusMessage}');
          isOtherBrandLoading = false;
          update();
        }
      } catch (e, stackTrace) {
        isOtherBrandLoading = false;

        print('Brands fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        update();
      }
    }
  }

  getProductsInBrands() async {
    print("will start ?");
    if (productsInBrandsGotten == false) {
      print("will start ? yes");
      productsInBrandsGotten = true;
      isProductsInBrandsLoading = true;
      isProductsInBrandsAdded = false;

      await Future.forEach<Brands>(otherBrands, (Brands item) async {
        print("start getting ...........");
        await getTheProductsInBrands(item);
      });

      isProductsInBrandsLoading = false;
      isProductsInBrandsAdded = true;
      update();
    }
  }

  Future<dynamic> getTheProductsInBrands(Brands brand) async {
    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var bodyFields = {'brand_ids[0]': "${brand.id}", "per_page": "2"};
    final response = await http.post(
      Uri.parse('https://mariana.genixarea.pro/api/products'),
      headers: headers,
      body: bodyFields,
    );
    try {
      print("getiing ........");
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        for (var product in responseData['data']) {
          productsInBrands.add(product);
        }
        print("prodeucts done fully ${productsInBrands}");
        return productsInBrands;
      } else {
        print(response.reasonPhrase);
        isProductAddedToBrand = false;

        return [];
      }
    } catch (e, stackTrace) {
      isProductAddedToBrand = false;
      print('brand fetch failed:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());

      return [];
    }
  }

////////////////////////////////////

  ///////////////Coupon//////////////////////////////////
  getHomeScreenCoupons() async {
    if (coupons.isEmpty && userToken!.isNotEmpty && userToken != null) {
      if (couponsDataGotten == false) {
        couponsDataGotten = true;
        isCouponLoading = true;
        isCouponsAdded = false;

        coupons.clear();
        print('Coupon api loading ...');

        final response = await apiConsumer.post(
          'coupons',
          formDataIsEnabled: true,
        );

        try {
          final apiResponse = ApiCouponResponse.fromJson(response);
          if (apiResponse.status == 'success') {
            print('Coupon data successful');
            for (var coupon in apiResponse.data!.coupons!) {
              coupons.add(coupon);
            }

            print("coupons are ${coupons}");
            isCouponLoading = false;
            isCouponsAdded = true;
            update();
          } else {
            handleApiErrorUser(apiResponse.message);
            handleApiError(response.statusCode);
            print('Coupons fetch failed: ${response.statusMessage}');
            isCouponLoading = false;
            isCouponsAdded = false;
            update();
          }
        } catch (e, stackTrace) {
          isCouponLoading = false;

          print('Coupons fetch failed:  ${e} $stackTrace');

          print(e.toString() + stackTrace.toString());
          isCouponsAdded = false;
          update();
        }
      }
    }
  }

  /////////////////////////////////////////////////////////

//////////////////Styles//////////////////////////////////////
  getHomeScreenStyles() async {
    if (stylesDataGotten == false) {
      stylesDataGotten = true;
      isStylesLoading = true;
      isStylesAdded = false;
      styles.clear();
      print('styles api loading ...');

      final response = await apiConsumer.post(
        'styles',
        formDataIsEnabled: true,
      );

      try {
        final apiResponse = ApiStylesResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('styles data successful');

          styles = apiResponse.data!.styles!;
          print("styles are ${styles}");
          isStylesLoading = false;
          isStylesAdded = true;
          update();
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('styles fetch failed: ${response.statusMessage}');
          isStylesLoading = false;
          isStylesAdded = false;
          update();
        }
      } catch (e, stackTrace) {
        isStylesLoading = false;

        print('Styles fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        isStylesAdded = false;
        update();
      }
    }
  }

  ///////////////////////////////////////////////////////

//////////////////////Gift Cards ////////////////////////////////
  getHomeScreenGiftCards() async {
    if (isGiftCardsDataGotten == false) {
      isGiftCardsDataGotten = true;
      isGiftCardLoading = true;
      isGiftCardsAdded = false;
      giftCards.clear();
      print('gift Cards api loading ...');

      final response = await apiConsumer.post(
        'gift-card-types',
        formDataIsEnabled: true,
      );

      try {
        final apiResponse = ApiGiftCardsResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('gift Cards data successful');

          giftCards = apiResponse.data!.giftCards!;
          print("gift Cards are ${giftCards}");
          isGiftCardLoading = false;
          isGiftCardsAdded = true;
          update();
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('gift Cards fetch failed: ${response.statusMessage}');
          isGiftCardLoading = false;
          isGiftCardsAdded = false;
          update();
        }
      } catch (e, stackTrace) {
        isGiftCardLoading = false;

        print('Gift Card fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        isGiftCardsAdded = false;
        update();
      }
    }
  }

  /////////////////////////////////////////////////////

//////////////////////Wishlist/////////////////////////////////
  getWishlistProducts() async {
    wishlistProductIds.clear();
    print('Wishlist api loading ...');
    if (userToken!.isNotEmpty && userToken != null) {
      final response = await apiConsumer.post(
        'wishlist',
        formDataIsEnabled: true,
      );

      try {
        final apiResponse = WishlistData.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Wishlist data successful');
          for (var id in apiResponse.data!.wishlist!) {
            wishlistProductIds.addNonNull(id);
          }
          WishlistController wishlistController =
              Get.put<WishlistController>(WishlistController());
          wishlistController.setInitData(wishlistProductIds);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('wishlist fetch failed: ${response.statusMessage}');
        }
      } catch (e, stackTrace) {
        print('wishlist fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
      }
    }
  }

  removeFromWishlist(product_id) async {
    Get.snackbar('Removing ...', 'Removing From Wishlist',
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.white,
        backgroundColor: primaryColor,
        duration: const Duration(milliseconds: 1200),
        icon: Center(
            child: LoadingAnimationWidget.flickr(
          leftDotColor: Colors.purpleAccent,
          rightDotColor: Colors.white,
          size: 40.sp,
        )),
        isDismissible: true);
    print('removing from Wishlist api loading ...');
    if (userToken!.isNotEmpty && userToken != null) {
      var formData = dio.FormData.fromMap({
        'product_id': product_id,
      });
      final response = await apiConsumer.post('wishlist/remove',
          formDataIsEnabled: true, formData: formData);

      try {
        final apiResponse = WishlistData.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Wishlist data successful');

          wishlistProductIds.removeWhere((item) => item == product_id);
          WishlistController wishlistController =
              Get.put<WishlistController>(WishlistController());
          wishlistController.removeFromGrid(product_id);
          Get.snackbar('Removed', 'Removed from Wishlist',
              backgroundColor: primaryColor,
              icon: SvgPicture.asset(
                "assets/images/home/add_to_wishlist.svg",
                width: 43.w,
                height: 43.h,
                fit: BoxFit.cover,
              ),
              isDismissible: true);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('wishlist fetch failed: ${response.statusMessage}');
        }
      } catch (e, stackTrace) {
        print('wishlist fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
      }
    }
  }

  addToWishlist(product_id) async {
    Get.snackbar('Adding ...', 'Adding To Wishlist',
        showProgressIndicator: true,
        duration: const Duration(milliseconds: 1200),
        progressIndicatorBackgroundColor: Colors.white,
        backgroundColor: primaryColor,
        icon: Center(
            child: LoadingAnimationWidget.flickr(
          leftDotColor: Colors.purpleAccent,
          rightDotColor: Colors.white,
          size: 40.sp,
        )),
        isDismissible: true);
    print('removing from Wishlist api loading ...');
    if (userToken!.isNotEmpty && userToken != null) {
      var formData = dio.FormData.fromMap({
        'product_id': product_id,
      });
      final response = await apiConsumer.post('wishlist/add',
          formDataIsEnabled: true, formData: formData);

      try {
        final apiResponse = WishlistData.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Wishlist data successful');

          wishlistProductIds.add(product_id);
          Get.snackbar('Added', 'Added To Wishlist',
              backgroundColor: primaryColor,
              icon: SvgPicture.asset(
                "assets/images/home/wishlisted.svg",
                width: 43.w,
                height: 43.h,
                fit: BoxFit.cover,
              ),
              isDismissible: true);
          WishlistController wishlistController =
              Get.put<WishlistController>(WishlistController());
          wishlistController.addToGrid(product_id);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('wishlist fetch failed: ${response.statusMessage}');
        }
      } catch (e, stackTrace) {
        print('wishlist fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
      }
    }
  }

  ////////////////////////////////////////////////////////////////

  listenForFirstScroll() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 850.h) {
        print('Reached before max scroll by 850 pixels');

        isCollectionsReached = true;
        await getHomeScreenCollections();
        await getHomeScreenBrands();
        await getHomeScreenCoupons();
        await getHomeScreenGiftCards();
        await getHomeScreenStyles();
        await getHomeScreenOtherBrands();
        if (isProductAddedToCollection) {
          isBrandsReached = true;
        }

        if (isBrandsReached) {
          isCouponReached = true;
        }

        if (isCouponReached) {
          isGiftCardReached = true;
        }

        if (isGiftCardReached) {
          isStyleReached = true;
        }

        if (isStyleReached) {
          isOtherBrandReached = true;
        }
        if (isOtherBrandReached) {
          isProductsInBrandsReached = true;
        }
      }

      if (isProductsInBrandsReached) {
        isRecommendedReached = true;
      }
    });
  }
}
