// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

class CustomContainer extends StatefulWidget {
  String name;
  Widget? widgets;
  Function()? onTap;
  final MainAxisAlignment? axisAlignment;
  CustomContainer({
    Key? key,
    required this.name,
    this.widgets,
    this.onTap,
    this.axisAlignment,
  }) : super(key: key);

  @override
  CustomContainerState createState() => CustomContainerState();
}

class CustomContainerState extends State<CustomContainer> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: dW,
        padding: EdgeInsets.only(
            left: dW * 0.03,
            right: dW * 0.03,
            bottom: dW * 0.045,
            top: dW * 0.045),
        decoration: BoxDecoration(
          color: const Color(0xffF8F8F8),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 1,
            color: const Color(0xffEFEFF4),
          ),
        ),
        child: Row(
          mainAxisAlignment: widget.widgets == null
              ? MainAxisAlignment.start
              : (widget.axisAlignment ?? MainAxisAlignment.spaceBetween),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              title: widget.name,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            if (widget.widgets != null) widget.widgets!,
          ],
        ),
      ),
    );
  }
}
