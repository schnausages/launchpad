import 'package:launchpad/models/user.dart';

class AppModel {
  final String name;
  final String launchpadAppId;
  final String? iconImage;
  final String? description;
  final String? appOwnerId;
  final String? iosTestLink;
  final String? androidTestLink;

  final String? appStoreLink;
  final String? playStoreLink;
  final UserModel? appOwnerInfo;
  final bool? isFeatured;
  final List? seeking;
  final bool? allowAndroidTesters;
  final bool? allowiOSTesters;
  final String? appCategory;
  final String? alternativeExternalLink;

  AppModel(
      {required this.name,
      required this.launchpadAppId,
      this.appOwnerInfo,
      this.appCategory,
      this.description,
      this.iosTestLink,
      this.androidTestLink,
      required this.appOwnerId,
      this.allowAndroidTesters = false,
      this.allowiOSTesters = false,
      this.isFeatured,
      this.seeking,
      this.alternativeExternalLink = '',
      this.iconImage = '',
      this.appStoreLink = '',
      this.playStoreLink = ''});

  factory AppModel.fromJson(Map json) {
    UserModel userModel = UserModel.fromJson(json['app_owner_info']);

    String name = json['app_name'];
    String description = json['app_description'] ?? '';
    String appOwnerId = json['app_owner_id'];
    String appId = json['launchpad_app_id'];
    String appCategory = json['app_category'] ?? '';
    // int replyCount = json['reply_count'] ?? 0;
    String imageUrl = json['app_image_url'] ?? '';
    String appStoreLink = json['app_store_link'] ?? '';
    String playStoreLink = json['play_store_link'] ?? '';
    String testLink = json['ios_test_link'] ?? '';
    String androidTestLink = json['android_test_link'] ?? '';
    List seeking = json['seeking'] ?? [];
    bool isFeatured = json['featured'] ?? false;
    bool allowiOS = json['allow_ios'] ?? false;
    bool allowAndroid = json['allow_android'] ?? true;
    String externalLink = json['external_link'] ?? '';
    // bool inResults = json['in_results'] ?? false;

    return AppModel(
        name: name,
        launchpadAppId: appId,
        iconImage: imageUrl,
        isFeatured: isFeatured,
        appCategory: appCategory,
        // replyCount: replyCount,
        alternativeExternalLink: externalLink,
        appOwnerId: appOwnerId,
        description: description,
        allowAndroidTesters: allowAndroid,
        allowiOSTesters: allowiOS,
        androidTestLink: androidTestLink,
        appStoreLink: appStoreLink,
        seeking: seeking,
        appOwnerInfo: userModel,
        iosTestLink: testLink,
        playStoreLink: playStoreLink);
  }
  static Map<String, dynamic> toJson(AppModel app) => {
        'app_owner_info': UserModel.toJson(app.appOwnerInfo!),
        'launchpad_app_id': app.launchpadAppId,
        'app_name': app.name,
        'app_store_link': app.appStoreLink ?? '',
        'play_store_link': app.playStoreLink ?? '',
        'app_image_url': '',
        'ios_test_link': app.iosTestLink ?? '',
        'android_test_link': app.androidTestLink ?? '',
        'app_category': app.appCategory ?? '',
        'app_owner_id': app.appOwnerId ?? '',
        'app_description': app.description ?? '',
        'seeking': app.seeking ?? [],
        'featured': app.isFeatured ?? false,
        'allow_ios': app.allowiOSTesters ?? false,
        'allow_android': app.allowAndroidTesters ?? false,
        'external_link': app.alternativeExternalLink ?? '',
      };
}
