import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:launchpad/models/user.dart';
import 'package:launchpad/pages/tab_bar_screen.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/inputs/base_app_bar.dart';
import 'package:launchpad/widgets/user_profile_detail_body.dart';
import 'package:get/get.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<UserModel> _fetchUserFuture;

  @override
  void initState() {
    _fetchUserFuture =
        FirestoreServices.fetchUserInfo(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppStyles.backgroundColor,
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child: BaseAppBar(
              showSearch: true,
              showUser: false,
              showHome: true,
              isMobileWeb: PlatformServices.isWebMobile,
              onLeadPressAction: () {
                Get.to(() => TabBarScreen());
              },
            )),
        body: FutureBuilder(
            future: _fetchUserFuture,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return UserProfileBody(
                  userData: snapshot.data!,
                  isMobileWeb: PlatformServices.isWebMobile ? true : false,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            })),
      ),
    );
  }
}
