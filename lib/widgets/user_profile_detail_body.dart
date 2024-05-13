import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:launchpad/models/app.dart';
import 'package:launchpad/models/user.dart';
import 'package:launchpad/pages/add_app_page.dart';
import 'package:launchpad/pages/edit_app_page.dart';
import 'package:launchpad/pages/inquire_page.dart';
import 'package:launchpad/services/auth_service.dart';
import 'package:launchpad/services/fs_services.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/services/storage.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/app_profile_tile.dart';
import 'package:launchpad/widgets/misc/base_snackbar.dart';
import 'package:launchpad/widgets/inputs/base_text_field.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';
import 'package:launchpad/widgets/misc/dev_bit.dart';
import 'package:provider/provider.dart';

class UserProfileBody extends StatefulWidget {
  final UserModel userData;
  final bool isMobileWeb;
  const UserProfileBody(
      {super.key, required this.userData, required this.isMobileWeb});

  @override
  State<UserProfileBody> createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends State<UserProfileBody> {
  TextEditingController nameController = TextEditingController();
  TextEditingController appStoreLink = TextEditingController();
  TextEditingController playStoreLink = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController testLinkController = TextEditingController();
  List<AppModel> _apps = [];

  Future<void> loadApps() async {
    // await Future.delayed(Duration(milliseconds: 400));
    List<AppModel> appsFuture = await FirestoreServices.getAppsForUser(
        userId: FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _apps = appsFuture;
    });
  }

  @override
  void initState() {
    // _fetchUserApps = FirestoreServices.getAppsForUser(
    //     userId: FirebaseAuth.instance.currentUser!.uid);
    loadApps();
    super.initState();
  }

