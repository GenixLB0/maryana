import 'dart:convert';

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
  final String firstName;
  final String lastName;
  final String? username;
  final String? photo;
  final String email;
  final String? phone;
  final String? langCode;
  final String? dob;

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
      photo: json['photo'],
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
  List<String>? banners;
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

class Product {
  int? id;
  String? name;
  String? description;
  String? image;
  String? price;
  String? discountedPrice;

  Product(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.price,
      this.discountedPrice});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    discountedPrice = json['discounted_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    return data;
  }
}
