import 'package:flutter/material.dart';
import 'package:quria/constants/styles.dart';
import 'package:quria/constants/texts.dart';

Widget mobileHeader(BuildContext context,
    {required String imageLink, required Widget child}) {
  return Container(
    alignment: Alignment.bottomCenter,
    width: vw(context),
    height: vw(context) * 0.9,
    decoration: BoxDecoration(
        image: DecorationImage(
            alignment: Alignment.topRight,
            fit: BoxFit.fitHeight,
            image: NetworkImage(imageLink))),
    child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              black.withOpacity(0),
              black.withOpacity(1),
            ],
          ),
        ),
        alignment: Alignment.bottomCenter,
        height: vw(context) / 3.17,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: globalPadding(context)),
            child: child)),
  );
}

Widget mobileSection(
  BuildContext context, {
  required String title,
  required Widget child,
}) {
  return Padding(
    padding: EdgeInsets.only(top: globalPadding(context)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textH2(title),
        const Divider(
          color: blackLight,
          height: 22,
          thickness: 1,
        ),
        child
      ],
    ),
  );
}

Widget mobileCard(
  BuildContext context, {
  required Widget child,
}) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: globalPadding(context)) * 0.875,
      decoration: const BoxDecoration(
          color: blackLight,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      width: double.infinity,
      child: child);
}