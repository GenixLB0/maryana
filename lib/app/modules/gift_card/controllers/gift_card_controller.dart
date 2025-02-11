import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:maryana/app/modules/services/api_service.dart';
import 'package:maryana/main.dart';

class GiftCardController extends GetxController {
  //TODO: Implement GiftCardController
  var sentTransactions = <SentTransaction>[].obs;
  var receivedTransactions = <ReceivedTransaction>[].obs;
  var loading = false.obs;
  var sent = true.obs;

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (userToken != null) {
      fetchTransactions();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchTransactions() async {
    loading.value = true;
    try {
      final response = await apiConsumer.get('gift-cards');
      if (response['status'] == 'success') {
        var sent = response['data']['sent'] as List;
        var received = response['data']['received'] as List;

        sentTransactions
            .assignAll(sent.map((e) => SentTransaction.fromJson(e)).toList());
        receivedTransactions.assignAll(
            received.map((e) => ReceivedTransaction.fromJson(e)).toList());
      } else {
        print('Failed to fetch transactions: ${response['message']}');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    } finally {
      loading.value = false;
    }
  }
}

class From {
  final int id;
  String firstName;
  String lastName;
  String? photo;
  String email;
  String? phone;
  String? dob;

  From({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.photo,
    required this.email,
    this.phone,
    this.dob,
  });

  factory From.fromJson(Map<String, dynamic> json) {
    return From(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      photo: json['avatar'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
    );
  }
}

class Transaction {
  final int? id;
  final String name;
  final String date;
  final double amount;
  final bool isReceived;
  final From? from;

  Transaction(
      {required this.id,
      required this.name,
      required this.date,
      required this.amount,
      required this.isReceived,
      required this.from});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      date: json['created_at'] ?? '',
      amount: double.parse(json['amount'] ?? '0'),
      isReceived: json['isReceived'] ?? false,
      from: From.fromJson(json['from']),
    );
  }
}

class SentTransaction {
  int? id;
  String? amount;
  int? status;
  String? balance;
  To? to;
  String? createdAt;
  String? lastUse;

  SentTransaction(
      {this.id,
      this.amount,
      this.status,
      this.balance,
      this.to,
      this.createdAt,
      this.lastUse});

  SentTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    status = json['status'];
    balance = json['balance'];
    to = json['to'] != null ? new To.fromJson(json['to']) : null;
    createdAt = json['created_at'];
    lastUse = json['last_use'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['balance'] = this.balance;
    if (this.to != null) {
      data['to'] = this.to!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['last_use'] = this.lastUse;
    return data;
  }
}

class To {
  int? id;
  String? firstName;
  String? lastName;
  Null? avatar;
  String? email;
  Null? phone;
  Null? dob;
  int? totalPoints;

  To(
      {this.id,
      this.firstName,
      this.lastName,
      this.avatar,
      this.email,
      this.phone,
      this.dob,
      this.totalPoints});

  To.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
    email = json['email'];
    phone = json['phone'];
    dob = json['dob'];
    totalPoints = json['total_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['dob'] = this.dob;
    data['total_points'] = this.totalPoints;
    return data;
  }
}

class ReceivedTransaction {
  int? id;
  String? amount;
  int? status;
  String? balance;
  To? from;
  String? createdAt;
  String? lastUse;

  ReceivedTransaction(
      {this.id,
      this.amount,
      this.status,
      this.balance,
      this.from,
      this.createdAt,
      this.lastUse});

  ReceivedTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    status = json['status'];
    balance = json['balance'];
    from = json['from'] != null ? new To.fromJson(json['from']) : null;
    createdAt = json['created_at'];
    lastUse = json['last_use'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['balance'] = this.balance;
    if (this.from != null) {
      data['from'] = this.from!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['last_use'] = this.lastUse;
    return data;
  }
}
