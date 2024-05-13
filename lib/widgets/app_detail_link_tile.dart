import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppLinkTile extends StatelessWidget {
  final bool isPlayStore;
  final Function onClicked;
  const AppLinkTile(
      {super.key, required this.isPlayStore, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onClicked();
        },
        child: Container(
            padding: const EdgeInsets.all(6),
            // height: 50,
            width: 75,
            decoration: BoxDecoration(
                color: isPlayStore ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(6)),
            child: isPlayStore
                ? Center(
                    child: SvgPicture.asset(
                      'assets/svgs/play.svg',
                      width: 22,
                      height: 22,
                    ),
                  )
                : const Center(child: Icon(Icons.apple, color: Colors.white))));
  }
}
