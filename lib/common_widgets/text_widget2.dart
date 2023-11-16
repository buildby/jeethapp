import 'package:flutter/material.dart';

import '../colors.dart';

class TextWidgetRoboto extends StatelessWidget {
  final String title;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;

  final double letterSpacing;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  final TextDecoration textDecoration;

  const TextWidgetRoboto({
    super.key,
    required this.title,
    this.color,
    this.fontSize = 13,
    this.height = 1,
    this.fontWeight = FontWeight.normal,
    this.letterSpacing = 0.25,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
    this.textDecoration = TextDecoration.none,
  });

  @override
  Widget build(BuildContext context) {
    final double tS = MediaQuery.of(context).textScaleFactor;

    return Text(
      title,
      style: Theme.of(context).textTheme.headline3!.copyWith(
          fontSize: tS * fontSize,
          color: color ?? getThemeColor(context),
          fontFamily: 'Roboto',
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          decoration: textDecoration,
          height: height),
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
    );
  }
}
