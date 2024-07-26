import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:maryana/main.dart';

class GiftCardController extends GetxController {
  //TODO: Implement GiftCardController
  var sentTransactions = <Transaction>[].obs;
  var receivedTransactions = <Transaction>[].obs;
  var loading = false.obs;
  var sent = true.obs;
 
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
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
            .assignAll(sent.map((e) => Transaction.fromJson(e)).toList());
        receivedTransactions
            .assignAll(received.map((e) => Transaction.fromJson(e)).toList());
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
  final String name;
  final String date;
  final double amount;
  final bool isReceived;
  final From? from;

  Transaction(
      {required this.name,
      required this.date,
      required this.amount,
      required this.isReceived,
      required this.from});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      name: json['name'] ?? '',
      date: json['created_at'] ?? '',
      amount: double.parse(json['amount'] ?? '0'),
      isReceived: json['isReceived'] ?? false,
      from: From.fromJson(json['from']),
    );
  }
}
