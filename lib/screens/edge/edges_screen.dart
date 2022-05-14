import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/widgets/node_item.dart';
import 'package:provider/provider.dart';

import '../../application.dart';
import '../../widgets/edge_item.dart';

class EdgesScreen extends StatefulWidget {
  const EdgesScreen({Key? key}) : super(key: key);

  @override
  _EdgesScreenState createState() => _EdgesScreenState();
}

class _EdgesScreenState extends State<EdgesScreen> {

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
                    : app.hrany.isEmpty
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
                            itemCount: app.hrany.length,
                            itemBuilder: (ctx, index) {
                              return EdgeItem(edge: app.hrany.elementAt(index));
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
