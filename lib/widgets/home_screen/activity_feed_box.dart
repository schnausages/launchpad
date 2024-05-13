import 'package:flutter/material.dart';
import 'package:launchpad/models/activity_item.dart';
import 'package:launchpad/pages/app_detail_visitor.dart';
import 'package:launchpad/pages/visited_profile_page.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/styles/app_styles.dart';

class ActivityFeedBox extends StatefulWidget {
  const ActivityFeedBox({super.key});

  @override
  State<ActivityFeedBox> createState() => _ActivityFeedBoxState();
}

class _ActivityFeedBoxState extends State<ActivityFeedBox> {
  late Future<List<ActivityItem>> getActivity;
  @override
  void initState() {
    getActivity = FirestoreServices.getActivityItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      height: 190,
      child: FutureBuilder(
          future: getActivity,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppStyles.actionButtonColor,
              ));
            } else {
              return GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1 / 2.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 8,
                      crossAxisCount: 2),
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => _ActivityTile(
                        item: snapshot.data![i],
                      ));
            }
          }),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityItem item;
  const _ActivityTile({super.key, required this.item});

  IconData returnIcon(String type) {
    if (type == 'user') {
      return Icons.account_box_rounded;
    } else if (type == 'comment') {
      return Icons.mode_comment_rounded;
    } else if (type == 'app') {
      return Icons.add_box_rounded;
    } else {
      return Icons.edit_rounded;
    }
  }

  LinearGradient returnGradient(String type) {
    if (type == 'user') {
      return const LinearGradient(
          colors: [Color(0xFF9C27B0), Color(0xFFE040FB)]);
    } else if (type == 'comment') {
      return const LinearGradient(
          colors: [Color(0xFF43A047), Color(0xFF00D312)]);
    } else if (type == 'app') {
      return const LinearGradient(
          colors: [Color(0xFFD81B60), Color(0xFFEC407A)]);
    } else {
      return const LinearGradient(
          colors: [Color(0x1FFFFFFF), Color(0x1AFFFFFF)]);
    }
  }

  String returnText(String type) {
    if (type == 'user') {
      return '${item.userInfo!.username} joined Launchpad!';
    } else if (type == 'app') {
      return "${item.userInfo!.username} added a new app: ${item.mentionedApp!.name}";
    } else if (type == 'comment') {
      return '${item.userInfo!.username} commented on ${item.mentionedApp!.name}';
    } else {
      return '${item.userInfo!.username} ${item.message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String t = item.type;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          if (item.type == 'app' || item.type == 'comment') {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) =>
                    AppDetailVisitorPage(app: item.mentionedApp!)));
          }
          if (item.type == 'user') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => VisitedProfilePage(
                        visitedUserId: item.userInfo!.userId)));
          }
        },
        child: Container(
          width: 250,
          decoration: BoxDecoration(
              color: AppStyles.panelColor,
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Container(
                    decoration: BoxDecoration(
                        gradient: returnGradient(t),
                        borderRadius: BorderRadius.circular(4)),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      returnIcon(t),
                      color: Colors.white,
                      size: 18,
                    )),
              ),
              Flexible(
                child: Text(
                  returnText(t),
                  maxLines: 3,
                  overflow: TextOverflow.clip,
                  softWrap: true,
                  style: AppStyles.poppinsBold22
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          // leading: Container(
          //     decoration: BoxDecoration(
          //         color: AppStyles.backgroundColor,
          //         borderRadius: BorderRadius.circular(6)),
          //     child: const Icon(Icons.gamepad, color: AppStyles.iconColor)),
        ),
      ),
    );
  }
}
