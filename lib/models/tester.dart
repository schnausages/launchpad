import 'package:cloud_firestore/cloud_firestore.dart';

class TesterModel {
  final String username;
  final String userId;
  final String email;
  final DateTime? dateJoined;
  final bool isVerifiedTester;
  final bool isAndroidTester;

  TesterModel({
    required this.email,
    required this.username,
    required this.userId,
    required this.isAndroidTester,
    this.dateJoined,
    required this.isVerifiedTester,
  });

  factory TesterModel.fromJson(Map json) {
    String username = json['username'] ?? 'flutter-dev6969';
    String userEmail = json['email'] ?? 'mail@mail.com';
    String userId = json['id'];
    Timestamp dateAdded = json['date_joined'] ?? Timestamp.now();
    bool verified = json['verified_tester'];
    bool isAndroidTester = json['android_tester'];
    DateTime _d = dateAdded.toDate();

    return TesterModel(
      email: userEmail,
      userId: userId,
      isAndroidTester: isAndroidTester,
      isVerifiedTester: verified,
      username: username,
      dateJoined: _d,
    );
  }
}