  @override
  void dispose() {
    descController.dispose();
    nameController.dispose();
    playStoreLink.dispose();
    appStoreLink.dispose();
    testLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: widget.isMobileWeb ? 10 : 100),
                child: _UserProfileDetailCard(
                  userData: widget.userData,
                  isMobileWeb: widget.isMobileWeb,
                )),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 100),
            //   child: Row(
            //     children: [
            //       const Text('Technical Skills', style: AppStyles.titleTextStyle),
            //       Padding(
            //         padding: const EdgeInsets.only(left: 12.0),
            //         child: BasicButton(
            //             onClick: () {
            //               //skill applicaiton popup
            //             },
            //             label: 'ADD SKILL'),
            //       )
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 100),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: AppStyles.panelColor,
            //       borderRadius: BorderRadius.circular(22),
            //     ),
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
            //     child: GridView.builder(
            //       shrinkWrap: true,
            //       scrollDirection: Axis.vertical,
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //           childAspectRatio: 8 / 1,
            //           crossAxisSpacing: 12.0,
            //           mainAxisSpacing: 14.0,
            //           crossAxisCount: 3),
            //       itemCount: 8,
            //       itemBuilder: ((context, index) => Container(
            //             padding: const EdgeInsets.symmetric(
            //                 vertical: 2, horizontal: 10),
            //             decoration: BoxDecoration(
            //                 color: const Color.fromARGB(255, 255, 152, 108),
            //                 borderRadius: BorderRadius.circular(22)),
            //             child: Row(
            //               children: [
            //                 GestureDetector(
            //                   child: const Icon(Icons.close, color: Colors.white),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.only(left: 6.0),
            //                   child: FittedBox(
            //                     fit: BoxFit.fitHeight,
            //                     child: Text('MongoDB',
            //                         style: AppStyles.poppinsBold
            //                             .copyWith(color: Colors.white)),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           )),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.isMobileWeb ? 10 : 100),
              child: Row(
                children: [
                  const Text('Applications', style: AppStyles.poppinsBold22),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: BasicButton(
                        isMobile: PlatformServices.isWebMobile,
                        onClick: () async {
                          AppModel _newApp = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => AddApplicationPage(
                                      user: widget.userData)));
                          if (!mounted) return;
                          if (_newApp.launchpadAppId.isNotEmpty) {
                            _apps.add(_newApp);
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                                BaseSnackbar.buildSnackBar(context,
                                    message: 'App added. 3 bits earned!',
                                    success: true));
                          }
                        },
                        label: 'ADD APP'),
                  )
                ],
              ),
            ),
            if (_apps.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.isMobileWeb ? 10 : 100, vertical: 10),
                child: Container(
                    decoration: BoxDecoration(
                      color: AppStyles.panelColor,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'No apps yet',
                        style: AppStyles.poppinsBold22,
                      ),
                    )),
              ),
            if (_apps.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: PlatformServices.isWebMobile ? 10 : 100),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _apps.length,
                  itemBuilder: ((context, index) {
                    return AppProfileTile(
                      isMobileWeb: widget.isMobileWeb,
                      app: _apps[index],
                      ownsApp: true,
                      onEditPress: () async {
                        final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    EditApplicationPage(app: _apps[index])));
                        if (!mounted) return;
                        if (res != _apps[index]) {
                          _apps[index] = res;
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                              BaseSnackbar.buildSnackBar(context,
                                  message: 'App updated!', success: true));
                        }
                      },
                      onDeletePress: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            isScrollControlled: true,
                            builder: (context) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: AppStyles.backgroundColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12))),
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              !widget.isMobileWeb ? 60 : 10),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.red[400],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      child: const Icon(
                                                          Icons.close,
                                                          color: AppStyles
                                                              .iconColor)),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                    'Delete ${_apps[index].name}?',
                                                    style: AppStyles
                                                        .poppinsBold22),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 40),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    await FirestoreServices
                                                        .deleteApp(
                                                            appId: _apps[index]
                                                                .launchpadAppId,
                                                            userId: FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid);
                                                    Navigator.pop(context);
                                                    _apps.removeAt(index);
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            Color(0xFFEF5350)),
                                                    child: Text('DELETE APP',
                                                        style: AppStyles
                                                            .poppinsBold22
                                                            .copyWith(
                                                                fontSize: 20)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                ));
                      },
                    );
                  }),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BasicButton(
                      onClick: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => InquirePage(
                                  isProblem: false,
                                  user: widget.userData,
                                )));
                      },
                      label: 'PROMOTE AN APP'),
                  SizedBox(width: 15),
                  BasicButton(
                      onClick: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => InquirePage(
                                  isProblem: true,
                                  user: widget.userData,
                                )));
                      },
                      label: 'REPORT ISSUE')
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 240),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      Provider.of<AuthService>(context, listen: false).logOut();
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: AppStyles.panelColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.logout,
                            color: Colors.white60, size: 28)),
                  )
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 100),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: AppStyles.panelColor,
            //       borderRadius: BorderRadius.circular(22),
            //     ),
            //     padding: const EdgeInsets.all(20),
            //     child: FutureBuilder(
            //         future: _fetchUserApps,
            //         builder: (context, snapshot) {
            //           if (snapshot.connectionState == ConnectionState.done &&
            //               snapshot.hasData) {
            //             return ListView.builder(
            //               shrinkWrap: true,
            //               itemCount: snapshot.data!.length,
            //               itemBuilder: ((context, index) {
            //                 return Padding(
            //                   padding: const EdgeInsets.symmetric(vertical: 20),
            //                   child: AppProfileTile(
            //                       app: snapshot.data![index], ownsApp: true),
            //                 );
            //               }),
            //             );
            //           } else {
            //             return const Center(
            //               child: CircularProgressIndicator(
            //                 color: AppStyles.actionButtonColor,
            //               ),
            //             );
            //           }
            //         }),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class _UserProfileDetailCard extends StatefulWidget {
  final UserModel userData;
  final bool isMobileWeb;
  const _UserProfileDetailCard(
      {super.key, required this.userData, required this.isMobileWeb});

  @override
  State<_UserProfileDetailCard> createState() => __UserProfileDetailCardState();
}

class __UserProfileDetailCardState extends State<_UserProfileDetailCard> {
  TextEditingController nameController = TextEditingController();
  bool editingName = false;
  late String username;
  String _userPfp = '';
  final List<String> _defaults = const [
    'gizmo.jpg',
    'lady01.jpg',
    'lady02.jpg',
    'lady03.jpg',
    'man01.jpg',
    'man02.jpeg',
    'man03.jpg',
    'monke.jpg',
    'samurai.jpg'
  ];

