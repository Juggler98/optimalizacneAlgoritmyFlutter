import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/screens/edge_detail_screen.dart';
import '../models/edge.dart';

class EdgeItem extends StatelessWidget {
  final Hrana edge;

  const EdgeItem({required this.edge, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => EdgeDetailScreen(edge: edge),
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
            leading: Text(edge.id.toString()),
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    'Od: ${edge.from.toString()}'
                            ' Do: ${edge.to.toString()}' +
                        (edge.length != null
                            ? '   Dĺžka: ${edge.length.toString()}'
                            : ''),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Uprav',
              onPressed: () {

              },
            ),
          ),
        ),
      ),
    );
  }
}
