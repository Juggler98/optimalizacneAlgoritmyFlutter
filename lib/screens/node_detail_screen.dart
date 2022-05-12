import 'dart:io';

import 'package:flutter/material.dart';

import '../models/node.dart';

class NodeDetailScreen extends StatelessWidget {
  final Uzol node;

  const NodeDetailScreen({required this.node, Key? key}) : super(key: key);

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
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (ctx) => NewLogScreen(stone: stone),
              //   ),
              // );
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
              margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
              child: Padding(
                padding: EdgeInsets.all(Platform.isWindows ? 58.0 : 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    Text('ID: ${node.id.toString()}'),
                    const SizedBox(height: 8),
                    Text('Názov: ${node.name != null ? node.name.toString() : ''}'),
                    const SizedBox(height: 8),
                    Text('Typ: ${node.type != null ? node.type.toString() : ''}'),
                    const SizedBox(height: 8),
                    Text('Kapacita: ${node.capacity != null ? node.capacity.toString() : ''}'),
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
    ;
  }
}