  @override
  void initState() {
    username = widget.userData.username;
    _userPfp = widget.userData.pfpUrl ?? '';
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _date = widget.userData.dateJoined ?? DateTime.now();
    int _daysDiff = DateTime.now().difference(_date).inDays;
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.panelColor,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: !widget.isMobileWeb
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  builder: (context) => Container(
                        height: widget.isMobileWeb
                            ? MediaQuery.of(context).size.height * 8
                            : MediaQuery.of(context).size.height * .35,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: AppStyles.backgroundColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 20),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red[400],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: const Icon(Icons.close,
                                            color: AppStyles.iconColor)),
                                  ),
                                  SizedBox(width: 10),
                                  Text('SELECT AVATAR',
                                      style: AppStyles.poppinsBold22),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, right: 20),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .9,
                                    height: 85,
                                    child: Wrap(
                                      // shrinkWrap: true,
                                      // scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          _defaults.length,
                                          (index) => Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      _userPfp =
                                                          _defaults[index];
                                                    });
                                                    await FirestoreServices
                                                        .updatePfp(
                                                            _defaults[index],
                                                            widget.userData
                                                                .userId);
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(BaseSnackbar
                                                            .buildSnackBar(
                                                                context,
                                                                message:
                                                                    'Avatar updated',
                                                                success: true));
                                                  },
                                                  child: Container(
                                                    width: 80,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/defaults/${_defaults[index]}'),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ),
                                              )),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
            },
            child: Container(
              width: widget.isMobileWeb ? 60 : 90,
              height: widget.isMobileWeb ? 60 : 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: PlatformServices.renderUserPfp(_userPfp),
                      fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(width: 30),
          Column(
            children: [
              if (editingName)
                Row(
                  children: [
                    SizedBox(
                      width: widget.isMobileWeb
                          ? MediaQuery.of(context).size.width * .35
                          : MediaQuery.of(context).size.width * .2,
                      // height: 50,
                      child: BasicTextField(
                          controller: nameController,
                          hintText: username,
                          maxLength: 28,
                          onSubmitted: (s) async {
                            // //validate and save
                            // String _u = nameController.text.toLowerCase();
                            // if (_u.length > 3) {
                            //   bool _canUpdate =
                            //       await FirestoreServices.updateUsername(_u,
                            //           FirebaseAuth.instance.currentUser!.uid);
                            //   if (_canUpdate) {
                            //     await AppStorage.updateStorageKey(
                            //         key: 'username', newValue: _u);
                            //     setState(() {
                            //       editingName = false;
                            //     });
                            //     username = _u;
                            //   } else {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //         BaseSnackbar.buildSnackBar(context,
                            //             message: 'Username taken',
                            //             success: false));
                            //   }
                            // }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                          onTap: () async {
                            String _u = nameController.text.toLowerCase();
                            if (_u.length > 3) {
                              bool _canUpdate =
                                  await FirestoreServices.updateUsername(_u,
                                      FirebaseAuth.instance.currentUser!.uid);
                              if (_canUpdate) {
                                await AppStorage.updateStorageKey(
                                    key: 'username', newValue: _u);
                                setState(() {
                                  editingName = false;
                                });
                                username = _u;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    BaseSnackbar.buildSnackBar(context,
                                        message: 'Username taken',
                                        success: false));
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppStyles.actionButtonColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(6),
                            child:
                                Icon(Icons.check, color: AppStyles.iconColor),
                          )),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            editingName = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(Icons.edit_off_outlined,
                              color: AppStyles.backgroundColor),
                        )),
                  ],
                ),
              if (!editingName)
                Row(
                  children: [
                    Text(username, style: AppStyles.poppinsBold22),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              editingName = true;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppStyles.actionButtonColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.edit,
                                  color: AppStyles.iconColor))),
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          builder: (context) => Container(
                                height:
                                    MediaQuery.of(context).size.height * .25,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 40, top: 20),
                                decoration: const BoxDecoration(
                                    color: AppStyles.backgroundColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12))),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red[400],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding: const EdgeInsets.all(6),
                                              child: const Icon(Icons.close,
                                                  color: AppStyles.iconColor)),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 12),
                                          child: Text('DEV BITS',
                                              style: AppStyles.poppinsBold22),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .8,
                                        child: Text(
                                            'Dev Bits are a way to represent your engagement on Launchpad. They\re earned by being active on the platform and can be used to unlock platform perks (coming soon)',
                                            softWrap: true,
                                            style: AppStyles.poppinsBold22
                                                .copyWith(fontSize: 18)),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                    },
                    child: DevBit(
                      bitCount: widget.userData.bitCount!,
                    ),
                  ),
                  if (!PlatformServices.isWebMobile)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 6.0),
                      child: Text('Joined: $_daysDiff days ago',
                          style: AppStyles.poppinsBold22
                              .copyWith(fontSize: 14, color: Colors.white70)),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
