import 'package:flutter/foundation.dart';

class WebsiteName extends ChangeNotifier {
  static String websiteName = 'www.google.com';

  String get typedWebsite {
    return websiteName;
  }

  void addWebsite(String providedUrl) {
    websiteName = providedUrl;
    notifyListeners();
  }
}
