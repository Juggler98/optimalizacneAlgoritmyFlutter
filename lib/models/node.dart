import 'package:flutter/foundation.dart';
import 'package:optimalizacne_algoritmy/models/edge.dart';
import 'package:optimalizacne_algoritmy/models/typ_uzla.dart';

class Node implements Comparable<Node> {
  final int id;
  String name;
  NodeType type;
  double capacity;
  Edge edge;
  double lat;
  double lon;

  Node({
    @required this.id,
    this.name,
    this.type = NodeType.nespecifikovane,
    this.capacity,
    this.edge,
    this.lat,
    this.lon,
  });

  void vypis() {
    if (kDebugMode) {
      print("Node{" "id=" + id.toString() +
        ", lat=" + lat.toString() +
        ", lon=" + lon.toString() +
        ", edge=" + edge.toString() +
        '}');
    }
  }

  static String getNodeTypeString(NodeType type) {
    switch (type) {
      case NodeType.primarnyZdroj:
        return 'Primárny zdroj';
      case NodeType.zakaznik:
        return 'Zákazník';
      case NodeType.prekladiskoMozne:
        return 'Možné prekladisko';
      case NodeType.nespecifikovane:
        return 'Nešpecifikovaný';
      default:
        return 'Unknown';
    }
  }

  @override
  int compareTo(Node other) {
    return id.compareTo(other.id);
  }
}
