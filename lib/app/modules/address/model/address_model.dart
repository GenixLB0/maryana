class Address {
  int id;
  String label;
  String apartment;
  String floor;
  String building;
  String address;
  String phone;
  String city;
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
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }
}
