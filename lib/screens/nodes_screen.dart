import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/widgets/node_item.dart';
import 'package:provider/provider.dart';

import '../application.dart';

class NodesScreen extends StatefulWidget {
  const NodesScreen({Key? key}) : super(key: key);

  @override
  _NodesScreenState createState() => _NodesScreenState();
}

class _NodesScreenState extends State<NodesScreen> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Expanded(
            child: Consumer<Application>(
              builder: (ctx, app, _) => Container(
                child: app.loading
                    ? const Center(child: CircularProgressIndicator())
                    : app.uzly.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'Žiadne uzly',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: app.uzly.length,
                            itemBuilder: (ctx, index) {
                              return NodeItem(node: app.uzly.elementAt(index));
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
