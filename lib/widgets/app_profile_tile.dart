import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/pages/app_detail_owner.dart';
import 'package:launchpad/pages/app_detail_visitor.dart';
import 'package:launchpad/styles/app_styles.dart';

class AppProfileTile extends StatelessWidget {
  final AppModel app;
  final bool ownsApp;
  final Function onEditPress;
  final Function onDeletePress;
  final bool isMobileWeb;
  const AppProfileTile(
      {super.key,
      required this.app,
      required this.isMobileWeb,
      required this.onDeletePress,
      required this.ownsApp,
      required this.onEditPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ListTile(
        onTap: () {
          if (ownsApp) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => AppDetailOwnerPage(
                      app: app,
                      ownsApp: ownsApp,
                    )));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => AppDetailVisitorPage(
                      app: app,
                    )));
          }
        },
        leading: ownsApp
            ? InkWell(
                onTap: () async {
                  onEditPress();
                },
                child: const Icon(
                  Icons.edit,
                  color: Colors.white70,
                ),
              )
            : const SizedBox(),
        splashColor: AppStyles.panelColor,
        hoverColor: AppStyles.backgroundColor,
        tileColor: AppStyles.panelColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: isMobileWeb
            ? EdgeInsets.symmetric(vertical: 12, horizontal: 8)
            : EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(app.name, style: AppStyles.poppinsBold22),
            if (app.playStoreLink!.isNotEmpty)
              SizedBox(
                width: 28,
                height: 28,
                child: SvgPicture.asset(
                  'assets/svgs/play.svg',
                ),
              ),
            if (app.appStoreLink!.isNotEmpty)
              const Icon(
                Icons.apple,
                color: Colors.white,
                size: 26,
              )
          ],
        ),
        subtitle: Row(
          children: List.generate(
              app.seeking?.length ?? 0,
              (index) => Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: app.seeking![index] == 'feedback'
                              ? Color(0xFFEC407A)
                              : Color(0xFF4CAF50)),
                      child: Text(app.seeking![index],
                          style: AppStyles.poppinsBold22
                              .copyWith(fontSize: 14, color: Colors.white)),
                    ),
                  )),
        ),
        trailing: Column(
          children: [
            if (ownsApp)
              InkWell(
                onTap: () async {
                  onDeletePress();
                },
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red[400],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
