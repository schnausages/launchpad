import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String userId;
  final String email;
  final int? bitCount;
  // final String launchpadAppId;
  final DateTime? dateJoined;
  final String? pfpUrl;
  // final String? appStoreLink;
  // final String? playStoreLink;

  UserModel({
    required this.email,
    required this.username,
    required this.userId,
    this.dateJoined,
    // required this.launchpadAppId,
    this.pfpUrl = '',
    this.bitCount = 0,
    // this.appStoreLink = '',
    // this.playStoreLink = ''
  });

  factory UserModel.fromJson(Map json) {
    String username = json['username'] ?? 'flutter-dev6969';
    String userEmail = json['email'] ?? 'mail@mail.com';
    int bitCount = json['dev_bits'] ?? 0;
    String userId = json['id'];
    Timestamp dateAdded = json['date_joined'] ?? Timestamp.now();
    DateTime _d = dateAdded.toDate();
    // String appId = json['launchpad_app_id'];
    String imageUrl = json['pfp_url'] ?? 'nopfp.jpg';
    // String appStoreLink = json['app_store_id'] ?? '';
    // String playStoreLink = json['play_store_id'] ?? '';

    return UserModel(
      email: userEmail,
      userId: userId,
      username: username,
      bitCount: bitCount,
      dateJoined: _d,
      pfpUrl: imageUrl,
      // appStoreLink: appStoreLink,
      // playStoreLink: playStoreLink
    );
  }

  UserModel copyWith({
    String? userEmail,
    String? userId,
    String? username,
  }) =>
      UserModel(
        email: userEmail ?? this.email,
        username: username ?? this.username,
        userId: this.userId,
      );

  // Timestamp dateAdded = json['date_joined'] ?? Timestamp.now();
  // DateTime _d = dateAdded.toDate();

  static Map<String, dynamic> toJson(UserModel user) => {
        'id': user.userId,
        'username': user.username,
        'email': user.email,
        'date_joined': user.dateJoined ?? DateTime.now(),
        'dev_bits': user.bitCount ?? 0,
        'pfp_url': user.pfpUrl ?? '',
      };
}
