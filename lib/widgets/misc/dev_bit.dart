import 'package:flutter/material.dart';
import 'package:launchpad/styles/app_styles.dart';

class DevBit extends StatelessWidget {
  final int bitCount;
  const DevBit({super.key, required this.bitCount});

  @override
  Widget build(BuildContext context) {
    _DevBitData _bitData = _DevBitData.getBitData(bitCount);
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        decoration: BoxDecoration(
            gradient: _bitData.gradient != null ? _bitData.gradient : null,
            color: _bitData.bgColor,
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              bitCount.toString(),
              style: AppStyles.poppinsBold22
                  .copyWith(fontSize: 14, color: _bitData.textColor),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.code_rounded,
                  color: _bitData.iconColor,
                  size: 29,
                ),
                //diff based on bits?
                Icon(
                  Icons.circle,
                  color: _bitData.iconColor,
                  size: 4,
                ),
              ],
            ),
          ],
        ));
  }
}

class _DevBitData {
  final Color bgColor;
  final Color textColor;
  final Color iconColor;
  final IconData iconData;
  final int bitCount;
  final Gradient? gradient;

  _DevBitData({
    required this.bgColor,
    required this.textColor,
    required this.iconColor,
    required this.bitCount,
    required this.iconData,
    this.gradient,
  });

  static _DevBitData getBitData(int c) {
    if (c > 100) {
      //purrrrple
      return _DevBitData(
          bitCount: c,
          bgColor: Color(0xFFFFFFFF),
          textColor: Color(0xFFFFFFFF),
          iconColor: Color(0xFFFFFFFF),
          gradient: const LinearGradient(colors: [
            Colors.red,
            Colors.orangeAccent,
            Colors.yellow,
            Colors.greenAccent,
            Colors.cyan,
            Colors.purpleAccent
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          iconData: Icons.star);
    }
    if (c > 50) {
      //purrrrple
      return _DevBitData(
          bitCount: c,
          bgColor: Color(0xFF3B00DE),
          textColor: Color(0xFFFFFFFF),
          iconColor: Color(0xFFFFFFFF),
          iconData: Icons.star);
    }
    if (c > 40) {
      //purple
      return _DevBitData(
          bitCount: c,
          bgColor: Color(0xFFCDC4FF),
          textColor: Color.fromARGB(255, 40, 7, 111),
          iconColor: Color.fromARGB(255, 87, 10, 255),
          iconData: Icons.star_border_outlined);
    }
    if (c > 30) {
      //red
      return _DevBitData(
          bitCount: c,
          bgColor: Color.fromARGB(255, 255, 214, 214),
          textColor: Color.fromARGB(255, 192, 0, 0),
          iconColor: Color.fromARGB(255, 255, 17, 0),
          iconData: Icons.keyboard_double_arrow_up_rounded);
    }
    if (c > 20) {
      //blue
      return _DevBitData(
          bitCount: c,
          bgColor: Color(0xFFB8EDFF),
          textColor: Color.fromARGB(255, 0, 33, 153),
          iconColor: Color(0xFF2752FF),
          iconData: Icons.keyboard_arrow_up_rounded);
    }
    if (c > 10) {
      //green
      return _DevBitData(
          bitCount: c,
          bgColor: Color(0xFFB8FFE1),
          textColor: Color.fromARGB(255, 0, 42, 18),
          iconColor: Color.fromARGB(255, 0, 42, 18),
          iconData: Icons.circle);
    } else {
      //white
      return _DevBitData(
          bitCount: c,
          bgColor: Color.fromARGB(255, 223, 222, 222),
          textColor: Color.fromARGB(255, 47, 47, 47),
          iconColor: Color.fromARGB(255, 0, 0, 0),
          iconData: Icons.circle);
    }
  }
}
