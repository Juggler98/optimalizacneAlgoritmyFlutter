import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/screens/clarke_wright/cw_graph_screen.dart';
import 'package:optimalizacne_algoritmy/widgets/cw_route_item.dart';

import '../../models/clarke_wright/clarke_wright_algorithm.dart';

class RoutesScreen extends StatelessWidget {
  final int centre;
  final double vehicleCapacity;

  RoutesScreen({
    @required this.centre,
    @required this.vehicleCapacity,
    Key key,
  }) : super(key: key);

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final clarkWrightAlgorithm =
        ClarkeWrightAlgorithm(centre: centre, vehicleCapacity: vehicleCapacity);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Clarke Wright algoritmus - kapacity vozidla: $vehicleCapacity'),
        actions: [
          IconButton(
              icon: const Icon(Icons.image),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              tooltip: 'Graficky',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ClarkWrightGraphScreen(
                      clarkWrightAlgorithm: clarkWrightAlgorithm,
                    ),
                  ),
                );
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: clarkWrightAlgorithm.routes.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Žiadne trasy',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: clarkWrightAlgorithm.routes.length,
                        controller: controller,
                        itemBuilder: (ctx, index) {
                          return RouteItem(
                            route: clarkWrightAlgorithm.routesWithCenter[index],
                            track: clarkWrightAlgorithm.tracks[index],
                            trackID: index + 1,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
