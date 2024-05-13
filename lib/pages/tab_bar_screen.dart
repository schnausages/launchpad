import 'package:flutter/material.dart';
import 'package:launchpad/pages/user_profile.page.dart';
import 'package:launchpad/pages/view_apps_page.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/home_screen/home_page_posts.dart';
import 'package:get/get.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  final PageController pageController = PageController();
  int _selectedIndex = 0;
  List<Widget> _pages = [HomePagePosts(), UserProfile(), ViewAppsPage()];
  final Color _activeColor = Color(0xFFFFFFFF);
  final Color _inactiveColor = Colors.white54;
  void _onPageChanged(int index) {
    //flutter provides us an index to access automatically
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTabTapped(int selectedIndex) {
    pageController.jumpToPage(selectedIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size s = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppStyles.backgroundColor,

      // appBar: PreferredSize(
      //     preferredSize: Size(double.infinity, 60),
      //     child: BaseAppBar(
      //       showSearch: true,
      //       showUser: true,
      //       isMobileWeb: PlatformServices.isWebMobile,
      //       onLeadPressAction: () {
      //         Get.to(() => UserProfile());
      //       },
      //     )),
      body: PageView(
        onPageChanged: _onPageChanged,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        // height: 80,

        width: s.width,
        height: s.height * .08,
        color: AppStyles.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  _onTabTapped(0);
                },
                icon: Icon(Icons.home_filled,
                    color:
                        _selectedIndex == 0 ? _activeColor : _inactiveColor)),
            IconButton(
                onPressed: () {
                  _onTabTapped(1);
                },
                icon: Icon(Icons.list,
                    color:
                        _selectedIndex == 1 ? _activeColor : _inactiveColor)),
            IconButton(
                onPressed: () {
                  _onTabTapped(2);
                },
                icon: Icon(Icons.person,
                    color:
                        _selectedIndex == 2 ? _activeColor : _inactiveColor)),
          ],
        ),
      ),
    );
  }
}
