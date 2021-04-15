import 'package:easacc_test_app/src/setting_page/setting_screen.dart';
import 'package:easacc_test_app/src/social_media_page/social_media_screen.dart';
import 'package:easacc_test_app/src/web_view_page/web_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/website_provider.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WebsiteName(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(
            color: Color(0xff060709),
          )
        ),
        initialRoute: SocialMediaScreen.pageId,
        routes: {
          SocialMediaScreen.pageId: (context) => SocialMediaScreen(),
          ShowWebScreen.pageId: (context) => ShowWebScreen(),
          SettingScreen.pageId: (context) => SettingScreen(),
        },
      ),
    );
  }
}
