import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:quria/constants/texts.dart';
import 'package:quria/data/services/bungie_api/enums/destiny_data.dart';

class VerticalStatisticDisplay extends StatelessWidget {
  final int value;
  final String icon;
  final double width;
  final double fontsize;
  final MainAxisAlignment mainAxisAlignment;
  const VerticalStatisticDisplay(
      {Key? key,
      required this.value,
      required this.icon,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.width = 40,
      this.fontsize = 25})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String link = '${DestinyData.bungieLink}$icon?t=123456';
    return SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width,
              child: ExtendedImage.network(
                link,
                height: width,
                width: width,
                timeLimit: const Duration(seconds: 10),
                cache: true,
                filterQuality: FilterQuality.high,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: width,
              child: Center(child: textCaptionBold('$value')),
            ),
          ],
        ));
  }
}
