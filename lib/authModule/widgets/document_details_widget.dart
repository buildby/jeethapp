import 'package:flutter/material.dart';
import 'package:jeeth_app/authModule/providers/auth_provider.dart';
import 'package:jeeth_app/colors.dart';
import 'package:jeeth_app/common_widgets/asset_svg_icon.dart';
import 'package:jeeth_app/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DocumentDetailWidget extends StatefulWidget {
  String name;
  String percentage;
  Function()? onTap;
  DocumentDetailWidget(
      {Key? key, required this.name, required this.percentage, this.onTap})
      : super(key: key);

  @override
  DocumentDetailWidgetState createState() => DocumentDetailWidgetState();
}

class DocumentDetailWidgetState extends State<DocumentDetailWidget> {
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
    // ignore: deprecated_member_use
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              title: widget.name,
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
            Row(
              children: [
                TextWidget(
                  title: widget.percentage.toString(),
                  color: const Color(
                    (0xff868686),
                  ),
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
                SizedBox(
                  width: dW * 0.02,
                ),
                widget.percentage == '100%'
                    ? const AssetSvgIcon(
                        'tick',
                        height: 18,
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: dW * 0.02, vertical: dW * 0.01),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: redColor),
                        child: const AssetSvgIcon(
                          'exclaimation',
                          height: 10,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
