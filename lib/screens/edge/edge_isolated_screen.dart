import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/widgets/edge_item.dart';
import 'package:provider/provider.dart';

import '../../application.dart';
import '../../models/edge.dart';

class EdgeIsolatedScreen extends StatelessWidget {
  EdgeIsolatedScreen({Key key}) : super(key: key);

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izolované hrany'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<Application>(builder: (ctx, app, _) {
                List<Edge> edges = [];
                for (var edge in app.allEdges) {
                  final nodeFrom = app.getNode(edge.from);
                  final nodeTo = app.getNode(edge.to);
                  if (nodeFrom == null || nodeTo == null) {
                    edges.add(edge);
                  }
                }
                return Container(
                  child: app.loading
                      ? const Center(child: CircularProgressIndicator())
                      : edges.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Žiadne izolované hrany',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                            )
                          : ListView(
                              controller: controller,
                              children:
                                  edges.map((e) => EdgeItem(edge: e)).toList(),
                            ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
