import 'package:flutter/material.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/home_app_tile.dart';

class HomeAppsExplore extends StatefulWidget {
  const HomeAppsExplore({super.key});

  @override
  State<HomeAppsExplore> createState() => _HomeAppsExploreState();
}

class _HomeAppsExploreState extends State<HomeAppsExplore> {
  final ScrollController _appsScrollController = ScrollController();
  late Future<List<AppModel>> _fetchApps;
  final bool isWebMobile = PlatformServices.isWebMobile;

  @override
  void initState() {
    _fetchApps = FirestoreServices.getAllApplications();

    super.initState();
  }

  @override
  void dispose() {
    _appsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _s = MediaQuery.of(context).size;

    return SizedBox(
      width: _s.width,
      height: 190,
      child: FutureBuilder(
          future: _fetchApps,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              if (isWebMobile) {
                return GridView.builder(
                    controller: _appsScrollController,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 2.5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 8,
                            crossAxisCount: 2),
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return HomeAppTile(
                        app: snapshot.data![i],
                        s: _s,
                      );
                    });
              } else {
                return Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _appsScrollController.animateTo(
                            _appsScrollController.offset - 180,
                            duration: Duration(milliseconds: 220),
                            curve: Curves.linear);
                      },
                      child: Container(
                        color: AppStyles.backgroundColor,
                        width: 55,
                        height: double.infinity,
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 40,
                          color: AppStyles.iconColor,
                        ),
                      ),
                    ),
                    Flexible(
                      child: GridView.builder(
                          controller: _appsScrollController,
                          // shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1 / 2.5,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 8,
                                  crossAxisCount: 2),
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return HomeAppTile(
                              app: snapshot.data![i],
                              s: _s,
                            );
                          }),
                    ),
                    InkWell(
                      onTap: () {
                        _appsScrollController.animateTo(
                            _appsScrollController.offset + 220,
                            duration: Duration(milliseconds: 220),
                            curve: Curves.linear);
                      },
                      child: Container(
                        color: AppStyles.backgroundColor,
                        width: 55,
                        height: double.infinity,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 40,
                          color: AppStyles.iconColor,
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppStyles.actionButtonColor,
              ));
            }
          }),
    );
  }
}
