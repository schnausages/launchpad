import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:launchpad/models/app.dart';
import 'package:launchpad/models/user.dart';

class ActivityItem {
  final String message;
  final String type;
  final String userId;
  final String? iconImage;
  final String? externalink;
  final AppModel? mentionedApp;
  final DateTime dateAdded;
  final UserModel? userInfo;

  final bool? isFeatured;

  ActivityItem({
    required this.type,
    required this.message,
    required this.externalink,
    required this.dateAdded,
    this.mentionedApp,
    this.userInfo,
    required this.userId,
    required this.isFeatured,
    this.iconImage = '',
  });

  factory ActivityItem.fromJson(Map json) {
    UserModel user = UserModel.fromJson(json['user_info']);
    Timestamp dateAdded = json['date_added'];
    String type = json['type'];
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
    String message = json['text'];
    bool isFeatured = json['featured'] ?? false;

    DateTime _d = dateAdded.toDate();

    return ActivityItem(
      externalink: link,
      message: message,
      dateAdded: _d,
      userId: userId,
      type: type,
      mentionedApp: app,
      isFeatured: isFeatured,
      userInfo: user,
    );
  }

  static Map<String, dynamic> toJson(ActivityItem item) => {
        'user_info': UserModel.toJson(item.userInfo!),
        'date_added': item.dateAdded,
        'mentioned_app': item.mentionedApp != null
            ? AppModel.toJson(item.mentionedApp!)
            : null,
        'id': item.userId,
        'link': item.externalink,
        'text': item.message,
        'type': item.type,
        'featured': item.isFeatured
      };
  // UserModel userModel = UserModel.fromJson(json['app_owner_info']);
  // int replyCount = json['reply_count'] ?? 0;
}
// [ ] on add app
// [ on comment on app]
// [ on user join ]