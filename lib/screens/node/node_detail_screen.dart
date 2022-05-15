import 'dart:io';

import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/application.dart';

import '../../models/node.dart';
import '../../models/typ_uzla.dart';
import 'node_edit_screen.dart';

class NodeDetailScreen extends StatefulWidget {
  final Node node;

  const NodeDetailScreen({@required this.node, Key key}) : super(key: key);

  @override
  State<NodeDetailScreen> createState() => _NodeDetailScreenState();
}

class _NodeDetailScreenState extends State<NodeDetailScreen> {
  final app = Application();

  Node node;

  @override
  void initState() {
    super.initState();
    node = widget.node;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uzol ' + node.id.toString()),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Uprav',
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (ctx) => NodeEditScreen(node: node),
                ),
              )
                  .then((reload) {
                if (reload != null) {
                  setState(() {
                    node = app.getNode(node.id);
                  });
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Vymaž',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Vymazať'),
                  content: const Text('Určite chceš vymazať tento uzol?'),
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
                        app.removeNode(node);
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
                      'Uzol',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ID: ${node.id.toString()}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                        'Názov: ${node.name != null ? node.name.toString() : ''}'),
                    const SizedBox(height: 8),
                    Text('Typ: ${Node.getNodeTypeString(node.type)}'),
                    const SizedBox(height: 8),
                    Text(
                        '${node.type == NodeType.zakaznik ? 'Požiadavka' : 'Kapacita'}: ${node.capacity != null ? node.capacity.toString() : ''}'),
                    const SizedBox(height: 8),
                    Text((node.lat != null
                            ? ' X: ${node.lon.toString()}'
                            : '') +
                        (node.lon != null ? ' Y: ${node.lat.toString()}' : '')),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
