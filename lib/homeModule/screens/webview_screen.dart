import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeeth_app/common_widgets/custom_app_bar.dart';
import 'package:jeeth_app/navigation/arguments.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_webview_pro/webview_flutter.dart';

import '../../common_widgets/circular_loader.dart';
import '../../common_widgets/custom_dialog.dart';

class WebviewScreen extends StatefulWidget {
  final WebviewScreenArguments args;

  const WebviewScreen({super.key, required this.args});

  @override
  State<WebviewScreen> createState() => _InAppBrowserScreenState();
}

class _InAppBrowserScreenState extends State<WebviewScreen> {
  bool isLoading = true;

  bool iOSCondition(double dH) => Platform.isIOS && dH > 850;

  WebViewController? controller;

  setController() {
    // controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setBackgroundColor(const Color(0x00000000))
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onPageStarted: (String url) {
    //         if (isLoading) setState(() => isLoading = false);
    //       },
    //       onNavigationRequest: (NavigationRequest request) {
    //         return NavigationDecision.navigate;
    //       },
    //       onUrlChange: (change) {},
    //     ),
    //   )
    //   ..loadRequest(Uri.parse(link));
  }

  Future<bool> goBack() async {
    // bool canGoBack = await controller!.canGoBack();
    // if (canGoBack) {
    //   controller!.goBack();
    // } else {
    //   closeApp();
    // }
    // return false;
    return true;
  }

  closeApp() {
    return showDialog(
      context: context,
      builder: ((context) => CustomDialog(
            title: "Are you sure you want to exit the application?",
            noText: 'No',
            yesText: 'Yes',
            subTitle: '',
            noFunction: () {
              Navigator.of(context).pop();
            },
            yesFunction: () async {
              Navigator.of(context).pop();
              SystemNavigator.pop();
            },
          )),
    );
  }

  requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    setController();
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) controller!.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    final dH = MediaQuery.of(context).size.height;
    final dW = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () => goBack(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.args.title,
          dW: dW,
          customTopMargin: 0,
        ),
        body:
            // iOSCondition(dH) ? screenBody(dW) :
            screenBody(dW),
      ),
    );
  }

  screenBody(double dW) {
    return Stack(
      children: [
        WebView(
          initialUrl: widget.args.link,
          zoomEnabled: false,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (String url) {
            setState(() => isLoading = false);
          },
          onWebViewCreated: (WebViewController webViewController) {
            controller = webViewController;
          },
        ),
        if (isLoading) const CircularLoader()
      ],
    );
  }
}
