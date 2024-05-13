import 'package:flutter/material.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/misc/base_snackbar.dart';

class ViewAppsPage extends StatefulWidget {
  const ViewAppsPage({super.key});

  @override
  State<ViewAppsPage> createState() => _ViewAppsPageState();
}

class _ViewAppsPageState extends State<ViewAppsPage> {
  late Future<List<AppModel>> _fetchApps;

  @override
  void initState() {
    _fetchApps = FirestoreServices.getAllApplications();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyles.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppStyles.backgroundColor,
          centerTitle: true,
          // leading: IconButton(
          //     onPressed: () => Navigator.of(context).pop(),
          //     icon: Icon(Icons.chevron_left_rounded,
          //         size: 32, color: Colors.white)),
          title: Text('< APPS >',
              style: AppStyles.poppinsBold22.copyWith(fontSize: 26)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: _fetchApps,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 45, horizontal: 24),
                                tileColor: AppStyles.panelColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      BaseSnackbar.buildSnackBar(context,
                                          message: 'Join Launchpad to view',
                                          success: false));
                                },
                                title: Row(
                                  children: [
                                    Text(snapshot.data![i].name,
                                        style: AppStyles.poppinsBold22),
                                    if (snapshot.data![i].isFeatured!)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 6.0),
                                        child: const Icon(
                                          Icons.star_rounded,
                                          color: Color(0xFFFFD54F),
                                          size: 22,
                                        ),
                                      )
                                  ],
                                ),
                                subtitle: Text(
                                    snapshot.data![i].appOwnerInfo!.username,
                                    style: AppStyles.poppinsBold22.copyWith(
                                        fontSize: 14,
                                        color: Color(0xFFCECECE))),
                                leading: Container(
                                  // width: 65,
                                  // height: 65,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppStyles.backgroundColor),
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                      PlatformServices.appIcon(
                                          snapshot.data![i].appCategory ?? ''),
                                      color: Colors.white),
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: AppStyles.actionButtonColor,
                      ));
                    }
                  }),
            ],
          ),
        ));
  }
}
