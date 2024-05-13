import 'package:flutter/material.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/inputs/base_text_field.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';

class EditApplicationPage extends StatefulWidget {
  final AppModel app;
  const EditApplicationPage({super.key, required this.app});

  @override
  State<EditApplicationPage> createState() => _EditApplicationPageState();
}

class _EditApplicationPageState extends State<EditApplicationPage> {
  late TextEditingController nameController;
  late TextEditingController appStoreLink;
  late TextEditingController playStoreLink;
  late TextEditingController descController;
  late TextEditingController testLinkController;
  late TextEditingController androidTestLinkController;
  late TextEditingController externalLinkController;
  List _seeking = [];
  String _appCategory = '';
  bool _inAppStore = false;

  final Text optionalText = const Text('[optional]',
      style: TextStyle(fontSize: 12, color: Colors.white));
  final SizedBox _heightBox = const SizedBox(height: 45);
  final TextStyle _titleStyle = AppStyles.poppinsBold22.copyWith(fontSize: 16);
  final List<String> categories = PlatformServices.appCategories;

  @override
  void initState() {
    _appCategory = widget.app.appCategory!;
    nameController = TextEditingController(text: widget.app.name);
    appStoreLink = TextEditingController(text: widget.app.appStoreLink ?? '');
    playStoreLink = TextEditingController(text: widget.app.playStoreLink ?? '');
    descController = TextEditingController(text: widget.app.description ?? '');
    externalLinkController =
        TextEditingController(text: widget.app.alternativeExternalLink ?? '');
    testLinkController =
        TextEditingController(text: widget.app.iosTestLink ?? '');
    androidTestLinkController =
        TextEditingController(text: widget.app.androidTestLink ?? '');
    _seeking = widget.app.seeking ?? [];
    super.initState();
  }

  @override
  void dispose() {
    descController.dispose();
    nameController.dispose();
    playStoreLink.dispose();
    appStoreLink.dispose();
    externalLinkController.dispose();
    testLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _s = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppStyles.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Edit ${widget.app.name}', style: AppStyles.poppinsBold22),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, widget.app);
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
          padding: EdgeInsets.symmetric(horizontal: _s.width > 800 ? 160 : 10),
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
                          controller: appStoreLink, hintText: 'Paste link...'),
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
                          controller: playStoreLink, hintText: 'Paste link...'),
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
                            : Colors.white12,
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
                            : Colors.white12,
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
                          const Icon(
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
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
                          Text('iOS link (optional)',
                              style: AppStyles.poppinsBold22
                                  .copyWith(fontSize: 16)),
                        ],
                      ),
                      BasicTextField.singleLine(
                          controller: testLinkController,
                          hintText: 'Paste iOS link...'),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text('Android link (optional)',
                              style: AppStyles.poppinsBold22
                                  .copyWith(fontSize: 16)),
                        ],
                      ),
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
                      AppModel a = AppModel(
                          isFeatured: widget.app.isFeatured,
                          appOwnerId: widget.app.appOwnerId,
                          appCategory: _appCategory,
                          appOwnerInfo: widget.app.appOwnerInfo,
                          name: nameController.text,
                          launchpadAppId: widget.app.launchpadAppId,
                          seeking: _seeking,
                          playStoreLink: playStoreLink.text,
                          appStoreLink: appStoreLink.text,
                          iosTestLink: testLinkController.text,
                          androidTestLink: androidTestLinkController.text,
                          iconImage: widget.app.iconImage,
                          alternativeExternalLink: externalLinkController.text,
                          description: descController.text);
                      await FirestoreServices.editApplication(application: a)
                          .then((value) => Navigator.pop(context, a));
                    },
                    label: 'UPDATE APP'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
