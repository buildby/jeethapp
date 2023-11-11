import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import '../colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Icon? backIcon;
  final double dW;
  final double elevation;
  final Function? actionMethod;
  final List<Widget>? actions;
  final Color? bgColor;
  final bool? centerTitle;
  final int fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? customTopMargin;

  CustomAppBar({
    super.key,
    this.title = '',
    this.leading,
    this.fontSize = 18,
    this.fontWeight,
    this.fontFamily,
    this.backIcon,
    required this.dW,
    this.elevation = 0.0,
    this.actionMethod,
    this.actions,
    this.bgColor,
    this.centerTitle,
    this.customTopMargin,
  });

  double get topMargin => Platform.isIOS ? 0 : (customTopMargin ?? 0.03);

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Container(
      margin: EdgeInsets.only(top: dW * topMargin),
      child: AppBar(
        centerTitle: centerTitle,
        backgroundColor: bgColor ?? themeColor,
        elevation: elevation,
        leadingWidth: dW * 0.15,
        leading: leading ??
            GestureDetector(
              onTap: () {
                if (actionMethod != null) {
                  actionMethod!();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Center(
                child: backIcon ??
                    (Platform.isIOS
                        ? const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 22, color: backButtonColor)
                        : const Icon(Icons.arrow_back_ios_new,
                            color: backButtonColor)),
              ),
            ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline1!.copyWith(
                color: appBarTitleColor,
                fontSize: textScale * fontSize,
                fontWeight: fontWeight,
                fontFamily: fontFamily,
              ),
        ),
        titleSpacing: 0,
        actions: actions ?? [],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(dW * (0.145 + topMargin));
}
