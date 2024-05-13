import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launchpad/models/tester.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/misc/base_snackbar.dart';
import 'package:intl/intl.dart';

class TestUserTile extends StatefulWidget {
  final TesterModel testUser;
  final String appId;
  const TestUserTile({super.key, required this.testUser, required this.appId});

  @override
  State<TestUserTile> createState() => _TestUserTileState();
}

class _TestUserTileState extends State<TestUserTile> {
  bool _verified = false;
  @override
  void initState() {
    _verified = widget.testUser.isVerifiedTester;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size _s = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _s.width > 800 ? 140 : 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
            color: AppStyles.panelColor,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                  widget.testUser.isAndroidTester
                      ? Icons.android_rounded
                      : Icons.apple_rounded,
                  color: widget.testUser.isAndroidTester
                      ? Colors.greenAccent
                      : Colors.white),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.testUser.email,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style:
                              AppStyles.poppinsBold22.copyWith(fontSize: 16)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                                ClipboardData(text: widget.testUser.email));
                            ScaffoldMessenger.of(context).showSnackBar(
                                BaseSnackbar.buildSnackBar(context,
                                    message: 'Email copied', success: true));
                          },
                          child: Icon(Icons.copy,
                              color: AppStyles.iconColor, size: 24),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Joined: ${DateFormat('yyyy-MM-dd').format(widget.testUser.dateJoined ?? DateTime.now())}',
                        style: AppStyles.poppinsBold22
                            .copyWith(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    //validate test user
                    if (!_verified) {
                      setState(() {
                        _verified = true;
                      });
                      bool _success = await FirestoreServices.verifyTester(
                          appId: widget.appId,
                          userIdToVerify: widget.testUser.userId);
                      if (_success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            BaseSnackbar.buildSnackBar(context,
                                message: 'Tester verified', success: true));
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                        !_verified
                            ? Icons.check_box_outline_blank_rounded
                            : Icons.check,
                        color:
                            !_verified ? Colors.white54 : Colors.greenAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
