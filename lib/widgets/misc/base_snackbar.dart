import 'package:flutter/material.dart';
import 'package:launchpad/styles/app_styles.dart';

class BaseSnackbar {
  final String message;
  final bool success;
  final BuildContext context;

  BaseSnackbar(
      {required this.message, required this.success, required this.context});

  static SnackBar buildSnackBar(BuildContext context,
          {required String message, bool? success = true}) =>
      SnackBar(
        content: Text(message,
            style: AppStyles.poppinsBold22
                .copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: success! ? Color(0xFF15D756) : Color(0xFFEF5350),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      );
}
