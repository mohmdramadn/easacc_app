import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebCard extends StatefulWidget {
  final String website;


  MyWebCard({@required this.website});

  @override
  _MyWebCardState createState() => _MyWebCardState();
}

class _MyWebCardState extends State<MyWebCard> {
  WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
//  void reloadView(){
//    webViewController?.reload();
//  }

  @override
  Widget build(BuildContext context) {
    var key;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      color: Colors.white30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: WebView(
        key: key,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller){
          webViewController = controller;
        },
        onProgress: (int progress) {
          print('Page started loading: $progress');
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        initialUrl: widget.website,
      ),
    );
  }
}
