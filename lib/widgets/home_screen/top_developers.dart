import 'package:flutter/material.dart';
import 'package:launchpad/models/user.dart';
import 'package:launchpad/pages/visited_profile_page.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/misc/dev_bit.dart';

class TopDevelopers extends StatefulWidget {
  const TopDevelopers({super.key});

  @override
  State<TopDevelopers> createState() => _TopDevelopersState();
}

class _TopDevelopersState extends State<TopDevelopers> {
  late Future<List<UserModel>> _getTopUsers;

  @override
  void initState() {
    _getTopUsers = FirestoreServices.getTopUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: FutureBuilder(
            future: _getTopUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppStyles.actionButtonColor,
                ));
              } else if (snapshot.hasData) {
                return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, i) {
                        return Padding(
                            padding: EdgeInsets.only(
                                left: PlatformServices.isWebMobile ? 10 : 45,
                                right: PlatformServices.isWebMobile ? 10 : 220),
                            child: _TopDevTile(user: snapshot.data![i]));
                      }),
                );
              } else {
                return SizedBox();
              }
            }));
  }
}

class _TopDevTile extends StatelessWidget {
  final UserModel user;
  const _TopDevTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          splashColor: AppStyles.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          tileColor: AppStyles.panelColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) =>
                        VisitedProfilePage(visitedUserId: user.userId)));
          },
          leading: SizedBox(
            height: 100,
            width: 60,
            child: Wrap(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                              image: PlatformServices.renderUserPfp(
                                  user.pfpUrl ?? ''),
                              fit: BoxFit.cover)),
                      height: 55,
                      width: 55,
                    ),
                  ],
                ),
              ],
            ),
          ),
          title: Text(user.username,
              style: AppStyles.poppinsBold22.copyWith(fontSize: 16)),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DevBit(bitCount: user.bitCount ?? 5),
            ],
          )),
    );
  }
}
