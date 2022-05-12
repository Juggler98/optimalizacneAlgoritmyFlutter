import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:optimalizacne_algoritmy/application.dart';
import 'package:optimalizacne_algoritmy/models/node.dart';
import 'package:path_provider/path_provider.dart';

import '../models/edge.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  Random random = Random();
  final Graph graph = Graph();
  Algorithm? builder;

  final app = Application();

  @override
  void initState() {
    super.initState();

    print('GraphScreen');

    // final a = Node.Id(1);
    // final b = Node.Id(2);
    // final c = Node.Id(3);
    // final d = Node.Id(4);
    // final e = Node.Id(5);
    // final f = Node.Id(6);
    // final g = Node.Id(7);
    // final h = Node.Id(8);

    // graph.addEdge(a, b, paint: Paint()..color = Colors.red);
    // graph.addEdge(a, c);
    // graph.addEdge(a, d);
    // graph.addEdge(c, e);
    // graph.addEdge(d, f);
    // graph.addEdge(f, c);
    // graph.addEdge(g, c);
    // graph.addEdge(h, g);
    // graph.addEdge(a, h, paint: Paint()..color = Colors.green);
    // graph.addEdge(a, e, paint: Paint()..color = Colors.green);

    List<Node> graphicsNodes = [];
    for (int i = 0; i < app.uzly.length; i++) {
      graphicsNodes.add(Node.Id(app.uzly[i].id + 1));
    }
    graph.addNodes(graphicsNodes);
    for (int i = 0; i < app.uzly.length; i++) {
      Hrana? nodeEdge = app.uzly[i].edge;
      while (nodeEdge != null) {
        graph.addEdge(graphicsNodes[nodeEdge.from], graphicsNodes[nodeEdge.to]);
        nodeEdge = nodeEdge.getNextEdge(i);
      }
    }
    setState(() {
      builder = FruchtermanReingoldAlgorithm(iterations: 1);
    });

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          //mainAxisSize: MainAxisSize.max,
          children: [
            builder == null
                ? Text('Loading')
                : Expanded(
                    child: InteractiveViewer(
                        constrained: false,
                        boundaryMargin: EdgeInsets.all(8),
                        minScale: 0.001,
                        maxScale: 100,
                        child: GraphView(
                            graph: graph,
                            algorithm: builder!,
                            paint: Paint()
                              ..color = Colors.green
                              ..strokeWidth = 5
                              ..style = PaintingStyle.fill,
                            builder: (Node node) {
                              // I can decide what widget should be shown here based on the id
                              var a = node.key!.value as int?;
                              if (a == 2) {
                                return rectangWidget(a);
                              }
                              return rectangWidget(a);
                            })),
                  ),
          ],
        ));
  }

  Widget rectangWidget(int? i) {
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.blue, spreadRadius: 1),
          ],
        ),
        child: Text('Node $i'));
  }
}
