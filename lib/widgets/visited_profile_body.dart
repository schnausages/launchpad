import 'package:flutter/material.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/models/user.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/app_profile_tile.dart';
import 'package:launchpad/widgets/misc/dev_bit.dart';

class VisitedProfileBody extends StatefulWidget {
  final UserModel userData;
  final bool isMobileWeb;
  const VisitedProfileBody(
      {super.key, required this.userData, required this.isMobileWeb});

  @override
  State<VisitedProfileBody> createState() => _VisitedProfileBodyState();
}

class _VisitedProfileBodyState extends State<VisitedProfileBody> {
  late Future<List<AppModel>> _fetchUserApps;

  @override
  void initState() {
    _fetchUserApps =
        FirestoreServices.getAppsForUser(userId: widget.userData.userId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: widget.isMobileWeb ? 10 : 100),
                child: _VisitedProfileDetailCard(userData: widget.userData)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Row(
                children: [
                  Text('Applications', style: AppStyles.poppinsBold22),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: PlatformServices.isWebMobile ? 10 : 100),
              child: FutureBuilder(
                  future: _fetchUserApps,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return AppProfileTile(
                            isMobileWeb: widget.isMobileWeb,
                            app: snapshot.data![index],
                            ownsApp: false,
                            onEditPress: () {},
                            onDeletePress: () {},
                          );
                        }),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppStyles.actionButtonColor,
                        ),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class _VisitedProfileDetailCard extends StatefulWidget {
  final UserModel userData;
  const _VisitedProfileDetailCard({super.key, required this.userData});

  @override
  State<_VisitedProfileDetailCard> createState() =>
      _VisitedProfileDetailCardState();
}

class _VisitedProfileDetailCardState extends State<_VisitedProfileDetailCard> {
  TextEditingController nameController = TextEditingController();

  late String username;

  @override
  void initState() {
    username = widget.userData.username;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _date = widget.userData.dateJoined ?? DateTime.now();
    int _daysDiff = DateTime.now().difference(_date).inDays;
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.panelColor,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: PlatformServices.renderUserPfp(
                        widget.userData.pfpUrl ?? ''),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(width: 30),
          Column(
            children: [
              Row(
                children: [
                  Text(username, style: AppStyles.poppinsBold22),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DevBit(
                    bitCount: widget.userData.bitCount!,
                  ),
                  if (!PlatformServices.isWebMobile)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 6.0),
                      child: Text('Joined: $_daysDiff days ago',
                          style: AppStyles.poppinsBold22
                              .copyWith(fontSize: 14, color: Colors.white70)),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
