import 'package:flutter/material.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/models/post.dart';
import 'package:launchpad/pages/app_detail_visitor.dart';
import 'package:launchpad/pages/visited_profile_page.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/misc/base_snackbar.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';
import 'package:launchpad/widgets/misc/dev_bit.dart';
import 'package:url_launcher/url_launcher.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;
  final bool appView;
  final String? appId;
  final Function onDeletePress;
  final bool isWeb;

  final Function onReplyPress;
  final Function(String) onSubReplyPress;

  final String currentUserId;

  const PostWidget(
      {super.key,
      required this.post,
      required this.isWeb,
      this.appView = false,
      this.appId,
      required this.onSubReplyPress,
      required this.onDeletePress,
      required this.onReplyPress,
      required this.currentUserId});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late Future<List<PostModel>> _fetchComments;
  ScrollController scrollController = ScrollController();
  bool _expanded = false;

  @override
  void initState() {
    _fetchComments = widget.appView
        ? Future.delayed(Duration(seconds: 1)).then((value) =>
            FirestoreServices.fetchRepliesToAppComment(
                replyToPost: widget.post.postId, appId: widget.appId!))
        : Future.delayed(Duration(seconds: 1)).then((value) =>
            FirestoreServices.fetchCommentsToPost(
                replyToPost: widget.post.postId));

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _s = MediaQuery.of(context).size;
    bool _hasReplies = widget.post.replyCount > 0;
    final int devBits = widget.post.userInfo!.bitCount ?? 0;

    return Material(
      color: AppStyles.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            splashColor: AppStyles.backgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            tileColor:
                _expanded ? AppStyles.panelColor : AppStyles.backgroundColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 40, horizontal: 8.0),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => VisitedProfilePage(
                                visitedUserId: widget.post.userInfo!.userId)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                            image: PlatformServices.renderUserPfp(
                                widget.post.userInfo?.pfpUrl ?? ''),
                            fit: BoxFit.cover)),
                    height: 30,
                    width: 30,
                  ),
                ),
                Text(widget.post.userInfo!.username,
                    style: AppStyles.poppinsBold22.copyWith(fontSize: 16)),
                if (devBits > 0) DevBit(bitCount: devBits),
                // if (widget.post.userInfo!.bitCount! > 0)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 8.0),
                //     child: DevBit(bitCount: widget.post.userInfo!.bitCount!),
                //   ),
                if (widget.post.mentionedApp!.launchpadAppId.isNotEmpty &&
                    widget.isWeb)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: _MentionedAppTile(
                      app: widget.post.mentionedApp!,
                    ),
                  ),
                Spacer(),
                if (widget.post.userId == widget.currentUserId)
                  InkWell(
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                          BaseSnackbar.buildSnackBar(context,
                              message: 'Post deleted', success: false));
                      widget.onDeletePress();
                    },
                    child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.delete_outline_rounded,
                            color: Colors.red)),
                  ),
              ],
            ),
            subtitle: Row(
              children: [
                if (widget.post.externalink!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 6.0),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            builder: (context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * .25,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 40, top: 20),
                                decoration: const BoxDecoration(
                                    color: AppStyles.backgroundColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('OPEN THIS LINK?',
                                            style: AppStyles.poppinsBold22),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: BasicButton(
                                              isMobile:
                                                  PlatformServices.isWebMobile,
                                              onClick: () async {
                                                var ps = Uri.parse(
                                                    widget.post.externalink!);

                                                await launchUrl(ps);
                                              },
                                              label: 'OPEN'),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: InkWell(
                                        onTap: () async {
                                          var ps = Uri.parse(
                                              widget.post.externalink!);

                                          await launchUrl(ps);
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .8,
                                          child: Text(
                                            widget.post.externalink!,
                                            softWrap: true,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          // color: Color(0xFFC2ECFF),
                          color: AppStyles.panelColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(6),
                        child:
                            Icon(Icons.insert_link, color: Color(0xFF6EDBFF)),

                        // Icon(Icons.insert_link, color: Color(0xFF3E95FA)),
                      ),
                    ),
                  ),
                if (widget.post.text.contains('@') ||
                    widget.post.text.contains('https:'))
                  Flexible(
                    child: SelectableText(
                        _hasReplies
                            ? '[${'${widget.post.replyCount < 2 ? '${widget.post.replyCount} reply' : '${widget.post.replyCount} replies'}] '}${widget.post.text}'
                            : widget.post.text,
                        toolbarOptions:
                            ToolbarOptions(copy: true, selectAll: true),
                        style: AppStyles.smallTextBody),
                  ),
                if (!widget.post.text.contains('@') &&
                    !widget.post.text.contains('https:'))
                  Flexible(
                    child: Text(
                        _hasReplies
                            ? '[${'${widget.post.replyCount < 2 ? '${widget.post.replyCount} reply' : '${widget.post.replyCount} replies'}] '}${widget.post.text}'
                            : widget.post.text,
                        softWrap: true,
                        style: AppStyles.smallTextBody),
                  ),
              ],
            ),
          ),
          if (widget.post.replyCount > 0)
            Padding(
              padding: EdgeInsets.only(right: _s.width > 800 ? 40 : 8),
              child: InkWell(
                onTap: () {
                  widget.onReplyPress();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 3,
                        color: Colors.white54,
                      ),
                      Text(widget.post.replyCount.toString(),
                          style: AppStyles.poppinsBold22.copyWith(
                              color: Colors.white60,
                              fontSize: 13,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
              ),
            ),
          if (_expanded && widget.post.replyCount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: AppStyles.panelColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  width: _s.width * .9,
                  height: 220,
                  child: FutureBuilder(
                      future: _fetchComments,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return RawScrollbar(
                            thumbColor: Colors.white70,
                            radius: const Radius.circular(3.0),
                            thickness: 10,
                            minThumbLength: 30,
                            controller: scrollController,
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                controller: scrollController,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, i) {
                                  return ListTile(
                                    tileColor: AppStyles.panelColor,
                                    title: Text(
                                        snapshot.data![i].userInfo!.username,
                                        style: AppStyles.poppinsBold22
                                            .copyWith(fontSize: 16)),
                                    subtitle: (snapshot.data![i].text
                                                .contains('@') ||
                                            snapshot.data![i].text
                                                .contains('https'))
                                        ? SelectableText(snapshot.data![i].text,
                                            toolbarOptions: ToolbarOptions(
                                                copy: true, selectAll: true),
                                            style: AppStyles.baseBodyStyle
                                                .copyWith(fontSize: 14))
                                        : Text(snapshot.data![i].text,
                                            style: AppStyles.baseBodyStyle
                                                .copyWith(fontSize: 14)),
                                    leading: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                              image: PlatformServices
                                                  .renderUserPfp(snapshot
                                                          .data![i]
                                                          .userInfo!
                                                          .pfpUrl ??
                                                      ''),
                                              fit: BoxFit.cover)),
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        widget.onSubReplyPress(snapshot
                                            .data![i].userInfo!.username);
                                      },
                                      child: Icon(Icons.reply_rounded,
                                          color: AppStyles.iconColor, size: 28),
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: AppStyles.actionButtonColor),
                          );
                        }
                      }),
                ),
              ],
            )
        ],
      ),
    );
  }
}

class _MentionedAppTile extends StatelessWidget {
  final AppModel app;

  const _MentionedAppTile({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => AppDetailVisitorPage(
              app: AppModel(
                  name: app.name,
                  launchpadAppId: app.launchpadAppId,
                  appOwnerId: '',
                  appCategory: app.appCategory),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF5E35B1), Color(0xFF9C27B0)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: Row(
          children: [
            Icon(PlatformServices.appIcon(app.appCategory ?? ''),
                size: 18, color: Colors.white),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: SizedBox(
                width: 90,
                child: Text(app.name,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                    style: AppStyles.poppinsBold22
                        .copyWith(color: Colors.white, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
