class Country {
  final String name;
  final String code;
  final String phoneCode;

  Country({required this.name, required this.code, required this.phoneCode});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
      phoneCode: json['phone_code'],
    );
  }
}

class Address {
  int id;
  String label;
  String apartment;
  String floor;
  String building;
  String address;
  String phone;
  String city;
  String country;
  String state;
  dynamic latitude;
  dynamic longitude;
  int isDefault;

  Address({
    required this.id,
    required this.label,
    required this.apartment,
    required this.floor,
    required this.building,
    required this.address,
    required this.phone,
    required this.city,
    required this.country,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      label: json['label'],
      apartment: json['apartment'],
      floor: json['floor'],
      building: json['building'],
      address: json['address'],
      phone: json['phone'],
      city: json['city'],
      country: json['country'],
      state: json['state'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isDefault: json['is_default'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'apartment': apartment,
      'floor': floor,
      'building': building,
      'address': address,
      'phone': phone,
      'city': city,
      'country': country,
      'state': state,
      'latitude': latitude == '' || latitude == null ? '33.888630' : latitude,
      'longitude':
          longitude == '' || longitude == null ? '35.495480' : longitude,
      'is_default': isDefault,
    };
  }
}
