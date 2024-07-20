class AuthError {
  AuthError({
    this.statusCode,
    this.message,
    this.errors,
  });

  final int? statusCode;
  final String? message;
  final Errors? errors;

  AuthError copyWith({
    int? statusCode,
    String? message,
    Errors? errors,
  }) =>
      AuthError(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        errors: errors ?? this.errors,
      );

  factory AuthError.fromJson(Map<String, dynamic> json) => AuthError(
        statusCode: json["status_code"],
        message: json["message"],
        errors:
            json["message"] == null ? null : Errors.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "errors": errors == null ? null : errors!.toJson(),
      };
}

class Errors {
  Errors({
    this.name,
    this.email,
    this.password,
    this.mobile,
    this.image,
    this.file,
    this.optionId,
    this.workingDays,
  });

  final List<String>? name;
  final List<String>? email;
  final List<String>? password;
  final List<String>? mobile;
  final List<String>? image;
  final List<String>? file;
  final List<String>? optionId;
  final List<String>? workingDays;

  Errors copyWith({
    List<String>? name,
    List<String>? email,
    List<String>? password,
    List<String>? mobile,
    List<String>? image,
    List<String>? file,
    List<String>? optionId,
    List<String>? workingDays,
  }) =>
      Errors(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        mobile: mobile ?? this.mobile,
        image: image ?? this.image,
        file: file ?? this.file,
        optionId: optionId ?? this.optionId,
        workingDays: workingDays ?? this.workingDays,
      );

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        name: json["name"] != null
            ? List<String>.from(json["name"].map((x) => x))
            : null,
        email: json["email"] != null
            ? List<String>.from(json["email"].map((x) => x))
            : null,
        password: json["password"] != null
            ? List<String>.from(json["password"].map((x) => x))
            : null,
        mobile: json["mobile"] != null
            ? List<String>.from(json["mobile"].map((x) => x))
            : null,
        image: json["image"] != null
            ? List<String>.from(json["image"].map((x) => x))
            : null,
        file: json["file"] != null
            ? List<String>.from(json["file"].map((x) => x))
            : null,
        optionId: json["option_id"] != null
            ? List<String>.from(json["option_id"].map((x) => x))
            : null,
        workingDays: json["working_days"] != null
            ? List<String>.from(json['working_days'].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "mobile": mobile,
        "image": image,
        "file": file,
        "option_id": optionId,
        "working_days": workingDays,
      };
}
