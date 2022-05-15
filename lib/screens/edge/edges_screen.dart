import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../application.dart';
import '../../widgets/edge_item.dart';

class EdgesScreen extends StatefulWidget {
  const EdgesScreen({Key key}) : super(key: key);

  @override
  State<EdgesScreen> createState() => _EdgesScreenState();
}

class _EdgesScreenState extends State<EdgesScreen>
    with AutomaticKeepAliveClientMixin<EdgesScreen> {
  @override
  bool get wantKeepAlive => true;

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Expanded(
            child: Consumer<Application>(
              builder: (ctx, app, _) => Container(
                child: app.loading
                    ? const Center(child: CircularProgressIndicator())
                    : app.isEdgesTreeEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'Žiadne uzly',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          )
                        : ListView(
                            controller: controller,
                            children: app.allEdges
                                .map((e) => EdgeItem(edge: e)).toList(),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
