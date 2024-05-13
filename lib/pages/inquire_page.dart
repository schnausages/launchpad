import 'package:flutter/material.dart';
import 'package:launchpad/models/user.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/inputs/base_text_field.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';
import 'package:launchpad/widgets/misc/base_snackbar.dart';

class InquirePage extends StatefulWidget {
  final bool isProblem;
  final UserModel user;
  const InquirePage({super.key, required this.user, this.isProblem = false});

  @override
  State<InquirePage> createState() => _InquirePageState();
}

class _InquirePageState extends State<InquirePage> {
  TextEditingController controller = TextEditingController();
  final bool isWebmobile = PlatformServices.isWebMobile;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppStyles.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(widget.isProblem ? 'Report Issue' : 'Promote App',
            style: AppStyles.poppinsBold22),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.close, color: AppStyles.iconColor)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!widget.isProblem)
              Padding(
                padding: isWebmobile
                    ? const EdgeInsets.symmetric(horizontal: 8, vertical: 10)
                    : const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                child: Text(
                    'Let us know if you want to promote an app or business on Launchpad. Describe your app or business and we\'ll get back to you shortly via email!',
                    softWrap: true,
                    style: AppStyles.poppinsBold22.copyWith(fontSize: 16)),
              ),
            if (widget.isProblem)
              Padding(
                padding: isWebmobile
                    ? const EdgeInsets.symmetric(horizontal: 8, vertical: 10)
                    : const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                child: Text(
                    'Describe the problem you are having on Launchpad or leave general feedback',
                    softWrap: true,
                    style: AppStyles.poppinsBold22.copyWith(fontSize: 16)),
              ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isWebmobile ? 10 : 100,
                  vertical: isWebmobile ? 10 : 40),
              child: BasicTextField.multiLine(
                controller: controller,
                autofocus: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BasicButton(
                    onClick: () async {
                      if (controller.text.isNotEmpty) {
                        var _res = await FirestoreServices.sendReport(
                            text: controller.text,
                            user: widget.user,
                            isProblem: widget.isProblem);
                        if (_res) {
                          controller.clear();
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                              BaseSnackbar.buildSnackBar(context,
                                  message:
                                      'Success! Reply will be sent to your email',
                                  success: true));
                        } else {}
                      }
                    },
                    label: 'SEND')
              ],
            )
          ],
        ),
      ),
    );
  }
}
