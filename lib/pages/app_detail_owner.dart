// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/models/post.dart';
import 'package:launchpad/models/tester.dart';
import 'package:launchpad/models/user.dart';
import 'package:launchpad/pages/tab_bar_screen.dart';
import 'package:launchpad/services/app_comments_service.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/services/storage.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/app_detail_header.dart';
import 'package:launchpad/widgets/inputs/base_app_bar.dart';
import 'package:launchpad/widgets/misc/base_snackbar.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';
import 'package:launchpad/widgets/post_widget.dart';
import 'package:launchpad/widgets/inputs/modal_sheet.dart';
import 'package:launchpad/widgets/test_user_tile.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AppDetailOwnerPage extends StatefulWidget {
  final AppModel app;
  final bool ownsApp;

  const AppDetailOwnerPage(
      {super.key, required this.app, this.ownsApp = false});

  @override
  State<AppDetailOwnerPage> createState() => _AppDetailOwnerPageState();
}

class _AppDetailOwnerPageState extends State<AppDetailOwnerPage> {
  TextEditingController replyController = TextEditingController();

  // late Future<AppModel> _fetchApp;
  late Future _fetchComments;
  late Future<List<TesterModel>> _getTesters;
  late Future<AppModel> _fetchAppInfo;
  bool _showComments = true;

  final String currentUid = FirebaseAuth.instance.currentUser!.uid;
  final bool isWebMobile = PlatformServices.isWebMobile;

