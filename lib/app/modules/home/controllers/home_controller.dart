import 'dart:convert';

import 'dart:ui';
import 'dart:ui';
import 'dart:ui';
import 'dart:ui';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:maryana/app/modules/global/config/constant.dart';
import 'package:image/image.dart' as img;
import 'package:maryana/app/modules/global/widget/widget.dart';

import 'package:maryana/app/modules/search/controllers/search_controller.dart';
import 'package:maryana/app/modules/search/views/result_view.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:public_ip_address/public_ip_address.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../../routes/app_pages.dart';

import '../../global/model/model_response.dart';
import '../../global/model/test_model_response.dart' hide Brands;

import '../../services/api_consumer.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  Rx<ScrollController> scrollController = ScrollController().obs;

  ApiService apiService = Get.find();
  ApiConsumer apiConsumer = sl();
  Rx<HomeData> homeModel = HomeData().obs;
  late VideoPlayerController videoController;
  List<int> activeCats = [];
  RxBool isHomeLoading = false.obs;
  final wishlistProductIds = <int>[].obs;
  bool isVideoInit = false;
  RxBool zeroNavBar = false.obs;
  RxString videoPath = "".obs;
  RxString videoCaption = "".obs;
  //////////////Upper Bar Check//////////////
  RxString currentSectionName = "".obs;
  var ongoingPayload = {};

  void currentFun() {
    if (CustomSearchController().initialized) {
      CustomSearchController myController = Get.find<CustomSearchController>();
      myController.getProductsInSection(
          sectionName: currentSectionName.value, payload: ongoingPayload);
      Get.to(() => const ResultView(),
          transition: Transition.fadeIn,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400));
    } else {
      CustomSearchController myController =
          Get.put<CustomSearchController>(CustomSearchController());
      myController.getProductsInSection(
          sectionName: currentSectionName.value, payload: ongoingPayload);

      Get.to(() => const ResultView(),
          transition: Transition.fadeIn,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400));
    }
  }

  changeNameAndFunParam(upComingName, upcomingPayload) {
    currentSectionName.value = upComingName;

    ongoingPayload = upcomingPayload;
  }

  //////////////////////////////////////////
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
    listenForFirstScroll();

    super.onInit();
  }

  @override
  void dispose() {
    scrollController.value.dispose();
    super.dispose();
  }

  @override
  void onReady() {
    getHomeApi();


    getCountryFromIp();
    checkForUpdates();
    // mimicCatsForActiveCats(false, null);
    super.onReady();
  }

  bool isUpdateLoading = false;

  Future<void> checkForUpdates() async {
    final shorebirdCodePush = ShorebirdCodePush();

    // Check whether a patch is available to install.
    final isUpdateAvailable =
        await shorebirdCodePush.isNewPatchAvailableForDownload();

    if (isUpdateAvailable) {
      await Get.dialog(
        isUpdateLoading
            ? const CircularProgressIndicator()
            : AlertDialog(
                title: Text(
                  'Update Available!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'A new version of the app is available. Do you want to download it now?',
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    child: Text('No'),
                    onPressed: () => Get.back(),
                  ),
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      isUpdateLoading = true;
                      Get.back(closeOverlays: true);
                      await shorebirdCodePush
                          .downloadUpdateIfAvailable()
                          .then((value) {
                        isUpdateLoading = false;
                      });

                      if (!Get.isDialogOpen! && isUpdateLoading == false) {
                        Get.dialog(
                          AlertDialog(
                            title: Text(
                              'Restart App',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              'restart the app for the new patch to take effect. Do you want to restart it now?',
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                child: Text('No'),
                                onPressed: () => Get.back(),
                              ),
                              ElevatedButton(
                                child: Text('Yes'),
                                onPressed: () async {
                                  print("restart app");
                                  Restart.restartApp.call();
                                },
                              )
                            ],
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
        useSafeArea: false,
      );
      // Download the new patch if it's available.
    }
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

        videoPath.value = apiResponse.data!.setting![0].home_video!;
        videoCaption.value = apiResponse.data!.setting![1].video_caption ?? "";
      print("the video path is ${videoPath.value}");
        await runVideo();
        update(['home-video']);
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


  var myChewieController;
  runVideo() async {
    print("started... 1");

    final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        videoPath.value));

    await videoPlayerController.initialize();

     myChewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 9/16,
      autoInitialize: true,
      placeholder: loadingIndicatorWidget(),
      showOptions: false,
      showControls: false,

      autoPlay: true,
      looping: true,
    );

    isVideoInit = true;
    update(['home-video']);
    // videoController = videoPath.value.isEmpty
    //     ? VideoPlayerController.asset('assets/images/home/home_video.mp4',
    //     videoPlayerOptions: VideoPlayerOptions())
    //     :

    // videoController = VideoPlayerController.network( videoPath.value, )
    //   ..initialize().then((_) {
    //
    //     videoController.play(); // Autoplay the video
    //     videoController.setLooping(true); // Enable video looping

    //   });
    //   // Ensure the first frame is shown after the video is initialized. }); }
    //
    //
    // Future.delayed(Duration(seconds: 2), () {
    //   VideoPlayerController.networkUrl(Uri.parse(videoPath.value),
    //       videoPlayerOptions: VideoPlayerOptions())
    //     ..initialize().then((_) {
    //       print("started... 2");
    //     });
    //   Future.delayed(Duration(seconds: 2), () async{
    //    await  videoController.initialize();
    //     videoController.play(); // Autoplay the video
    //     videoController.setLooping(true); // Enable video looping
    //     print("current vid path is ${videoPath.value}");
    //     isVideoInit = true;
    //     update(['home-video']);
    //   });
    //
    // });

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
          isCollectionsReached = true;
          update(['collections']);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Collections fetch failed: ${response.statusMessage}');
          isCollectionLoading = false;
          isCollectionsReached = true;
          update(['collections']);
        }
      } catch (e, stackTrace) {
        isCollectionLoading = false;

        print('Collections fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        isCollectionsReached = true;
        update(['collections']);
      }
    }
  }

  Future<List<dynamic>> getProductsInCollection(
      Collections mycollection) async {
    isProductAddedToCollection = false;
    List<dynamic> _products = [];

    var bodyFields = {
      'collection_ids[0]': "${mycollection.id}",
      'per_page': "7"
    };

    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final response = await http.post(
      Uri.parse('https://panel.mariannella.com/api/products'),
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
          isBrandsReached = true;
          update(['brands']);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Brands fetch failed: ${response.statusMessage}');
          isBrandLoading = false;
          isBrandsReached = true;
          update(['brands']);
        }
      } catch (e, stackTrace) {
        isBrandLoading = false;

        print('Brands fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        isBrandsReached = true;
        update(['brands']);
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
      Uri.parse('https://panel.mariannella.com/api/products'),
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
          update(['other-brands']);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Other Brands fetch failed: ${response.statusMessage}');
          isOtherBrandLoading = false;
          update(['other-brands']);
        }
      } catch (e, stackTrace) {
        isOtherBrandLoading = false;

        print('Brands fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        update(['other-brands']);
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
      update(['products-in-other-brands']);
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
      Uri.parse('https://panel.mariannella.com/api/products'),
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
    if (coupons.isEmpty && userToken != null) {
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
            isCouponReached = true;
            update(['coupons']);
          } else {
            handleApiErrorUser(apiResponse.message);
            handleApiError(response.statusCode);
            print('Coupons fetch failed: ${response.statusMessage}');
            isCouponLoading = false;
            isCouponsAdded = false;
            isCouponReached = true;
            update(['coupons']);
          }
        } catch (e, stackTrace) {
          isCouponLoading = false;

          print('Coupons fetch failed:  ${e} $stackTrace');

          print(e.toString() + stackTrace.toString());
          isCouponsAdded = false;
          isCouponReached = true;
          update(['coupons']);
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
          isStyleReached = true;
          update(['styles']);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('styles fetch failed: ${response.statusMessage}');
          isStylesLoading = false;
          isStylesAdded = false;
          isStyleReached = true;
          update(['styles']);
        }
      } catch (e, stackTrace) {
        isStylesLoading = false;

        print('Styles fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        isStylesAdded = false;
        isStyleReached = true;
        update(['styles']);
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
          isGiftCardReached = true;
          selectedGiftCard = giftCards.first;
          update(['gift-cards']);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('gift Cards fetch failed: ${response.statusMessage}');
          isGiftCardLoading = false;
          isGiftCardsAdded = false;
          isGiftCardReached = true;
          update(['gift-cards']);
        }
      } catch (e, stackTrace) {
        isGiftCardLoading = false;

        print('Gift Card fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
        isGiftCardsAdded = false;
        isGiftCardReached = true;
        update(['gift-cards']);
      }
    }
  }

  /////////////////////////////////////////////////////

