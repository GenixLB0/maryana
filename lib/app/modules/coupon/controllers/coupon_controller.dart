import 'package:get/get.dart';
import 'package:maryana/main.dart';

class CouponController extends GetxController {
  var coupons = <Coupon>[].obs;
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    loading.value = true;
    try {
      final response = await apiConsumer.get('coupons');
      if (response['status'] == 'success') {
        var couponList = response['data']['coupons'] as List;
        coupons.assignAll(couponList.map((e) => Coupon.fromJson(e)).toList());
      } else {
        print('Failed to fetch coupons: ${response['message']}');
      }
    } catch (e) {
      print('Error fetching coupons: $e');
    } finally {
      loading.value = false;
    }
  }
}

class ExpireAt {
  final int? day;
  final int? month;

  ExpireAt({this.day, this.month});

  factory ExpireAt.fromJson(Map<String, dynamic> json) {
    return ExpireAt(
      day: json['day'],
      month: json['month'],
    );
  }
}

class Coupon {
  final int id;
  final String name;
  final String code;
  final double? amount;
  final ExpireAt? expireAt;

  Coupon({
    required this.id,
    required this.name,
    required this.code,
    this.amount,
    this.expireAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString())
          : null,
      expireAt: json['expire_at'] != null
          ? ExpireAt.fromJson(json['expire_at'])
          : null,
    );
  }
}
