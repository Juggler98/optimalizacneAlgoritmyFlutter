import 'dart:io';

import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/models/node.dart';
import 'package:optimalizacne_algoritmy/screens/node/node_detail_screen.dart';

import '../models/typ_uzla.dart';
import '../screens/node/node_edit_screen.dart';

class NodeItem extends StatelessWidget {
  final Node node;

  const NodeItem({@required this.node, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Platform.isWindows ? 80.0 : 16.0, vertical: 0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => NodeDetailScreen(node: node),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
          child: ListTile(
            leading: Text(node.id.toString()),
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    (node.name != null
                            ? 'Názov: ${node.name.toString()}'
                            : '') +
                        (' Typ: ${Node.getNodeTypeString(node.type)}') +
                        (node.capacity != null
                            ? ' ${node.type == NodeType.zakaznik ? 'Požiadavka' : 'Kapacita'}: ${node.capacity.toString()}'
                            : '') +
                        (node.lat != null ? ' X: ${node.lon.toString()}' : '') +
                        (node.lon != null ? ' Y: ${node.lat.toString()}' : ''),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Uprav',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => NodeEditScreen(node: node),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
