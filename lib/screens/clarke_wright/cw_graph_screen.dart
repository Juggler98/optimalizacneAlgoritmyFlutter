import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:optimalizacne_algoritmy/application.dart';
import 'package:optimalizacne_algoritmy/widgets/cw_route_item.dart';

import '../../models/clarke_wright/clarke_wright_algorithm.dart';
import '../../models/edge.dart' as my_edge;
import '../../models/two_three_tree/two_three_tree.dart';

class ClarkWrightGraphScreen extends StatefulWidget {
  final ClarkeWrightAlgorithm clarkWrightAlgorithm;

  const ClarkWrightGraphScreen({@required this.clarkWrightAlgorithm, Key key})
      : super(key: key);

  @override
  _ClarkWrightGraphScreenState createState() => _ClarkWrightGraphScreenState();
}

class _ClarkWrightGraphScreenState extends State<ClarkWrightGraphScreen> {
  final List<Graph> graphs = [];
  final List<Algorithm> builders = [];

  final app = Application();

  void init() {
    for (int i = 0; i < widget.clarkWrightAlgorithm.routes.length; i++) {
      graphs.add(Graph());

      final TTTree<num, Node> graphicsNodes = TTTree();

      final intervalNodes =
          app.nodesCount > 50 ? app.getIntervalNodes(0, 50) : app.allNodes;
      final allNodes = app.allNodes;

      for (var node in allNodes) {
        graphicsNodes.add(Node.Id(node.id));
      }

      if (app.nodesCount < 50) {
        graphs[i].addNodes(graphicsNodes.getInOrderData());
      }

      for (var node in intervalNodes) {
        my_edge.Edge nodeEdge = node.edge;
        while (nodeEdge != null) {
          if (nodeEdge.active) {
            final node1 = graphicsNodes.search(Node.Id(nodeEdge.from));
            final node2 = graphicsNodes.search(Node.Id(nodeEdge.to));
            graphs[i].addEdge(node1, node2,
                paint: Paint()
                  ..color = Colors.black54
                  ..strokeWidth = 1
                  ..style = PaintingStyle.stroke);
          }
          nodeEdge = nodeEdge.getNextEdge(node.id);
        }
      }

      final track = widget.clarkWrightAlgorithm.tracks[i];
      for (int j = 0; j < track.length - 1; j++) {
        setEdgeColor(graphicsNodes, track[j], track[j + 1], i);
      }

      setState(() {
        builders.add(FruchtermanReingoldAlgorithm(
          iterations: 1,
          attractionRate: 0.11,
          graphWidth: 100,
          graphHeight: 100,
        ));
      });
    }
  }

  void setEdgeColor(
      TTTree<num, Node> graphicsNodes, int id1, int id2, int index) {
    final node1 = graphicsNodes.search(Node.Id(id1));
    final node2 = graphicsNodes.search(Node.Id(id2));
    var edge = graphs[index].getEdgeBetween(node1, node2);
    edge ??= graphs[index].getEdgeBetween(node2, node1);
    edge.paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Clarke Wright algoritmus - kapacita vozidla ${widget.clarkWrightAlgorithm.vehicleCapacity}'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  controller: ScrollController(),
                  scrollDirection: Axis.vertical,
                  itemCount: widget.clarkWrightAlgorithm.routes.length,
                  itemBuilder: (ctx, index) {
                    return builders[index] == null
                        ? const Center(child: Text('Loading'))
                        : Stack(children: [
                            Opacity(
                              opacity: 1,
                              child: Center(
                                child: RouteItem(
                                  route: widget.clarkWrightAlgorithm
                                      .routesWithCenter[index],
                                  track:
                                      widget.clarkWrightAlgorithm.tracks[index],
                                  trackID: index + 1,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 600,
                              width: double.infinity,
                              child: Container(
                                  color: Color.fromRGBO(
                                      Random().nextInt(150) + 100,
                                      Random().nextInt(150) + 100,
                                      Random().nextInt(150) + 100,
                                      0.5),
                                  child: GraphView(
                                      graph: graphs[index],
                                      algorithm: builders[index],
                                      paint: Paint()
                                        ..color = Colors.green
                                        ..strokeWidth = 5
                                        ..style = PaintingStyle.fill,
                                      builder: (Node node) {
                                        var id = node.key.value as int;
                                        if (id ==
                                            widget
                                                .clarkWrightAlgorithm.centre) {
                                          return nodeWidget(id, Colors.yellow);
                                        }
                                        if (widget.clarkWrightAlgorithm
                                                .routes[index]
                                                .firstWhere(
                                                    (element) =>
                                                        element.id == id,
                                                    orElse: () => null) !=
                                            null) {
                                          return nodeWidget(
                                              id, Colors.lightGreen);
                                        }
                                        return nodeWidget(id, Colors.blue);
                                      })),
                            ),
                          ]);
                  }),
            ),
          ],
        ));
  }

  Widget nodeWidget(int id, Color color) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, spreadRadius: 1),
          ],
        ),
        child: Text('$id'));
  }
}
