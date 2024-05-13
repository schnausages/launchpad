import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:launchpad/models/user.dart';
import 'package:launchpad/services/feed_service.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/services/storage.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';
import 'package:launchpad/widgets/inputs/modal_sheet.dart';
import 'package:launchpad/widgets/misc/base_snackbar.dart';
import 'package:launchpad/widgets/pagination_scroll_controller.dart';
import 'package:launchpad/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class HomePagePosts extends StatefulWidget {
  const HomePagePosts({super.key});

  @override
  State<HomePagePosts> createState() => _HomePagePostsState();
}

class _HomePagePostsState extends State<HomePagePosts> {
  TextEditingController textController = TextEditingController();
  final String currentUid = FirebaseAuth.instance.currentUser!.uid;
  // ScrollController scrollController = ScrollController();

  bool _loadingPosts = false;
  PaginationScrollController paginationScrollController =
      PaginationScrollController();

  // exploreScrollListener() async {
  //   if (scrollController.position.atEdge &&
  //       scrollController.position.userScrollDirection ==
  //           ScrollDirection.reverse) {
  //     await feedService
  //         .loadNextPosts(feedService.feedPosts.last.documentSnapshot!);

  //     await scrollController.animateTo(scrollController.offset + 150,
  //         duration: Duration(milliseconds: 225), curve: Curves.easeInOut);
  //   }
  // }

  @override
  void initState() {
    paginationScrollController.init(
        loadAction: () => context.read<FeedService>().fetchHomeFeedPosts());
    // scrollController.addListener(exploreScrollListener);
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();

    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size s = MediaQuery.of(context).size;
    return SizedBox(
      height: s.height * .9,
      child: Consumer<FeedService>(
        builder: (context, service, _) {
          if (service.feedPosts.isEmpty) {
            service.fetchHomeFeedPosts();
          }
          if (service.feedPosts.isNotEmpty) {
            return CustomScrollView(slivers: [
              SliverFillRemaining(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: service.feedPosts.length,
                    controller: paginationScrollController.scrollController,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: PostWidget(
                            currentUserId: currentUid,
                            isWeb: PlatformServices.isWebMobile ? false : true,
                            post: service.feedPosts[i],
                            onDeletePress: () async {
                              await FirestoreServices.deletePost(
                                  docId: service.feedPosts[i].postId);
                              service.removePost(service.feedPosts[i]);
                            },
                            onSubReplyPress: (username) {
                              buildModalSheet(context,
                                  title: "Reply to ${username}'s comment",
                                  controller: textController,
                                  onSubmitPress: (x, y) async {
                                // add post
                                Map<String, dynamic> _userProfile =
                                    await AppStorage.returnProfile();
                                UserModel _u = UserModel.fromJson(_userProfile);
                                String _comment =
                                    '@$username  ${textController.text}';
                                await FirestoreServices.replyToPost(
                                    user: _u,
                                    text: _comment,
                                    replyToPost: service.feedPosts[i].postId);
                                Navigator.of(context).pop();
                              });
                            },
                            onReplyPress: () {
                              buildModalSheet(context,
                                  title:
                                      "Reply to ${service.feedPosts[i].userInfo!.username}'s post",
                                  controller: textController,
                                  onSubmitPress: (x, y) async {
                                // add post
                                Map<String, dynamic> _userProfile =
                                    await AppStorage.returnProfile();
                                UserModel _u = UserModel.fromJson(_userProfile);
                                await FirestoreServices.replyToPost(
                                    user: _u,
                                    text: textController.text,
                                    replyToPost: service.feedPosts[i].postId);
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    BaseSnackbar.buildSnackBar(context,
                                        message: 'Reply sent', success: true));
                              });
                            }),
                      );
                    }),
              ),
            ]);
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: AppStyles.actionButtonColor,
            ));
          }
        },
      ),
    );
  }
}
