import 'package:flutter/material.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class BaseAppBar extends StatefulWidget {
  final bool showSearch;
  final bool showUser;
  final bool showHome;
  final bool isMobileWeb;
  final Function onLeadPressAction;
  const BaseAppBar(
      {super.key,
      required this.isMobileWeb,
      required this.showSearch,
      required this.showUser,
      required this.onLeadPressAction,
      this.showHome = false});

  @override
  State<BaseAppBar> createState() => _BaseAppBarState();
}

class _BaseAppBarState extends State<BaseAppBar> {
  bool searching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: AppStyles.backgroundColor,
        centerTitle: true,
        leading: widget.showUser
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).pushNamed('/user_profile');
                    widget.onLeadPressAction!();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppStyles.actionButtonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Center(
                          child: const Icon(Icons.person,
                              color: AppStyles.iconColor))),
                ),
              )
            : widget.showHome
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        widget.onLeadPressAction!();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppStyles.actionButtonColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Center(
                            child: Icon(Icons.home_filled,
                                color: AppStyles.iconColor),
                          )),
                    ),
                  )
                : const SizedBox(),
        actions: [
          //switch
          if (widget.showSearch && !widget.isMobileWeb)
            InkWell(
              onTap: () {
                launchUrl(Uri.parse('https://www.buymeacoffee.com/thenormal'));
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Image.network(
                    'https://helloimjessa.files.wordpress.com/2021/06/bmc-button.png',
                    width: 200,
                    fit: BoxFit.contain),
              ),
            ),
          if (widget.showSearch && widget.isMobileWeb)
            InkWell(
              onTap: () {
                launchUrl(Uri.parse('https://www.buymeacoffee.com/thenormal'));
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  width: 46,
                  // height: 28,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFDD835),
                      borderRadius: BorderRadius.circular(8)),
                  child: SvgPicture.asset(
                    width: 20,
                    height: 20,
                    'assets/svgs/coffee.svg',
                  ),
                ),
              ),
            )
          // if (!searching && widget.showSearch)
          //   Padding(
          //     padding: const EdgeInsets.only(right: 14.0),
          //     child: GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             searching = true;
          //           });
          //         },
          //         child: const Icon(Icons.search_rounded,
          //             size: 36, color: AppStyles.iconColor)),
          //   )
        ],
        title: !widget.isMobileWeb
            ? Text('< 🚀 >  Launchpad',
                style: AppStyles.poppinsBold22.copyWith(fontSize: 26))
            : Text(' 🚀   Launchpad',
                style: AppStyles.poppinsBold22.copyWith(fontSize: 20))
        // : Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Container(
        //         width: MediaQuery.of(context).size.width * .3,
        //         height: 50,
        //         decoration: BoxDecoration(
        //             color: AppStyles.panelColor,
        //             borderRadius: BorderRadius.circular(18)),
        //         child: TextField(
        //           cursorHeight: 30,
        //           maxLength: 30,
        //           cursorColor: Colors.white,
        //           controller: searchController,
        //           style: AppStyles.poppinsBold.copyWith(fontSize: 18),
        //           maxLines: 1,
        //           expands: false,
        //           decoration: InputDecoration(
        //             contentPadding: EdgeInsets.all(0),
        //             hintText: 'Search apps...',
        //             hintStyle: AppStyles.poppinsBold.copyWith(
        //                 fontSize: 16,
        //                 color: const Color.fromARGB(255, 73, 91, 99)),
        //             fillColor: AppStyles.panelColor,
        //             border: InputBorder.none,
        //             disabledBorder: InputBorder.none,
        //             counter: const SizedBox(),
        //           ),
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(right: 14.0),
        //         child: IconButton(
        //             onPressed: () {
        //               setState(() {
        //                 searching = false;
        //               });
        //             },
        //             icon: const Icon(Icons.cancel_outlined,
        //                 size: 32, color: AppStyles.iconColor)),
        //       )
        // ],
        // ),
        );
  }
}
