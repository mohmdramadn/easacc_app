import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

class ExpandCard extends StatefulWidget {
  @override
  _ExpandCardState createState() => _ExpandCardState();
}

class _ExpandCardState extends State<ExpandCard> {
  int found = 0;
  String noOfdevices;

  @override
  void initState() {
    super.initState();
    getNetworkDevices();
  }

  void getNetworkDevices() async {
    const port = 80;
    final stream = NetworkAnalyzer.discover2(
      '192.168.1.0',
      port,
      timeout: Duration(milliseconds: 5000),
    );
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        found++;
        //print('Found device: ${addr.ip}:$port');
      } else {
        noOfdevices = "Couldn't load devices";
      }
    }).onDone(() => noOfdevices = 'Found $found device(s)');
  }

  Widget numberOfdevices() {
    if (found == 1) {
      return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'No devices connected',
            softWrap: true,
            overflow: TextOverflow.fade,
          ));
    } else {
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            noOfdevices,
            softWrap: true,
            overflow: TextOverflow.fade,
          ));
    }
    return Text('No Devies are connected');
  }

  @override
  Widget build(BuildContext context) {
    getNetworkDevices();
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Wifi/Blutooth connected devices",
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: numberOfdevices(),
                    ),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
                collapsed: null,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
