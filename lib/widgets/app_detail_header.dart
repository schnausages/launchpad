import 'package:flutter/material.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/app_detail_link_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDetailHeader extends StatelessWidget {
  final AppModel app;
  final bool isMobileWeb;
  const AppDetailHeader(
      {super.key, required this.app, required this.isMobileWeb});

  @override
  Widget build(BuildContext context) {
    final Size _s = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: isMobileWeb ? _s.width * .9 : _s.width * .6,
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
              color: AppStyles.panelColor,
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (app.iconImage!.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                      color: AppStyles.backgroundColor,
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                          image: NetworkImage(app.iconImage!),
                          fit: BoxFit.cover)),
                  width: 65,
                  height: 65,
                ),
              if (app.iconImage!.isEmpty)
                Container(
                  decoration: BoxDecoration(
                      color: AppStyles.backgroundColor,
                      borderRadius: BorderRadius.circular(6)),
                  // width: 85,
                  padding: const EdgeInsets.all(14),
                  child: Icon(PlatformServices.appIcon(app.appCategory!),
                      color: Colors.white, size: 32),
                ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(app.name,
                          style: AppStyles.poppinsBold22
                              .copyWith(fontSize: isMobileWeb ? 16 : 20)),
                      if (app.isFeatured!)
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFD54F),
                            size: 22,
                          ),
                        )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                  image: PlatformServices.renderUserPfp(
                                      app.appOwnerInfo?.pfpUrl ?? ''),
                                  fit: BoxFit.cover)),
                          height: 30,
                          width: 30,
                        ),
                      ),
                      Text(app.appOwnerInfo!.username,
                          style: AppStyles.baseBodyStyle
                              .copyWith(fontSize: 14, color: Colors.white60)),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (app.alternativeExternalLink!.isNotEmpty)
                InkWell(
                    onTap: () async {
                      if (!app.alternativeExternalLink!.contains('https')) {
                        var ps = Uri.https(app.alternativeExternalLink!);
                        await launchUrl(ps);
                      } else {
                        await launchUrl(
                            Uri.parse(app.alternativeExternalLink!));
                      }
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
                        child: Icon(Icons.link, color: Color(0xFF6EDBFF)))),
              if (app.appStoreLink!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: AppLinkTile(
                      isPlayStore: false,
                      onClicked: () async {
                        await launchUrl(
                          Uri.parse(app.appStoreLink!),
                        );
                      }),
                ),
              if (app.playStoreLink!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AppLinkTile(
                      isPlayStore: true,
                      onClicked: () async {
                        await launchUrl(
                          Uri.parse(app.playStoreLink!),
                        );
                      }),
                ),
              if (app.appCategory != null && !isMobileWeb)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      app.appCategory!,
                      style: AppStyles.poppinsBold22.copyWith(fontSize: 14),
                    ),
                  ),
                ),
              if (app.seeking!.isNotEmpty)
                Row(
                  children: List.generate(
                      app.seeking?.length ?? 0,
                      (index) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: app.seeking![index] == 'feedback'
                                      ? Color(0xFFEC407A)
                                      : Color(0xFF4CAF50)),
                              child: Text(app.seeking![index],
                                  style: AppStyles.poppinsBold22
                                      .copyWith(fontSize: 14)),
                            ),
                          )),
                ),
            ],
          ),
        ),
        if (app.description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: isMobileWeb ? _s.width * .9 : _s.width * .6,
              decoration: BoxDecoration(
                  color: AppStyles.panelColor,
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: Text(app.description!,
                  softWrap: true,
                  style: AppStyles.poppinsBold22.copyWith(fontSize: 16)),
            ),
          ),
      ],
    );
  }
}
