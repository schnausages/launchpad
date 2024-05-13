import 'package:flutter/material.dart';
import 'package:launchpad/styles/app_styles.dart';

class SponsorTile extends StatelessWidget {
  final String sponsorName;
  final String sponsorLink;
  final String sponsorImageUrl;
  const SponsorTile(
      {super.key,
      required this.sponsorName,
      required this.sponsorLink,
      required this.sponsorImageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppStyles.actionButtonColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      trailing: Icon(Icons.info_outline_rounded),
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(sponsorImageUrl)),
            color: AppStyles.panelColor,
            shape: BoxShape.circle),
      ),
      title: Text(
        sponsorName,
        style: AppStyles.poppinsBold22,
      ),
    );
  }
}
