import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/models/user.dart';

class PostModel {
  final String text;
  final String postId;
  final int replyCount;
  final String? iconImage;
  final String? externalink;
  final AppModel? mentionedApp;
  final DateTime dateAdded;
  final UserModel? userInfo;
  final String userId;
  final DocumentSnapshot? documentSnapshot;
  final bool? isFeatured;

  PostModel({
    required this.postId,
    required this.text,
    required this.userId,
    required this.externalink,
    required this.replyCount,
    required this.dateAdded,
    this.mentionedApp,
    this.userInfo,
    required this.isFeatured,
    this.documentSnapshot,
    this.iconImage = '',
  });

  factory PostModel.fromJson(
      Map json, String id, DocumentSnapshot documentSnapshot) {
    UserModel userModel = UserModel.fromJson(json['user_info']);
    Timestamp dateAdded = json['date_added'];
    ;
    late AppModel app;
    if (json['mentioned_app'] == null) {
      app = AppModel(name: '', launchpadAppId: '', appOwnerId: '');
    } else {
      app = AppModel(
          name: json['mentioned_app']['app_name'],
          launchpadAppId: json['mentioned_app']['launchpad_app_id'],
          appCategory: json['mentioned_app']['app_category'],
          appOwnerId: '');
    }

    String userId = json['id'];
    String link = json['link'] ?? '';
    String text = json['text'];
    int replyCount = json['reply_count'] ?? 0;
    bool isFeatured = json['featured'] ?? false;
    String postId = id;
    DateTime _d = dateAdded.toDate();
    DocumentSnapshot snapshot = documentSnapshot;
    return PostModel(
        userId: userId,
        externalink: link,
        text: text,
        dateAdded: _d,
        mentionedApp: app,
        postId: postId,
        replyCount: replyCount,
        isFeatured: isFeatured,
        userInfo: userModel,
        documentSnapshot: snapshot);
  }

  static Map<String, dynamic> toJson(PostModel p) => {
        'id': p.userId,
        'user_info': UserModel.toJson(p.userInfo!),
        'date_added': p.dateAdded,
        'mentioned_app': AppModel.toJson(p.mentionedApp!),
        'link': p.externalink,
        'text': p.text,
        'reply_count': p.replyCount,
        'featured': p.isFeatured
      };
  // UserModel userModel = UserModel.fromJson(json['app_owner_info']);
  // int replyCount = json['reply_count'] ?? 0;
}
