import 'package:cloud_firestore/cloud_firestore.dart';

class WalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createWallet(String userId) async {
    await _firestore.collection('wallets').doc(userId).set({
      'balance': 0.0,
    });
  }


  Future<bool> userHasWallet(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('wallets').doc(userId).get();
    return doc.exists;
  }

  Future<void> updateWalletBalance(String userId, double amount) async {
    DocumentReference walletRef = _firestore.collection('wallets').doc(userId);
    _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(walletRef);
      if (!snapshot.exists) {
        throw Exception("Wallet does not exist!");
      }

      double newBalance = snapshot['balance'] + amount;
      transaction.update(walletRef, {'balance': newBalance});
    });
  }

  Future<double> getWalletBalance(String userId) async {
    DocumentSnapshot snapshot =
    await _firestore.collection('wallets').doc(userId).get();
    if (snapshot.exists) {
      return snapshot['balance'];
    } else {
      throw Exception("Wallet not found!");
    }
  }
}