  @override
  void initState() {
    // _fetchApp = FirestoreServices.getAppById(appId: widget.app.launchpadAppId);
    // _fetchComments = FirestoreServices.getCommentsOnApplication(
    //     appId: widget.app.launchpadAppId);
    _fetchComments = Provider.of<AppCommentsService>(context, listen: false)
        .loadAppPosts(widget.app.launchpadAppId);
    _fetchAppInfo =
        FirestoreServices.getAppById(appId: widget.app.launchpadAppId);
    _getTesters =
        FirestoreServices.getAppTesters(appId: widget.app.launchpadAppId);

    super.initState();
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _s = MediaQuery.of(context).size;
    final String appname = widget.app.name;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: AppStyles.backgroundColor,
          appBar: PreferredSize(
              preferredSize: Size(double.infinity, 60),
              child: BaseAppBar(
                showSearch: false,
                showUser: false,
                showHome: true,
                onLeadPressAction: () {
                  Provider.of<AppCommentsService>(context, listen: false)
                      .clearFeed();
                  Get.to(() => TabBarScreen());
                },
                isMobileWeb: isWebMobile,
              )),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: _fetchAppInfo,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return AppDetailHeader(
                            app: snapshot.data!, isMobileWeb: isWebMobile);
                      } else {
                        return SizedBox();
                      }
                    }),
                if (widget.ownsApp)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showComments = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _showComments
                                    ? AppStyles.actionButtonColor
                                    : Colors.white24),
                            child: Text('Comments',
                                style: AppStyles.poppinsBold22
                                    .copyWith(fontSize: 18)),
                          ),
                        ),
                        SizedBox(width: 25),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showComments = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: !_showComments
                                    ? AppStyles.actionButtonColor
                                    : Colors.white24),
                            child: Text('Testers',
                                style: AppStyles.poppinsBold22
                                    .copyWith(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.ownsApp && !_showComments)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: SizedBox(
                      width: _s.width,
                      child: FutureBuilder(
                          future: _getTesters,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 30),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppStyles.panelColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.all(20),
                                    child: Text('No testers',
                                        style: AppStyles.poppinsBold22),
                                  ),
                                );
                              } else {
                                return ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context)
                                      .copyWith(scrollbars: false),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: isWebMobile ? 10 : 160),
                                            child: Text('Verify',
                                                style: AppStyles.poppinsBold22
                                                    .copyWith(fontSize: 14)),
                                          )
                                        ],
                                      ),
                                      ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, i) {
                                            return TestUserTile(
                                                testUser: snapshot.data![i],
                                                appId:
                                                    widget.app.launchpadAppId);
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 40),
                                        child: BasicButton(
                                            isMobile: isWebMobile,
                                            onClick: () async {
                                              List<String> _emails = [];
                                              snapshot.data!.forEach((tester) {
                                                _emails.add(tester.email);
                                              });

                                              String _e = _emails
                                                  .toString()
                                                  .removeAllWhitespace;
                                              String _e2 = _e.substring(
                                                  1, _e.length - 1);

                                              await Clipboard.setData(
                                                  ClipboardData(text: _e2));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(BaseSnackbar
                                                      .buildSnackBar(context,
                                                          message:
                                                              'Emails copied',
                                                          success: true));
                                            },
                                            label: 'Copy All'),
                                      )
                                    ],
                                  ),
                                );
                              }
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: AppStyles.actionButtonColor,
                              ));
                            }
                          }),
                    ),
                  ),
                if (_showComments)
                  Padding(
                    padding:
                        EdgeInsets.only(top: 30, left: isWebMobile ? 10 : 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Comments',
                                style: AppStyles.poppinsBold22
                                    .copyWith(fontSize: 20)),
                            SizedBox(width: 10),
                            BasicButton(
                                isMobile: isWebMobile,
                                onClick: () {
                                  buildModalSheet(context,
                                      title: "Comment on $appname",
                                      controller: replyController,
                                      isCreatePost: false,
                                      onSubmitPress: (x, y) async {
                                    // add post
                                    Map<String, dynamic> _userProfile =
                                        await AppStorage.returnProfile();
                                    UserModel _u =
                                        UserModel.fromJson(_userProfile);
                                    DocumentReference<Map<String, dynamic>>
                                        _ref =
                                        await FirestoreServices.commentOnApp(
                                            text: replyController.text,
                                            user: _u,
                                            externalLink: x,
                                            app: widget.app,
                                            replyToAppid:
                                                widget.app.launchpadAppId);
                                    Navigator.of(context).pop();
                                    PostModel _p = PostModel(
                                        postId: _ref.id,
                                        text: replyController.text,
                                        userInfo: _u,
                                        mentionedApp: AppModel(
                                            name: '',
                                            launchpadAppId: '',
                                            appOwnerId: ''),
                                        userId: _u.userId,
                                        externalink: x,
                                        iconImage: '',
                                        documentSnapshot: null,
                                        replyCount: 0,
                                        dateAdded: DateTime.now(),
                                        isFeatured: false);
                                    try {
                                      Provider.of<AppCommentsService>(context,
                                              listen: false)
                                          .addPost(_p);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          BaseSnackbar.buildSnackBar(context,
                                              message:
                                                  'Reply sent. 1 Bit earned!',
                                              success: true));
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              BaseSnackbar.buildSnackBar(
                                                  context,
                                                  message: '${e.toString()}',
                                                  success: false));
                                    }
                                  });
                                },
                                label: 'COMMENT')
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: _s.width * .9,
                                  child: Consumer<AppCommentsService>(
                                    builder: (context, service, _) {
                                      if (service.appPosts.isEmpty) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18),
                                          decoration: BoxDecoration(
                                              color: AppStyles.panelColor,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Center(
                                              child: Text('No comments yet',
                                                  style: AppStyles.poppinsBold22
                                                      .copyWith(fontSize: 18))),
                                        );
                                      } else {
                                        return ScrollConfiguration(
                                          behavior:
                                              ScrollConfiguration.of(context)
                                                  .copyWith(scrollbars: false),
                                          child: ListView.builder(
                                              itemCount:
                                                  service.appPosts.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, i) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: PlatformServices
                                                              .isWebMobile
                                                          ? 10
                                                          : 45,
                                                      right: PlatformServices
                                                              .isWebMobile
                                                          ? 10
                                                          : 220),
                                                  child: PostWidget(
                                                      appView: true,
                                                      appId: widget
                                                          .app.launchpadAppId,
                                                      currentUserId: currentUid,
                                                      isWeb: PlatformServices
                                                              .isWebMobile
                                                          ? false
                                                          : true,
                                                      post: service.appPosts[i],
                                                      onDeletePress: () async {
                                                        await FirestoreServices
                                                            .deleteAppComment(
                                                                commentDocId:
                                                                    service
                                                                        .appPosts[
                                                                            i]
                                                                        .postId,
                                                                appId: widget
                                                                    .app
                                                                    .launchpadAppId);
                                                        service.removePost(
                                                            service
                                                                .appPosts[i]);
                                                      },
                                                      onSubReplyPress:
                                                          (username) {
                                                        buildModalSheet(context,
                                                            title:
                                                                "Reply to ${username}'s comment",
                                                            controller:
                                                                replyController,
                                                            onSubmitPress:
                                                                (x, y) async {
                                                          // add post
                                                          Map<String, dynamic>
                                                              _userProfile =
                                                              await AppStorage
                                                                  .returnProfile();
                                                          UserModel _u =
                                                              UserModel.fromJson(
                                                                  _userProfile);
                                                          String _comment =
                                                              '@$username  ${replyController.text}';
                                                          try {
                                                            await FirestoreServices.replyToAppComment(
                                                                user: _u,
                                                                text: _comment,
                                                                commentDocId:
                                                                    service
                                                                        .appPosts[
                                                                            i]
                                                                        .postId,
                                                                replyUnderAppId:
                                                                    widget.app
                                                                        .launchpadAppId);
                                                          } catch (e) {
                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(BaseSnackbar
                                                                    .buildSnackBar(
                                                                        context,
                                                                        message:
                                                                            'Failed to send',
                                                                        success:
                                                                            false));
                                                          }
                                                          Navigator.of(context)
                                                              .pop();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(BaseSnackbar
                                                                  .buildSnackBar(
                                                                      context,
                                                                      message:
                                                                          'Reply sent',
                                                                      success:
                                                                          true));
                                                        });
                                                      },
                                                      onReplyPress: () {
                                                        buildModalSheet(context,
                                                            title:
                                                                "Reply to ${service.appPosts[i].userInfo!.username}'s post",
                                                            controller:
                                                                replyController,
                                                            onSubmitPress:
                                                                (x, y) async {
                                                          // add post
                                                          Map<String, dynamic>
                                                              _userProfile =
                                                              await AppStorage
                                                                  .returnProfile();
                                                          UserModel _u =
                                                              UserModel.fromJson(
                                                                  _userProfile);
                                                          await FirestoreServices
                                                              .replyToAppComment(
                                                                  user: _u,
                                                                  text:
                                                                      replyController
                                                                          .text,
                                                                  replyUnderAppId:
                                                                      widget.app
                                                                          .launchpadAppId,
                                                                  commentDocId: service
                                                                      .appPosts[
                                                                          i]
                                                                      .postId);

                                                          Navigator.of(context)
                                                              .pop();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(BaseSnackbar
                                                                  .buildSnackBar(
                                                                      context,
                                                                      message:
                                                                          'Reply sent',
                                                                      success:
                                                                          true));
                                                          // reply to post
                                                        });
                                                      }),
                                                );
                                              }),
                                        );
                                      }
                                    },
                                  )

                                  // FutureBuilder(
                                  //     future: _fetchComments,
                                  //     builder: (context, snapshot) {
                                  //       if (snapshot.connectionState ==
                                  //               ConnectionState.done &&
                                  //           snapshot.hasData) {
                                  //         return ScrollConfiguration(
                                  //           behavior:
                                  //               ScrollConfiguration.of(context)
                                  //                   .copyWith(scrollbars: false),
                                  //           child: ListView.builder(
                                  //               itemCount: snapshot.data!.length,
                                  //               shrinkWrap: true,
                                  //               physics:
                                  //                   const NeverScrollableScrollPhysics(),
                                  //               scrollDirection: Axis.vertical,
                                  //               itemBuilder: (context, i) {
                                  //                 return PostWidget(
                                  //                     currentUserId: currentUid,
                                  //                     appId:
                                  //                         widget.app.launchpadAppId,
                                  //                     isWeb: !isWebMobile,
                                  //                     post: snapshot.data![i],
                                  //                     appView: true,
                                  //                     onDeletePress: () async {
                                  //                       await FirestoreServices
                                  //                           .deleteAppComment(
                                  //                               commentDocId:
                                  //                                   snapshot
                                  //                                       .data![i]
                                  //                                       .postId,
                                  //                               appId: widget.app
                                  //                                   .launchpadAppId);
                                  //                       snapshot.data!.removeAt(i);
                                  //                       setState(() {});
                                  //                     },
                                  //                     onSubReplyPress: (username) {
                                  //                       buildModalSheet(context,
                                  //                           title:
                                  //                               "Reply to ${username}'s comment",
                                  //                           controller:
                                  //                               replyController,
                                  //                           onSubmitPress:
                                  //                               (x, y) async {
                                  //                         // add post
                                  //                         Map<String, dynamic>
                                  //                             _userProfile =
                                  //                             await AppStorage
                                  //                                 .returnProfile();
                                  //                         UserModel _u =
                                  //                             UserModel.fromJson(
                                  //                                 _userProfile);
                                  //                         String _comment =
                                  //                             '@$username  ${replyController.text}';
                                  //                         try {
                                  //                           await FirestoreServices
                                  //                               .replyToAppComment(
                                  //                                   user: _u,
                                  //                                   text: _comment,
                                  //                                   commentDocId:
                                  //                                       snapshot
                                  //                                           .data![
                                  //                                               i]
                                  //                                           .postId,
                                  //                                   replyUnderAppId:
                                  //                                       widget.app
                                  //                                           .launchpadAppId);
                                  //                         } catch (e) {
                                  //                           Navigator.pop(context);
                                  //                           ScaffoldMessenger.of(
                                  //                                   context)
                                  //                               .showSnackBar(BaseSnackbar
                                  //                                   .buildSnackBar(
                                  //                                       context,
                                  //                                       message:
                                  //                                           'Failed to send',
                                  //                                       success:
                                  //                                           false));
                                  //                         }
                                  //                         Navigator.of(context)
                                  //                             .pop();
                                  //                         ScaffoldMessenger.of(
                                  //                                 context)
                                  //                             .showSnackBar(BaseSnackbar
                                  //                                 .buildSnackBar(
                                  //                                     context,
                                  //                                     message:
                                  //                                         'Reply sent',
                                  //                                     success:
                                  //                                         true));
                                  //                         // reply to post
                                  //                       });
                                  //                       // .then((value) =>
                                  //                       //     replyController.clear()
                                  //                       //     );
                                  //                     },
                                  //                     onReplyPress: () {
                                  //                       buildModalSheet(context,
                                  //                           title:
                                  //                               "Reply to ${snapshot.data![i].userInfo!.username}'s post",
                                  //                           controller:
                                  //                               replyController,
                                  //                           onSubmitPress:
                                  //                               (x, y) async {
                                  //                         // add post
                                  //                         Map<String, dynamic>
                                  //                             _userProfile =
                                  //                             await AppStorage
                                  //                                 .returnProfile();
                                  //                         UserModel _u =
                                  //                             UserModel.fromJson(
                                  //                                 _userProfile);
                                  //                         await FirestoreServices
                                  //                             .replyToAppComment(
                                  //                                 user: _u,
                                  //                                 text:
                                  //                                     replyController
                                  //                                         .text,
                                  //                                 replyUnderAppId:
                                  //                                     widget.app
                                  //                                         .launchpadAppId,
                                  //                                 commentDocId:
                                  //                                     snapshot
                                  //                                         .data![i]
                                  //                                         .postId);

                                  //                         Navigator.of(context)
                                  //                             .pop();
                                  //                         ScaffoldMessenger.of(
                                  //                                 context)
                                  //                             .showSnackBar(BaseSnackbar
                                  //                                 .buildSnackBar(
                                  //                                     context,
                                  //                                     message:
                                  //                                         'Reply sent',
                                  //                                     success:
                                  //                                         true));
                                  //                         // reply to post
                                  //                       });
                                  //                     });
                                  //               }
                                  // ),
                                  //         );
                                  //       } else {
                                  //         return const Center(
                                  //             child: CircularProgressIndicator(
                                  //           color: AppStyles.actionButtonColor,
                                  //         ));
                                  //       }
                                  //     }),

                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}
