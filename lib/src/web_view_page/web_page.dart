import 'package:easacc_test_app/src/custom_widgets/website_provider.dart';
import 'package:easacc_test_app/src/setting_page/setting_screen.dart';
import 'package:easacc_test_app/src/custom_widgets/global_variables.dart' as globals;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShowWebScreen extends StatefulWidget {
  static final String pageId = 'web';

  @override
  _ShowWebScreenState createState() => _ShowWebScreenState();
}

class _ShowWebScreenState extends State<ShowWebScreen> {
  WebsiteName websiteName;
  WebViewController webViewController;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var key = UniqueKey();
    return Scaffold(
      appBar: AppBar(
        title: Text('Web View'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Icon(Icons.settings),
              onTap: () {
                setState(() {
                  Navigator.pushNamed(context, SettingScreen.pageId);
                });
              },
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                webViewController.loadUrl(globals.gWebsiteName.value);
              });
            },
            child: Icon(Icons.autorenew),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bk5.jpeg"), fit: BoxFit.cover),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          color: Colors.white30,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: WebView(
            key: key,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onProgress: (int progress) {
              print('Page started loading: $progress');
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            initialUrl: globals.gWebsiteName.value,
          ),
        ),
      ),
    );
  }
}
