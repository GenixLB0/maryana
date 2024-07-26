import 'dart:convert';

import 'package:maryana/app/modules/global/model/test_model_response.dart';
// lib/app/modules/orders/models/order_model.dart

class Order {
  final int id;
  final String trackingNumber;
  final double subtotal;
  final String status;
  final String date;

  Order({
    required this.id,
    required this.trackingNumber,
    required this.subtotal,
    required this.status,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      trackingNumber: json['code'],
      subtotal: double.parse(json['sub_total']),
      status: json['status'],
      date: 'Today',
    );
  }
}

class ApiResponse {
  final String? status;
  final String? message;
  final UserData? data;

  ApiResponse({required this.status, required this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] ?? json['status'],
      message: json['message'] ?? json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class ApiCategoryResponse {
  String? status;
  String? message;
  List<Categories>? data;

  ApiCategoryResponse({this.status, this.message, this.data});

  ApiCategoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Categories>[];
      json['data'].forEach((v) {
        data!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ApiHomeResponse {
  final String status;
  final String message;
  final HomeModel? data;

  ApiHomeResponse({required this.status, required this.message, this.data});

  factory ApiHomeResponse.fromJson(Map<String, dynamic> json) {
    return ApiHomeResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? HomeModel.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final User user;
  final String token;

  UserData({required this.user, required this.token});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}

class User {
  final int id;
  String firstName;
  String lastName;
  String? username;
  String? photo;
  String email;
  String? phone;
  final String? langCode;
  String? dob;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.username,
    this.photo,
    required this.email,
    this.phone,
    this.langCode,
    this.dob,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      photo: json['avatar'],
      email: json['email'],
      phone: json['phone'],
      langCode: json['lang_code'],
      dob: json['dob'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'photo': photo,
      'email': email,
      'phone': phone,
      'lang_code': langCode,
      'dob': dob,
    };
  }
}

class HomeModel {
  List<String>? setting;
  int? totalPoints;
  List<Categories>? categories;
  List<dynamic>? banners;
  List<Product>? product;

  HomeModel(
      {this.setting,
      this.totalPoints,
      this.categories,
      this.banners,
      this.product});

  HomeModel.fromJson(Map<String, dynamic> json) {
    setting = json['setting'].cast<String>();
    totalPoints = json['total_points'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    banners = json['banners'].cast<String>();
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['setting'] = this.setting;
    data['total_points'] = this.totalPoints;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    data['banners'] = this.banners;
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? slug;
  String? image;

  Categories({this.id, this.name, this.slug, this.image});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    return data;
  }
}

class SearchResultModel {
  String? status;
  String? message;
  Data? data;

  SearchResultModel({this.status, this.message, this.data});

  SearchResultModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<ViewProductData>? products;
  List<Categories>? categories;

  Data({this.products, this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <ViewProductData>[];
      json['products'].forEach((v) {
        products!.add(ViewProductData.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterResultModel {
  List<Data>? data;

  FilterResultModel({this.data});

  FilterResultModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterData {
  int? id;
  String? name;
  String? description;
  String? image;
  String? price;
  Null? discountedPrice;
  Unit? unit;
  Category? category;

  FilterData(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.price,
      this.discountedPrice,
      this.unit,
      this.category});

  FilterData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    discountedPrice = json['discounted_price'];
    unit = json['unit'] != null ? new Unit.fromJson(json['unit']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    if (this.unit != null) {
      data['unit'] = this.unit!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class Unit {
  int? id;
  String? name;

  Unit({this.id, this.name});

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? slug;
  Null? image;

  Category({this.id, this.name, this.slug, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    return data;
  }
}

class ApiCollectionsResponse {
  String? status;
  String? message;
  CollectionData? data;

  ApiCollectionsResponse({this.status, this.message, this.data});

  ApiCollectionsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CollectionData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CollectionData {
  List<Collections>? collections;

  CollectionData({this.collections});

  CollectionData.fromJson(Map<String, dynamic> json) {
    if (json['collections'] != null) {
      collections = <Collections>[];
      json['collections'].forEach((v) {
        collections!.add(new Collections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.collections != null) {
      data['collections'] = this.collections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Collections {
  int? id;
  String? name;
  String? image;

  Collections({this.id, this.name, this.image});

  Collections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class CollectionProducts {
  String collectionName;
  List<dynamic> products;

  CollectionProducts({required this.collectionName, required this.products});
}

class ApiBrandsResponse {
  String? status;
  String? message;
  BrandsData? data;

  ApiBrandsResponse({this.status, this.message, this.data});

  ApiBrandsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new BrandsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BrandsData {
  List<Brands>? brands;

  BrandsData({this.brands});

  BrandsData.fromJson(Map<String, dynamic> json) {
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  int? id;
  String? name;
  String? image;

  Brands({this.id, this.name, this.image});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class BrandProducts {
  String brandName;
  List<dynamic> products;

  BrandProducts({required this.brandName, required this.products});
}

class ApiCouponResponse {
  String? status;
  String? message;
  CouponData? data;

  ApiCouponResponse({this.status, this.message, this.data});

  ApiCouponResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CouponData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CouponData {
  List<Coupons>? coupons;

  CouponData({this.coupons});

  CouponData.fromJson(Map<String, dynamic> json) {
    if (json['coupons'] != null) {
      coupons = <Coupons>[];
      json['coupons'].forEach((v) {
        coupons!.add(new Coupons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coupons != null) {
      data['coupons'] = this.coupons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupons {
  int? id;
  String? name;
  String? code;
  int? amount;
  String? expireAt;

  Coupons({this.id, this.name, this.code, this.amount, this.expireAt});

  Coupons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    amount = json['amount'];
    expireAt = json['expire_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['amount'] = this.amount;
    data['expire_at'] = this.expireAt;
    return data;
  }
}

class ApiStylesResponse {
  String? status;
  String? message;
  StyleData? data;

  ApiStylesResponse({this.status, this.message, this.data});

  ApiStylesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new StyleData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StyleData {
  List<Styles>? styles;

  StyleData({this.styles});

  StyleData.fromJson(Map<String, dynamic> json) {
    if (json['styles'] != null) {
      styles = <Styles>[];
      json['styles'].forEach((v) {
        styles!.add(new Styles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.styles != null) {
      data['styles'] = this.styles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Styles {
  int? id;
  String? name;
  String? image;

  Styles({this.id, this.name, this.image});

  Styles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class WishlistData {
  String? status;
  String? message;
  WishData? data;

  WishlistData({this.status, this.message, this.data});

  WishlistData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new WishData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Material {
  int? id;
  String? name;
  String? image;

  Material({this.id, this.name, this.image});

  Material.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class WishData {
  List<int>? wishlist;

  WishData({this.wishlist});

  WishData.fromJson(Map<String, dynamic> json) {
    wishlist = json['wishlist'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wishlist'] = this.wishlist;
    return data;
  }
}

////////////////////colors//////////////////////
class ApiColorsResponse {
  String? status;
  String? message;
  ProductColorsData? data;

  ApiColorsResponse({this.status, this.message, this.data});

  ApiColorsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new ProductColorsData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProductColorsData {
  List<ProductColor>? colors;

  ProductColorsData({this.colors});

  ProductColorsData.fromJson(Map<String, dynamic> json) {
    if (json['colors'] != null) {
      colors = <ProductColor>[];
      json['colors'].forEach((v) {
        colors!.add(new ProductColor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.colors != null) {
      data['colors'] = this.colors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

///////////////////////////////////////////////

////////////////Seasons///////////////////////
class ApiSeasonsResponse {
  String? status;
  String? message;
  SeasonData? data;

  ApiSeasonsResponse({this.status, this.message, this.data});

  ApiSeasonsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SeasonData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SeasonData {
  List<String>? seasons;

  SeasonData({this.seasons});

  SeasonData.fromJson(Map<String, dynamic> json) {
    seasons = json['seasons'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seasons'] = this.seasons;
    return data;
  }
}

//////////////////Materials ////////////////////////////
class ApiMaterialsResponse {
  String? status;
  String? message;
  MaterialData? data;

  ApiMaterialsResponse({this.status, this.message, this.data});

  ApiMaterialsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new MaterialData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MaterialData {
  List<Material>? materials;

  MaterialData({this.materials});

  MaterialData.fromJson(Map<String, dynamic> json) {
    if (json['materials'] != null) {
      materials = <Material>[];
      json['materials'].forEach((v) {
        materials!.add(new Material.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.materials != null) {
      data['materials'] = this.materials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/////////////////////////////////////////////////////////
//////////////////Size//////////////////////////////////
class ApiSizesResponse {
  String? status;
  String? message;
  SizeData? data;

  ApiSizesResponse({this.status, this.message, this.data});

  ApiSizesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SizeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SizeData {
  List<String>? sizes;

  SizeData({this.sizes});

  SizeData.fromJson(Map<String, dynamic> json) {
    sizes = json['sizes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sizes'] = this.sizes;
    return data;
  }
}

//////////////////////////////////////////////////////////////
//////////////////Gift-Cards///////////////////////////////
class ApiGiftCardsResponse {
  String? status;
  String? message;
  GiftCardsData? data;

  ApiGiftCardsResponse({this.status, this.message, this.data});

  ApiGiftCardsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new GiftCardsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GiftCardsData {
  List<GiftCards>? giftCards;

  GiftCardsData({this.giftCards});

  GiftCardsData.fromJson(Map<String, dynamic> json) {
    if (json['gift_cards'] != null) {
      giftCards = <GiftCards>[];
      json['gift_cards'].forEach((v) {
        giftCards!.add(new GiftCards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.giftCards != null) {
      data['gift_cards'] = this.giftCards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GiftCards {
  int? id;
  String? name;
  String? image;
  int? amount;

  GiftCards({this.id, this.name, this.image, this.amount});

  GiftCards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['amount'] = this.amount;
    return data;
  }
}
