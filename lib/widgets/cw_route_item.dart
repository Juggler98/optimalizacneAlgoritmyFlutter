import 'dart:io';

import 'package:flutter/material.dart';

class RouteItem extends StatelessWidget {
  final List<int> route;
  final List<int> track;
  final int trackID;

  const RouteItem({
    @required this.route,
    @required this.track,
    @required this.trackID,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String routeStr = '';
    String trackStr = '';

    var index = 0;
    for (var node in route) {
      routeStr += (index == 0 ? '' : ' -> ') + node.toString();
      index++;
    }

    index = 0;
    for (var node in track) {
      trackStr += (index == 0 ? '' : ' -> ') + node.toString();
      index++;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Platform.isWindows ? 80.0 : 16.0, vertical: 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
        child: ListTile(
          leading: Text('Trasa $trackID'),
          title: Column(
            children: [
              Text('Obslúžené uzly: ' + routeStr),
              const SizedBox(height: 8),
              Text('Presná trasa: ' + trackStr),
            ],
          ),
        ),
      ),
    );
  }
}
