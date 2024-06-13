class ApiResponse {
  final String status;
  final String message;
  final UserData? data;

  ApiResponse({required this.status, required this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
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
