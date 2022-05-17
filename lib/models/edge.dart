import 'package:flutter/foundation.dart';

class Edge implements Comparable<Edge> {
  final int id;
  final int from;
  final int to;
  double length;
  Edge nextEdgeFrom;
  Edge nextEdgeTo;
  bool active;

  Edge(
      {@required this.id,
      @required this.from,
      @required this.to,
      this.length,
      this.nextEdgeFrom,
      this.nextEdgeTo,
      this.active = true});

  int getTo(int from) {
    if (from == this.from) {
      return to;
    }
    return this.from;
  }

  Edge getNextEdge(int nodeId) {
    if (nodeId == from) {
      return nextEdgeFrom;
    }
    return nextEdgeTo;
  }

  void setNextEdge(int nodeId, Edge edge) {
    if (nodeId == from) {
      nextEdgeFrom = edge;
      return;
    }
    nextEdgeTo = edge;
  }

  @override
  String toString() {
    return "Edge{" "id=" +
        id.toString() +
        ", from=" +
        from.toString() +
        ", to=" +
        to.toString() +
        ", length=" +
        length.toString() +
        ", nextEdgeFrom=" +
        (nextEdgeFrom != null ? nextEdgeFrom.id.toString() : "null") +
        ", nextEdgeTo=" +
        (nextEdgeTo != null ? nextEdgeTo.id.toString() : "null") +
        '}';
  }

  @override
  int compareTo(Edge other) {
    return id.compareTo(other.id);
  }
}
