import 'dart:io';

import 'package:flutter/material.dart';

import '../../application.dart';
import '../../models/edge.dart';
import '../node/node_detail_screen.dart';
import 'edge_edit_screen.dart';

class EdgeDetailScreen extends StatefulWidget {
  final Edge edge;

  const EdgeDetailScreen({@required this.edge, Key key}) : super(key: key);

  @override
  State<EdgeDetailScreen> createState() => _EdgeDetailScreenState();
}

class _EdgeDetailScreenState extends State<EdgeDetailScreen> {
  final app = Application();

  Edge edge;

  @override
  void initState() {
    super.initState();
    edge = widget.edge;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hrana ' + edge.id.toString()),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            tooltip: 'Uprav',
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (ctx) => EdgeEditScreen(edge: edge),
                ),
              )
                  .then((reload) {
                if (reload != null) {
                  setState(() {
                    edge = app.getEdge(edge.id);
                  });
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            tooltip: 'Vymaž',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Vymazať'),
                  content: const Text('Určite chceš vymazať túto hranu?'),
                  actions: [
                    TextButton(
                      child: const Text('Nie'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        app.removeEdge(edge);
                      },
                      child: const Text('Vymazať'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        heightFactor: 1.1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
              ),
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
              child: Padding(
                padding: EdgeInsets.all(Platform.isWindows ? 58.0 : 5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Hrana',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('ID: ${edge.id.toString()}'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Z vrchola: '),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              final node = app.getNode(edge.from);
                              if (node != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        NodeDetailScreen(node: node),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              edge.from.toString(),
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Do vrchola: '),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              final node = app.getNode(edge.to);
                              if (node != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        NodeDetailScreen(node: node),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              edge.to.toString(),
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Dĺžka: ${edge.length.toString()}'),
                    const SizedBox(height: 8),
                    Text(edge.active ? 'Aktivovaná' : 'Deaktivovaná'),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
