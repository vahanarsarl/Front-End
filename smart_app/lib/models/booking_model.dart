import 'product_model.dart';

class Booking {
  final String id;
  final String userId;
  final String productId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product? product;

  Booking({
    required this.id,
    required this.userId,
    required this.productId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['userId'],
      productId: json['productId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'],
      totalPrice: json['totalPrice'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'product': product?.toJson(),
    };
  }
}