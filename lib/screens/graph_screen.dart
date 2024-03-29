import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:optimalizacne_algoritmy/application.dart';

import '../models/edge.dart' as my_edge;
import '../models/two_three_tree/two_three_tree.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key key}) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final Graph graph = Graph();
  Algorithm builder;

  final app = Application();

  @override
  void initState() {
    super.initState();

    TTTree<num, Node> graphicsNodes = TTTree();

    final intervalNodes =
        app.nodesCount > 20 ? app.getIntervalNodes(0, 20) : app.allNodes;
    final allNodes = app.allNodes;

    for (var node in allNodes) {
      graphicsNodes.add(Node.Id(node.id));
    }

    if (app.nodesCount < 50) {
      graph.addNodes(graphicsNodes.getInOrderData());
    }

    for (var node in intervalNodes) {
      my_edge.Edge nodeEdge = node.edge;
      while (nodeEdge != null) {
        if (nodeEdge.active) {
          final node1 = graphicsNodes.search(Node.Id(nodeEdge.from));
          final node2 = graphicsNodes.search(Node.Id(nodeEdge.to));
          graph.addEdge(node1, node2);
        }
        nodeEdge = nodeEdge.getNextEdge(node.id);
      }
    }

    setState(() {
      builder = FruchtermanReingoldAlgorithm(
        iterations: 1000,
        attractionRate: 0.12,
        graphWidth: 300,
        graphHeight: 300,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      //mainAxisSize: MainAxisSize.max,
      children: [
        builder == null
            ? const Center(child: Text('Loading'))
            : Expanded(
                child: InteractiveViewer(
                    constrained: false,
                    boundaryMargin: const EdgeInsets.all(8),
                    minScale: 0.001,
                    maxScale: 100,
                    child: GraphView(
                        graph: graph,
                        algorithm: builder,
                        paint: Paint()
                          ..color = Colors.green
                          ..strokeWidth = 5
                          ..style = PaintingStyle.fill,
                        builder: (Node node) {
                          var a = node.key.value as int;
                          if (a == 2) {
                            return nodeWidget(a);
                          }
                          return nodeWidget(a);
                        })),
              ),
      ],
    ));
  }

  Widget nodeWidget(int i) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.blue, spreadRadius: 1),
          ],
        ),
        child: Text('$i'));
  }
}
