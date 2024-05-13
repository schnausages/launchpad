import 'package:flutter/material.dart';
import 'package:launchpad/pages/view_apps_page.dart';
import 'package:launchpad/services/platform_services.dart';
import 'package:launchpad/styles/app_styles.dart';
import 'package:launchpad/widgets/inputs/basic_button.dart';

const String _joinSub =
    'Joining Launchpad is (and will always be) FREE. It is funded through community donations.';

const String _wutSub =
    'Launchpad helps developers find testers, early users, and real feedback on their apps before or after launch.';

class MobileLandingBody extends StatelessWidget {
  final Function onJoinTap;
  const MobileLandingBody({super.key, required this.onJoinTap});

  @override
  Widget build(BuildContext context) {
    final Size _s = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _LandingBodyPanel(
              acitonTitle: 'JOIN',
              w: _s.width * .9,
              h: _s.height * .65,
              header: 'JOIN FOR FREE',
              actionClick: () {
                onJoinTap();
              },
              subtitle: _joinSub,
              icon: Text('👋', style: AppStyles.titleTextStyle)),
          SizedBox(height: 20),
          _LandingBodyPanel(
              acitonTitle: "SEE APPS",
              w: _s.width * .9,
              h: _s.height * .65,
              header: 'WHAT IS IT',
              actionClick: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const ViewAppsPage()));
              },
              subtitle: _wutSub,
              icon: Text('🙂')),
        ],
      ),
    );
  }
}

class DesktopHomeBody extends StatelessWidget {
  final Function onJoinTap;
  const DesktopHomeBody({super.key, required this.onJoinTap});

  @override
  Widget build(BuildContext context) {
    final Size _s = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LandingBodyPanel(
            acitonTitle: 'JOIN NOW',
            w: _s.width * .4,
            h: _s.height * .6,
            header: 'JOIN FOR FREE',
            actionClick: () {
              onJoinTap();
            },
            subtitle: _joinSub,
            icon: Text('👋', style: AppStyles.titleTextStyle)),
        _LandingBodyPanel(
            acitonTitle: "SEE APPS",
            w: _s.width * .4,
            h: _s.height * .6,
            header: 'WHAT IS IT',
            actionClick: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const ViewAppsPage()));
            },
            subtitle: _wutSub,
            icon: Text('🙂', style: AppStyles.titleTextStyle)),
      ],
    );
  }
}

class _LandingBodyPanel extends StatelessWidget {
  final double w;
  final double h;
  final String header;
  final String subtitle;
  final Widget icon;
  final Function actionClick;
  final String acitonTitle;
  const _LandingBodyPanel(
      {super.key,
      required this.acitonTitle,
      required this.header,
      required this.actionClick,
      required this.subtitle,
      required this.icon,
      required this.w,
      required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: AppStyles.panelColor, borderRadius: BorderRadius.circular(22)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              Text(
                header,
                style: AppStyles.titleTextStyle,
                softWrap: true,
              )
            ],
          ),
          SizedBox(height: 15),
          Text(subtitle, style: AppStyles.poppinsBold22.copyWith(fontSize: 20)),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: BasicButton(
                isMobile: PlatformServices.isWebMobile,
                onClick: () {
                  actionClick();
                },
                label: acitonTitle),
          )
        ],
      ),
    );
  }
}
