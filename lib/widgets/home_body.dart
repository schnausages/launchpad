// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/models/post.dart';
import 'package:launchpad/models/user.dart';
import 'package:launchpad/services/feed_service.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/services/storage.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/home_screen/home_page_posts.dart';
import 'package:launchpad/widgets/misc/base_snackbar.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';
import 'package:launchpad/widgets/inputs/modal_sheet.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController replyController = TextEditingController();

  final String currentUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void dispose() {
    replyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var cart = context.watch<FeedService>();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 25,
            ),
            child: Row(
              children: [
                const Text('Posts', style: AppStyles.poppinsBold22),
                const SizedBox(width: 10),
                BasicButton(
                    isMobile: PlatformServices.isWebMobile,
                    onClick: () {
                      buildModalSheet(context,
                          title: "Create a new post!",
                          controller: replyController,
                          isCreatePost: true, onSubmitPress: (link, app) async {
                        // add post
                        Map<String, dynamic> _userProfile =
                            await AppStorage.returnProfile();
                        UserModel _u = UserModel.fromJson(_userProfile);
                        dynamic _mApp = app.launchpadAppId.isEmpty ? null : app;
                        DocumentReference<Map<String, dynamic>> _docRef =
                            await FirestoreServices.createPost(
                                user: _u,
                                link: link,
                                mentionedApp: _mApp,
                                text: replyController.text,
                                ctx: context);
                        Navigator.pop(context);
                        PostModel _p = PostModel(
                            postId: _docRef.id,
                            text: replyController.text,
                            userInfo: _u,
                            mentionedApp: _mApp != null
                                ? AppModel(
                                    name: _mApp.name,
                                    launchpadAppId: _mApp.launchpadAppId,
                                    appOwnerId: _u.userId,
                                    appCategory: _mApp.appCategory)
                                : AppModel(
                                    name: '',
                                    launchpadAppId: '',
                                    appOwnerId: ''),
                            userId: _u.userId,
                            externalink: link,
                            replyCount: 0,
                            dateAdded: DateTime.now(),
                            documentSnapshot: null,
                            isFeatured: false);

                        try {
                          Provider.of<FeedService>(context, listen: false)
                              .addPost(_p);
                          ScaffoldMessenger.of(context).showSnackBar(
                              BaseSnackbar.buildSnackBar(context,
                                  message: 'Post sent. 1 Bit earned!',
                                  success: true));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              BaseSnackbar.buildSnackBar(context,
                                  message: '${e.toString()}', success: false));
                        }
                      });
                    },
                    label: 'NEW POST'),
              ],
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(top: 15), child: HomePagePosts()),
          const SizedBox(height: 100),
        ],
      ),
    );
    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       Column(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.only(left: 15, top: 30, bottom: 15),
    //             child: Row(
    //               children: [
    //                 const Text('Apps', style: AppStyles.poppinsBold22),
    //                 const SizedBox(width: 10),
    //                 Padding(
    //                   padding: const EdgeInsets.only(left: 4.0),
    //                   child: BasicButton(
    //                       isMobile: PlatformServices.isWebMobile,
    //                       onClick: () async {
    //                         UserModel _profData =
    //                             await FirestoreServices.fetchUserInfo(
    //                                 currentUid);
    //                         AppModel _newApp = await Navigator.of(context).push(
    //                             MaterialPageRoute(
    //                                 builder: (ctx) =>
    //                                     AddApplicationPage(user: _profData)));
    //                         if (!mounted) return;
    //                         if (_newApp.launchpadAppId.isNotEmpty) {
    //                           ScaffoldMessenger.of(context).showSnackBar(
    //                               BaseSnackbar.buildSnackBar(context,
    //                                   message: 'App added. 3 bits earned!',
    //                                   success: true));
    //                           // _fetchApps =
    //                           //     FirestoreServices.getAllApplications();
    //                           setState(() {});
    //                         }
    //                       },
    //                       label: 'NEW APP'),
    //                 ),
    //                 const Spacer(),
    //                 Padding(
    //                   padding: EdgeInsets.only(right: isWebMobile ? 8 : 40),
    //                   child: InkWell(
    //                     splashColor: Colors.transparent,
    //                     highlightColor: Colors.transparent,
    //                     onTap: () {
    //                       setState(() {
    //                         _showActivity = !_showActivity;
    //                       });
    //                     },
    //                     child: Container(
    //                       decoration: BoxDecoration(
    //                           color: AppStyles.panelColor,
    //                           borderRadius: BorderRadius.circular(4)),
    //                       padding: const EdgeInsets.symmetric(
    //                           horizontal: 8, vertical: 4),
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                         children: [
    //                           if (_showActivity)
    //                             const Icon(Icons.visibility,
    //                                 size: 12, color: Colors.white),
    //                           if (!_showActivity)
    //                             const Icon(Icons.visibility_off_rounded,
    //                                 size: 13, color: Colors.white70),
    //                           Text(' ACTIVITY',
    //                               style: AppStyles.poppinsBold22.copyWith(
    //                                   fontSize: !_showActivity ? 15 : 16,
    //                                   color: !_showActivity
    //                                       ? Colors.white70
    //                                       : Colors.white)),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //           if (_showActivity)
    //             const Row(
    //               children: [
    //                 Padding(
    //                   padding: EdgeInsets.only(top: 15, left: 15),
    //                   child: ActivityFeedBox(),
    //                 ),
    //               ],
    //             ),
    //           if (!_showActivity)
    //             const Padding(
    //                 padding: EdgeInsets.only(top: 15, left: 15),
    //                 child: HomeAppsExplore()),
    //         ],
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(
    //           top: 30,
    //           left: 25,
    //         ),
    //         child: Row(
    //           children: [
    //             if (_showPosts)
    //               Row(
    //                 children: [
    //                   const Text('Posts', style: AppStyles.poppinsBold22),
    //                   const SizedBox(width: 10),
    //                   BasicButton(
    //                       isMobile: PlatformServices.isWebMobile,
    //                       onClick: () {
    //                         buildModalSheet(context,
    //                             title: "Create a new post!",
    //                             controller: replyController,
    //                             isCreatePost: true,
    //                             onSubmitPress: (link, app) async {
    //                           // add post
    //                           Map<String, dynamic> _userProfile =
    //                               await AppStorage.returnProfile();
    //                           UserModel _u = UserModel.fromJson(_userProfile);
    //                           dynamic _mApp =
    //                               app.launchpadAppId.isEmpty ? null : app;
    //                           DocumentReference<Map<String, dynamic>> _docRef =
    //                               await FirestoreServices.createPost(
    //                                   user: _u,
    //                                   link: link,
    //                                   mentionedApp: _mApp,
    //                                   text: replyController.text,
    //                                   ctx: context);
    //                           Navigator.pop(context);
    //                           PostModel _p = PostModel(
    //                               postId: _docRef.id,
    //                               text: replyController.text,
    //                               userInfo: _u,
    //                               mentionedApp: _mApp != null
    //                                   ? AppModel(
    //                                       name: _mApp.name,
    //                                       launchpadAppId: _mApp.launchpadAppId,
    //                                       appOwnerId: _u.userId,
    //                                       appCategory: _mApp.appCategory)
    //                                   : AppModel(
    //                                       name: '',
    //                                       launchpadAppId: '',
    //                                       appOwnerId: ''),
    //                               userId: _u.userId,
    //                               externalink: link,
    //                               replyCount: 0,
    //                               dateAdded: DateTime.now(),
    //                               documentSnapshot: null,
    //                               isFeatured: false);

    //                           try {
    //                             Provider.of<FeedService>(context, listen: false)
    //                                 .addPost(_p);
    //                             ScaffoldMessenger.of(context).showSnackBar(
    //                                 BaseSnackbar.buildSnackBar(context,
    //                                     message: 'Post sent. 1 Bit earned!',
    //                                     success: true));
    //                           } catch (e) {
    //                             ScaffoldMessenger.of(context).showSnackBar(
    //                                 BaseSnackbar.buildSnackBar(context,
    //                                     message: '${e.toString()}',
    //                                     success: false));
    //                           }
    //                         });
    //                       },
    //                       label: 'NEW POST'),
    //                 ],
    //               ),
    //             if (!_showPosts)
    //               const Row(
    //                 children: [
    //                   Text('Top Developers', style: AppStyles.poppinsBold22),
    //                   SizedBox(width: 10),
    //                 ],
    //               ),
    //             const Spacer(),
    //             Padding(
    //               padding: EdgeInsets.only(right: isWebMobile ? 8 : 40),
    //               child: InkWell(
    //                 splashColor: Colors.transparent,
    //                 highlightColor: Colors.transparent,
    //                 onTap: () {
    //                   setState(() {
    //                     _showPosts = !_showPosts;
    //                   });
    //                 },
    //                 child: Container(
    //                   decoration: BoxDecoration(
    //                       color: AppStyles.panelColor,
    //                       borderRadius: BorderRadius.circular(4)),
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 8, vertical: 4),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: [
    //                       if (!_showPosts)
    //                         const Icon(Icons.leaderboard_rounded,
    //                             size: 12, color: Colors.white),
    //                       if (_showPosts)
    //                         const Icon(Icons.leaderboard_rounded,
    //                             size: 13, color: Colors.white70),
    //                       Text(' TOP DEVS',
    //                           style: AppStyles.poppinsBold22.copyWith(
    //                               fontSize: _showPosts ? 15 : 16,
    //                               color: _showPosts
    //                                   ? Colors.white70
    //                                   : Colors.white)),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //       if (!_showPosts) const TopDevelopers(),
    //       if (_showPosts)
    //         const Padding(
    //             padding: EdgeInsets.only(top: 15), child: HomePagePosts()),
    //       const SizedBox(height: 100),
    //     ],
    //   ),
    // );
  }
}
