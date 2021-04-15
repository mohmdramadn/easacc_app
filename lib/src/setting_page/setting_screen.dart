import 'package:easacc_test_app/src/custom_widgets/expand_card.dart';
import 'package:easacc_test_app/src/custom_widgets/global_variables.dart'
    as globals;
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  static final String pageId = 'setting';
  final textController = TextEditingController();


  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String websiteName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bk5.jpeg"), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Card(
              color: Colors.white30,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Type desired website',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: widget.textController
                        ..text = globals.gWebsiteName.value,
                      onChanged: (value) {
                        websiteName = value;
                        print(widget.textController);
                      },
                      decoration: InputDecoration(
                        hintText: "Type website name here",
                        icon: Icon(Icons.http),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    child: TextButton(
                      onPressed: () {
//                        Provider.of<WebsiteName>(context)
//                            .addWebsite(widget.websiteName);
                        globals.gWebsiteName.value = websiteName;
                        Navigator.pop(context);
                      },
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
            ExpandCard(),
          ],
        ),
      ),
    );
  }
}