//////////////////////Wishlist/////////////////////////////////
  getWishlistProducts() async {
    wishlistProductIds.clear();
    print('Wishlist api loading ...');
    if (userToken != null) {
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


    if (userToken != null) {
      Get.closeCurrentSnackbar();
      Get.snackbar('Removed', 'Removed from Wishlist',
          // backgroundColor: primaryColor,
          icon: SvgPicture.asset(
            "assets/images/home/add_to_wishlist.svg",
            width: 43.w,
            height: 43.h,
            fit: BoxFit.cover,
          ),
          isDismissible: true);

      print('removing from Wishlist api loading ...');
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


    if (userToken != null) {
      Get.closeCurrentSnackbar();
      Get.snackbar('Added', 'Added To Wishlist',
          // backgroundColor: primaryColor,
          icon: SvgPicture.asset(
            "assets/images/home/wishlisted.svg",
            width: 43.w,
            height: 43.h,
            fit: BoxFit.cover,
          ),
          isDismissible: true);

      print('removing from Wishlist api loading ...');

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
    } else {
      Get.closeCurrentSnackbar();
      Get.snackbar('System', 'Please Log in First',
          showProgressIndicator: true,
          duration: const Duration(milliseconds: 1200),
          progressIndicatorBackgroundColor: Colors.white,
          // backgroundColor: primaryColor,
          icon: Center(child: Icon(Icons.login)),
          isDismissible: true);
    }
  }

  ////////////////////////////////////////////////////////////////
  bool isDataLoaded = false;

  void listenForFirstScroll() {
    scrollController.value.addListener(() async {
      // Check if the user has already loaded the data and is not reloading it
      if (!isDataLoaded &&
          scrollController.value.position.pixels >=
              scrollController.value.position.maxScrollExtent - 350.h) {
        print('Reached before max scroll by 850 pixels');

        // Load the collections only once
        await getHomeScreenCollections();
        if (isCollectionsReached) {
          print("Reached what? Collections");
          await getHomeScreenBrands();
        }

        if (isBrandsReached && isCollectionsReached) {
          print("Reached what? Coupons");
          await getHomeScreenCoupons();
        }

        if (isCouponReached && isBrandsReached && isCollectionsReached) {
          print("Reached what? Gift cards");
          await getHomeScreenGiftCards();
        }

        if (isGiftCardReached &&
            isCouponReached &&
            isBrandsReached &&
            isCollectionsReached) {
          print("Reached what? Styles");
          await getHomeScreenStyles();
        }

        if (isStyleReached &&
            isGiftCardReached &&
            isCouponReached &&
            isBrandsReached &&
            isCollectionsReached) {
          isOtherBrandReached = true;
        }

        if (isOtherBrandReached) {
          print("Reached what? Other brands");
          await getHomeScreenOtherBrands();
        }

        // Set the flag to prevent reloading data
        isDataLoaded = true;
      }
    });
  }

  GiftCards selectedGiftCard = GiftCards(
      id: 0, image: AppConstants.placeHolderImage, name: "Empty", amount: 0);
  String selectedEmail = "";

  changeSelectedEmail(email) {
    selectedEmail = email;
  }

  changeSelectedGiftCardId(String comingGiftCard) {
    selectedGiftCard = giftCards
        .firstWhere((card) => card.amount.toString() == comingGiftCard);
    print("selected is ${selectedGiftCard}");
    update(['gift-cards']);
  }

  sendGiftCard() async {
    if (userToken != null) {
      var apiResponse;
      try {
        var reponse = await apiConsumer.post(
          "gift-cards/send",
          body: {
            'email': selectedEmail,
            'gift_card_type_id': selectedGiftCard.id
          },
        );
        apiResponse = ApiSendGiftCard.fromJson(reponse);
        if (apiResponse.status == "success") {
          Get.offNamedUntil(Routes.MAIN, (Route) => false);
          Get.closeCurrentSnackbar();
          Get.snackbar("Sent!", "Gift Card Sent Successfully");
        } else {
          print("error now  1");
          Get.closeCurrentSnackbar();
          Get.snackbar("Error!", "Please Check The Entered Email");
        }
      } catch (e) {
        print("error now  2");
        print("error happened !");

        Get.closeCurrentSnackbar();
        Get.snackbar("Error!", "Please Check The Entered Email");
      }
    }
  }

  getCountryFromIp() async {
    IpAddress _ipAddress = IpAddress();

    String country = await IpAddress().getCountry().then((value) {
      if (value.contains("Format")) {
        Get.snackbar("Welcome", "Welcome To Mariannella App");
      } else {
        if (value.contains("Hand")) {
          Get.snackbar("Welcome", "Welcome To Mariannella App");
        } else {
          Get.snackbar("Welcome", "Welcome Mariannella User From ${value}");
        }
      }
      return value;
    });
    // var ip = await _ipAddress.getIp();
    // print(ip);
  }
}
