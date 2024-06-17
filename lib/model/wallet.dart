import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  final String userId;
  double balance;

  Wallet({required this.userId, required this.balance});

  Wallet.fromJson(Map<String, Object?> json)
      : this(
    userId: json['userId'] as String,
    balance: json['balance'] as double,
  );

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'balance': balance,
    };
  }
}
