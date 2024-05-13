import 'package:flutter/material.dart';
import 'package:launchpad/styles/app_styles.dart';

class IntroTinyTile extends StatelessWidget {
  final String text;
  final String sheetMessage;
  final bool isMobileWeb;
  final Widget displayyWidget;
  final double w;
  final double h;
  const IntroTinyTile(
      {super.key,
      required this.h,
      required this.sheetMessage,
      required this.isMobileWeb,
      required this.w,
      required this.text,
      required this.displayyWidget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            elevation: 0,
            isScrollControlled: true,
            builder: (context) => Container(
                  height: isMobileWeb
                      ? MediaQuery.of(context).size.height * .4
                      : MediaQuery.of(context).size.height * .25,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: isMobileWeb ? 8 : 40, top: 20),
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(Icons.close,
                                    color: AppStyles.iconColor)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(text,
                                style: AppStyles.poppinsBold22
                                    .copyWith(fontSize: 18)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: SizedBox(
                              width: isMobileWeb
                                  ? MediaQuery.of(context).size.width * .9
                                  : MediaQuery.of(context).size.width * .8,
                              child: Text(sheetMessage,
                                  softWrap: true,
                                  style: AppStyles.poppinsBold22
                                      .copyWith(fontSize: 16)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ));
      },
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
            color: AppStyles.panelColor,
            borderRadius: BorderRadius.circular(isMobileWeb ? 8 : 16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            displayyWidget,
            Text(text,
                softWrap: true,
                textAlign: TextAlign.center,
                style: AppStyles.poppinsBold22.copyWith(
                    fontSize: isMobileWeb ? 14 : 16,
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
