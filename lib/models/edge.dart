class Hrana {
  final int id;
  final int from;
  final int to;
  double? length;
  Hrana? nextEdgeFrom;
  Hrana? nextEdgeTo;

  Hrana({
    required this.id,
    required this.from,
    required this.to,
    this.length,
    this.nextEdgeFrom,
    this.nextEdgeTo
  });

   int getTo(int from) {
    if (from == this.from) {
      return to;
    }
    return this.from;
  }

  Hrana? getNextEdge(int nodeId) {
    if (nodeId == from) {
      return nextEdgeFrom;
    }
    return nextEdgeTo;
  }

   void setNextEdge(int nodeId, Hrana edge) {
    if (nodeId == from) {
      nextEdgeFrom = edge;
      return;
    }
    nextEdgeTo = edge;
  }

  void vypis() {
    print("Edge{" +
        "id=" + id.toString() +
        ", from=" + from.toString() +
        ", to=" + to.toString() +
        ", length=" + length.toString() +
        ", nextEdgeFrom=" + (nextEdgeFrom != null ? nextEdgeFrom!.id.toString() : "null") +
        ", nextEdgeTo=" + (nextEdgeTo != null ? nextEdgeTo!.id.toString() : "null") +
        '}');
  }

}
