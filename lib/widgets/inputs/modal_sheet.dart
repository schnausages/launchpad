import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/inputs/base_text_field.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';

buildModalSheet(
  BuildContext context, {
  required String title,
  required TextEditingController controller,
  required Function(String, AppModel) onSubmitPress,
  bool isCreatePost = false,
}) async {
  Future<List<AppModel>> _loadUserApps = FirestoreServices.getAppsForUser(
      userId: FirebaseAuth.instance.currentUser!.uid);
  TextEditingController _linkController = TextEditingController();
  int _i = -1;
  bool _showLinkField = false;

  AppModel _mentionedApp =
      AppModel(name: '', launchpadAppId: '', appOwnerId: '');
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      builder: (context) => Container(
            height: MediaQuery.of(context).size.height * .95,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: AppStyles.backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.close,
                                  color: AppStyles.iconColor)),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(title,
                              style: AppStyles.poppinsBold22
                                  .copyWith(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextField(
                      cursorColor: const Color(0xFFFEFFF4),
                      obscureText: false,
                      keyboardType: TextInputType.multiline,
                      onSubmitted: (_) {},
                      maxLines: 10,
                      minLines: 1,
                      maxLength: 1200,
                      autofocus: true,
                      style: AppStyles.poppinsBold22.copyWith(fontSize: 16),
                      controller: controller,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        fillColor: AppStyles.panelColor,
                        hintText: '',
                        hintStyle: AppStyles.poppinsBold22
                            .copyWith(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BasicButton(
                            isMobile: PlatformServices.isWebMobile,
                            onClick: () {
                              if (controller.text.isNotEmpty) {
                                onSubmitPress(
                                    _linkController.text, _mentionedApp);
                              }
                            },
                            label: 'SEND'),
                      ],
                    ),
                  ),
                  // if (isCreatePost)
                  StatefulBuilder(builder: (context, setState) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showLinkField = !_showLinkField;
                            });
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: _showLinkField
                                  ? Colors.lightBlue[200]
                                  : Colors.white70,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.insert_link,
                                color: _showLinkField
                                    ? Colors.blue[800]
                                    : AppStyles.panelColor),
                          ),
                        ),
                        if (_showLinkField)
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: BasicTextField.singleLine(
                                  onSubmitted: (s) {},
                                  autofocus: true,
                                  controller: _linkController),
                            ),
                          ),
                      ],
                    );
                  }),
                  if (isCreatePost)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Mention your app',
                              style: AppStyles.poppinsBold22
                                  .copyWith(fontSize: 14))
                        ],
                      ),
                    ),
                  if (isCreatePost)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: StatefulBuilder(builder: (context, setState) {
                        return FutureBuilder(
                            future: _loadUserApps,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: InkWell(
                                        onTap: () {
                                          if (_i == index) {
                                            setState(
                                              () {
                                                _mentionedApp = AppModel(
                                                    name: '',
                                                    launchpadAppId: '',
                                                    appOwnerId: '');
                                                _i = -1;
                                              },
                                            );
                                          } else {
                                            setState(() {
                                              _mentionedApp =
                                                  snapshot.data![index];

                                              _i = index;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 4),
                                          decoration: BoxDecoration(
                                              color: _i == index
                                                  ? AppStyles.actionButtonColor
                                                  : AppStyles.panelColor,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Center(
                                            child: Text(
                                                snapshot.data![index].name,
                                                style: AppStyles.poppinsBold22
                                                    .copyWith(fontSize: 16)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return CircularProgressIndicator(
                                  color: AppStyles.actionButtonColor,
                                );
                              }
                            });
                      }),
                    )
                ]),
              ),
            ),
          )).then((value) {
    controller.clear();
    _linkController.dispose();
  });
}
