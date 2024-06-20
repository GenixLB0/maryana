import 'model_response.dart';

class CustomHomeModel {
  String? status;
  String? message;
  TestData? data;

  CustomHomeModel({this.status, this.message, this.data});

  CustomHomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new TestData.fromJson(json['data']) : null;
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

class TestData {
  List<Null>? setting;
  int? totalPoints;
  List<Categories>? categories;
  List<Brands>? brands;
  List<Banners>? banners;
  List<Product>? product;

  TestData(
      {this.setting,
        this.totalPoints,
        this.categories,
        this.brands,
        this.banners,
        this.product});

  TestData.fromJson(Map<String, dynamic> json) {
    if (json['setting'] != null) {
      setting = <Null>[];
      json['setting'].forEach((v) {
        // setting!.add(new Null.fromJson(v));
      });
    }
    totalPoints = json['total_points'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.setting != null) {
      // data['setting'] = this.setting!.map((v) => v!.toJson()).toList();
    }
    data['total_points'] = this.totalPoints;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
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

class Banners {
  String? image;

  Banners({this.image});

  Banners.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  Null? discountedPrice;

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
