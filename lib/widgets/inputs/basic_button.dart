import 'package:flutter/material.dart';
import 'package:launchpad/styles/app_styles.dart';

class BasicButton extends StatelessWidget {
  final Function onClick;
  final String label;
  final bool isMobile;
  const BasicButton(
      {super.key,
      required this.onClick,
      required this.label,
      this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        padding: !isMobile
            ? EdgeInsets.symmetric(horizontal: 16, vertical: 12)
            : EdgeInsets.all(6),
        color: AppStyles.actionButtonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        child: Text(label,
            style: AppStyles.poppinsBold22
                .copyWith(color: Colors.white, fontSize: isMobile ? 14 : 18)),
        onPressed: () {
          onClick();
        });
  }
}
