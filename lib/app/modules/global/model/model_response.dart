import 'dart:convert';

import 'package:maryana/app/modules/address/model/address_model.dart';
import 'package:maryana/app/modules/global/model/test_model_response.dart';
// lib/app/modules/orders/models/order_model.dart

class Order {
  final int id;
  final String code;
  final dynamic subTotal;
  final dynamic tax;
  final dynamic shipping;
  final dynamic discount;
  final dynamic total;
  final bool readyToPay;
  final String status;
  final Address? address;
  final List<Item> items;
  final String date;

  Order({
    required this.id,
    required this.code,
    required this.subTotal,
    required this.tax,
    required this.shipping,
    required this.discount,
    required this.total,
    required this.readyToPay,
    required this.status,
    required this.address,
    required this.items,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      code: json['code'],
      subTotal: json['sub_total'],
      tax: json['tax'],
      shipping: json['shipping'],
      discount: json['discount'],
      total: json['total'],
      readyToPay: json['ready_to_pay'],
      status: json['status'] ?? 'pending',
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      items: (json['items'] as List).map((i) => Item.fromJson(i)).toList(),
      date: json['date'] ?? 'Today',
    );
  }
}

class Item {
  final int quantity;
  final double price;
  final double discount;
  final double tax;
  final double total;
  final Product? product;

  Item({
    required this.quantity,
    required this.price,
    required this.discount,
    required this.tax,
    required this.total,
    required this.product,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      discount: json['discount'].toDouble(),
      tax: json['tax'].toDouble(),
      total: json['total'].toDouble(),
      product:
          json['product'] == null ? null : Product.fromJson(json['product']),
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
  int? total_points;

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
    this.total_points,
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
      total_points: json['total_points'],
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
      'total_points': total_points,
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
  String? type;
  int? amount;
  ExpireAt? expireAt;

  Coupons({this.id, this.name, this.code, this.amount, this.expireAt});

  Coupons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    type = json['type'];
    amount = json['amount'];
    expireAt = json['expire_at'] != null
        ? new ExpireAt.fromJson(json['expire_at'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['type'] = this.type;
    data['amount'] = this.amount;
    if (this.expireAt != null) {
      data['expire_at'] = this.expireAt!.toJson();
    }
    return data;
  }
}

class ExpireAt {
  String? day;
  String? month;

  ExpireAt({this.day, this.month});

  ExpireAt.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['month'] = this.month;
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
  dynamic errors;
  GiftCardsData? data;

  ApiGiftCardsResponse({this.status, this.message, this.data});

  ApiGiftCardsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    data =
        json['data'] != null ? new GiftCardsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (data['errors'] != null) {
      data['errors'] = this.errors!.toJson();
    }
    data['errors'] = this.errors;
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

class ApiSendGiftCard {
  String? status;
  String? message;
  dynamic data;

  ApiSendGiftCard({this.status, this.message, this.data});

  ApiSendGiftCard.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {}
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

/////////////////////////////////////////

class SizeGuide {
  String? name;
  String? fitType;
  String? stretch;
  String? description;
  List<Attr>? attr;

  SizeGuide(
      {this.name, this.fitType, this.stretch, this.description, this.attr});

  SizeGuide.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fitType = json['fit_type'];
    stretch = json['stretch'];
    description = json['description'];
    if (json['attr'] != null) {
      attr = <Attr>[];
      json['attr'].forEach((v) {
        attr!.add(new Attr.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['fit_type'] = this.fitType;
    data['stretch'] = this.stretch;
    data['description'] = this.description;
    if (this.attr != null) {
      data['attr'] = this.attr!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attr {
  String? size;
  String? type;
  String? length;
  String? waist;
  String? hip;
  String? bust;

  Attr({this.size, this.type, this.length, this.waist, this.hip, this.bust});

  Attr.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    type = json['type'];
    length = json['length'];
    waist = json['waist'];
    hip = json['hip'];
    bust = json['bust'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size;
    data['type'] = this.type;
    data['length'] = this.length;
    data['waist'] = this.waist;
    data['hip'] = this.hip;
    data['bust'] = this.bust;
    return data;
  }
}

class ReviewsModel {
  int? id;
  String? title;
  String? comment;
  int? rating;
  String? customer;

  ReviewsModel({this.id, this.title, this.comment, this.rating, this.customer});

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    comment = json['comment'];
    rating = json['rating'];
    customer = json['customer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['customer'] = this.customer;
    return data;
  }
}

class FilterOneModel {
  String? status;
  String? message;
  OneFilterData? data;

  FilterOneModel({this.status, this.message, this.data});

  FilterOneModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new OneFilterData.fromJson(json['data']) : null;
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

class OneFilterData {
  String? minPrice;
  String? maxPrice;
  List<ProductColor>? colors;
  List<Brands>? brands;
  List<Styles>? styles;
  List<Collections>? collections;
  List<Materials>? materials;
  List<String>? seasons;
  List<String>? sizes;

  OneFilterData(
      {this.minPrice,
      this.maxPrice,
      this.colors,
      this.brands,
      this.styles,
      this.collections,
      this.materials,
      this.seasons,
      this.sizes});

  OneFilterData.fromJson(Map<String, dynamic> json) {
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    if (json['colors'] != null) {
      colors = <ProductColor>[];
      json['colors'].forEach((v) {
        colors!.add(new ProductColor.fromJson(v));
      });
    }
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
    if (json['styles'] != null) {
      styles = <Styles>[];
      json['styles'].forEach((v) {
        styles!.add(new Styles.fromJson(v));
      });
    }
    if (json['collections'] != null) {
      collections = <Collections>[];
      json['collections'].forEach((v) {
        collections!.add(new Collections.fromJson(v));
      });
    }
    if (json['materials'] != null) {
      materials = <Materials>[];
      json['materials'].forEach((v) {
        materials!.add(new Materials.fromJson(v));
      });
    }
    seasons = json['seasons'].cast<String>();
    sizes = json['sizes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    if (this.colors != null) {
      data['colors'] = this.colors!.map((v) => v.toJson()).toList();
    }
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    if (this.styles != null) {
      data['styles'] = this.styles!.map((v) => v.toJson()).toList();
    }
    if (this.collections != null) {
      data['collections'] = this.collections!.map((v) => v.toJson()).toList();
    }
    if (this.materials != null) {
      data['materials'] = this.materials!.map((v) => v.toJson()).toList();
    }
    data['seasons'] = this.seasons;
    data['sizes'] = this.sizes;
    return data;
  }
}

class Materials {
  int? id;
  String? name;

  Materials({this.id, this.name});

  Materials.fromJson(Map<String, dynamic> json) {
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
