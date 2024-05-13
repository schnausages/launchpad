import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/models/user.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/inputs/base_text_field.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';
import 'package:launchpad/widgets/misc/base_snackbar.dart';

class AddApplicationPage extends StatefulWidget {
  final UserModel user;
  const AddApplicationPage({super.key, required this.user});

  @override
  State<AddApplicationPage> createState() => _AddApplicationPageState();
}

class _AddApplicationPageState extends State<AddApplicationPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController appStoreLink = TextEditingController();
  TextEditingController playStoreLink = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController iosTestLinkController = TextEditingController();
  TextEditingController androidTestLinkController = TextEditingController();
  TextEditingController externalLinkController = TextEditingController();

  List<String> _seeking = [];
  String _appCategory = '';
  bool _inAppStore = false;
  bool allowiOSLink = false;
  bool allowAndroidLink = false;

  final Text optionalText = const Text('[ optional ]',
      style: TextStyle(fontSize: 12, color: Colors.white));
  final SizedBox _heightBox = const SizedBox(height: 45);
  final TextStyle _titleStyle = AppStyles.poppinsBold22.copyWith(fontSize: 16);
  final List<String> categories = PlatformServices.appCategories;

  bool appInfoIsValid() {
    if (_appCategory.isNotEmpty && nameController.text.isNotEmpty) {
      if (_inAppStore &&
          (playStoreLink.text.isNotEmpty || appStoreLink.text.isNotEmpty)) {
        return true;
      } else if (_inAppStore &&
          (playStoreLink.text.isEmpty || appStoreLink.text.isEmpty)) {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    descController.dispose();
    nameController.dispose();
    playStoreLink.dispose();
    appStoreLink.dispose();
    iosTestLinkController.dispose();
    androidTestLinkController.dispose();
    externalLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _s = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppStyles.backgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppStyles.backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: const Text('Your new app ✨', style: AppStyles.poppinsBold22),
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
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _s.width > 800 ? 160 : 10),
            child: Column(
              children: [
                _heightBox,
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: BasicTextField.singleLine(
                      controller: nameController, hintText: 'App Name'),
                ),
                Row(
                  children: [
                    Text('Is it in app store(s)?', style: _titleStyle),
                    optionalText,
                    InkWell(
                      onTap: () {
                        setState(() {
                          _inAppStore = !_inAppStore;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: _inAppStore
                            ? const Icon(
                                Icons.check_box,
                                color: Colors.greenAccent,
                              )
                            : const Icon(
                                Icons.check_box_outline_blank_rounded,
                                color: Colors.white70,
                              ),
                      ),
                    )
                  ],
                ),
                if (_inAppStore)
                  Row(
                    children: [
                      Text(
                        '* at least one app store link must be provided',
                        style: AppStyles.poppinsBold22.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                if (_inAppStore)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.apple,
                              size: 36,
                              color: Colors.white,
                            ),
                            Text('App Store Link', style: _titleStyle),
                          ],
                        ),
                        BasicTextField.singleLine(
                            controller: appStoreLink,
                            hintText: 'Paste link...'),
                      ],
                    ),
                  ),
                if (_inAppStore)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              size: 36,
                              color: Colors.lightGreenAccent,
                            ),
                            Text('Play Store Link', style: _titleStyle),
                          ],
                        ),
                        BasicTextField.singleLine(
                            controller: playStoreLink,
                            hintText: 'Paste link...'),
                      ],
                    ),
                  ),
                _heightBox,
                Column(
                  children: [
                    Row(
                      children: [
                        Text('Describe your app  ', style: _titleStyle),
                        optionalText
                      ],
                    ),
                    TextField(
                      cursorColor: const Color(0xFFFEFFF4),
                      obscureText: false,
                      keyboardType: TextInputType.multiline,
                      onSubmitted: (_) {},
                      maxLines: 10,
                      minLines: 1,
                      maxLength: 1200,
                      autofocus: false,
                      style: AppStyles.poppinsBold22.copyWith(fontSize: 16),
                      controller: descController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        fillColor: AppStyles.panelColor,
                        hintText: 'Description...',
                        hintStyle: AppStyles.poppinsBold22
                            .copyWith(color: Colors.white70, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.link,
                            size: 28,
                            color: Colors.white,
                          ),
                          Flexible(
                            child: Text(
                                'Add a website, group link, or other external link',
                                style: _titleStyle),
                          ),
                        ],
                      ),
                      BasicTextField.singleLine(
                          controller: externalLinkController,
                          hintText: 'Paste link...'),
                    ],
                  ),
                ),
                _heightBox,
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('App Category:', style: _titleStyle),
                ),
                Wrap(
                  children: List.generate(
                      categories.length,
                      (i) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _appCategory = categories[i];
                                });
                              },
                              child: Container(
                                width: 145,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: categories[i] == _appCategory
                                        ? Colors.purple
                                        : AppStyles.panelColor,
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: Text(
                                    categories[i],
                                    textAlign: TextAlign.center,
                                    style: _titleStyle.copyWith(
                                      fontSize: 15,
                                      color: categories[i] == _appCategory
                                          ? Colors.white
                                          : Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                ),
                _heightBox,
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Text('Looking for: ', style: _titleStyle),
                      optionalText
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        if (!_seeking.contains('feedback')) {
                          _seeking.add('feedback');
                        } else {
                          _seeking.remove('feedback');
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: _seeking.contains('feedback')
                              ? const Color(0xFFEC407A)
                              : Colors.white30,
                        ),
                        child: Text(
                          'feedback',
                          style: AppStyles.poppinsBold22.copyWith(
                              fontSize: 14,
                              color: _seeking.contains('feedback')
                                  ? Colors.white
                                  : Colors.white60),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    InkWell(
                      onTap: () {
                        if (!_seeking.contains('testers')) {
                          _seeking.add('testers');
                        } else {
                          _seeking.remove('testers');
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: _seeking.contains('testers')
                              ? const Color(0xFF4CAF50)
                              : Colors.white30,
                        ),
                        child: Text(
                          'testers',
                          style: AppStyles.poppinsBold22.copyWith(
                              fontSize: 14,
                              color: _seeking.contains('testers')
                                  ? Colors.white
                                  : Colors.white60),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_seeking.contains('testers'))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.troubleshoot_rounded,
                              size: 36,
                              color: Colors.white,
                            ),
                            Text('Provide Open Testing link(s) (optional)',
                                style: _titleStyle),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                child: Text(
                                  'Once testers agree to test your app, you\'ll also receive their email address or they can access via link(s) you provide',
                                  softWrap: true,
                                  style: AppStyles.poppinsBold22.copyWith(
                                      fontSize: 14, color: Colors.white70),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text('iOS link (optional)',
                                    style: AppStyles.poppinsBold22
                                        .copyWith(fontSize: 16)),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        allowiOSLink = !allowiOSLink;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Icon(
                                          allowiOSLink
                                              ? Icons.check_box_rounded
                                              : Icons
                                                  .check_box_outline_blank_rounded,
                                          color: allowiOSLink
                                              ? Colors.greenAccent
                                              : Colors.white60),
                                    ))
                              ],
                            ),
                          ],
                        ),
                        if (allowiOSLink)
                          BasicTextField.singleLine(
                              controller: iosTestLinkController,
                              hintText: 'Paste iOS link...'),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text('Android link (optional)',
                                    style: AppStyles.poppinsBold22
                                        .copyWith(fontSize: 16)),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        allowAndroidLink = !allowAndroidLink;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Icon(
                                          allowAndroidLink
                                              ? Icons.check_box_rounded
                                              : Icons
                                                  .check_box_outline_blank_rounded,
                                          color: allowAndroidLink
                                              ? Colors.greenAccent
                                              : Colors.white60),
                                    ))
                              ],
                            ),
                          ],
                        ),
                        if (allowAndroidLink)
                          BasicTextField.singleLine(
                              controller: androidTestLinkController,
                              hintText: 'Android test link...'),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: BasicButton(
                      isMobile: PlatformServices.isWebMobile,
                      onClick: () async {
                        bool _isValid = appInfoIsValid();
                        if (_isValid) {
                          String launchpadId = nameController.text +
                              DateTime.now().millisecondsSinceEpoch.toString();
                          AppModel _a = AppModel(
                              isFeatured: false,
                              appOwnerId: widget.user.userId,
                              appCategory: _appCategory,
                              appOwnerInfo: widget.user,
                              name: nameController.text,
                              launchpadAppId: launchpadId,
                              seeking: _seeking,
                              playStoreLink: playStoreLink.text,
                              appStoreLink: appStoreLink.text,
                              iosTestLink: iosTestLinkController.text,
                              alternativeExternalLink:
                                  externalLinkController.text,
                              iconImage: '',
                              androidTestLink: androidTestLinkController.text,
                              allowAndroidTesters: allowAndroidLink,
                              allowiOSTesters: allowiOSLink,
                              description: descController.text);
                          await FirestoreServices.addApplication(
                                  user: widget.user, application: _a)
                              .then((value) => Navigator.pop(context, _a));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              BaseSnackbar.buildSnackBar(context,
                                  message: 'Complete the required information',
                                  success: false));
                        }
                      },
                      label: 'ADD APPLICATION'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
