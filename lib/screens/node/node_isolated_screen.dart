import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/widgets/node_item.dart';
import 'package:provider/provider.dart';

import '../../application.dart';
import '../../models/edge.dart';
import '../../models/node.dart';

class NodeIsolatedScreen extends StatelessWidget {
  NodeIsolatedScreen({Key key}) : super(key: key);

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izolované uzly'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<Application>(builder: (ctx, app, _) {
                List<Node> nodes = [];
                for (var node in app.allNodes) {
                  if (node.edge == null) {
                    nodes.add(node);
                  }

                  var active = false;
                  var edge = node.edge;
                  while (edge != null) {
                    if (edge.active) {
                      active = true;
                      break;
                    }
                    edge = edge.getNextEdge(node.id);
                  }
                  if (!active) {
                    nodes.add(node);
                  }
                }
                return Container(
                  child: app.loading
                      ? const Center(child: CircularProgressIndicator())
                      : nodes.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Žiadne izolované uzly',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                            )
                          : ListView(
                              controller: controller,
                              children:
                                  nodes.map((e) => NodeItem(node: e)).toList(),
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
