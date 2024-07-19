import 'model_response.dart';

class CustomHomeModel {
  String? status;
  String? message;
  HomeData? data;

  CustomHomeModel({this.status, this.message, this.data});

  CustomHomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new HomeData.fromJson(json['data']) : null;
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

class HomeData {
  List<String>? setting;
  int? totalPoints;
  List<Categories>? categories;
  List<Brands>? brands;
  List<Banners>? banners;
  List<ViewProductData>? product;

  HomeData(
      {this.setting,
      this.totalPoints,
      this.categories,
      this.brands,
      this.banners,
      this.product});

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['setting'] != null) {
      setting = <String>[];
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
      product = <ViewProductData>[];
      json['product'].forEach((v) {
        product!.add(ViewProductData.fromJson(v));
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

class ViewProductData {
  int? id;
  String? name;
  String? description;
  String? image;
  String? price;
  List<ProductColor>? colors;
  List<dynamic>? sizes;
  Unit? unit;
  Categories? category;
  Styles? style;
  Material? material;
  List<Attachments>? attachments;

  ViewProductData(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.price,
      this.colors,
      this.sizes,
      this.unit,
      this.category,
      this.style,
      this.material,
      this.attachments});

  ViewProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    if (json['colors'] != null) {
      colors = <ProductColor>[];
      json['colors'].forEach((v) {
        colors!.add(ProductColor.fromJson(v));
      });
    }

    sizes = json['sizes'];
    unit = json['unit'] != null ? Unit.fromJson(json['unit']) : null;
    category =
        json['category'] != null ? Categories.fromJson(json['category']) : null;
    style = json['style'] != null ? Styles.fromJson(json['style']) : null;
    material =
        json['material'] != null ? Material.fromJson(json['material']) : null;

    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
    print("testing the data ${sizes}");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['colors'] = this.colors;
    data['sizes'] = this.sizes;
    if (this.unit != null) {
      data['unit'] = this.unit!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.style != null) {
      data['style'] = this.style!.toJson();
    }

    if (this.material != null) {
      data['material'] = this.material!.toJson();
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

class ProductColor {
  int? id;
  String? name;
  String? hex;

  ProductColor({this.id, this.name, this.hex});

  ProductColor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    hex = json['hex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['hex'] = this.hex;
    return data;
  }
}

class Attachments {
  String? type;
  String? name;
  String? path;

  Attachments({this.type, this.name, this.path});

  Attachments.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    data['path'] = this.path;
    return data;
  }
}