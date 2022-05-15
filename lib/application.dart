import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:optimalizacne_algoritmy/models/twoThreeTree/two_three_tree.dart';
import 'package:optimalizacne_algoritmy/models/typ_uzla.dart';
import 'package:path_provider/path_provider.dart';

import 'models/edge.dart';
import 'models/node.dart';

class Application with ChangeNotifier {
  static final Application _singleton = Application._internal();

  factory Application() {
    return _singleton;
  }

  Application._internal() {
    _init();
  }

  final _fileNames = {
    "test_edges.atr",
    "test_edges_incid.txt",
    "test_nodes.atr",
    "test_nodes.vec",
  };

  final _fileNamesSR = {
    "SR_edges.atr",
    "SR_edges_incid.txt",
    "SR_nodes.atr",
    "SR_nodes.vec",
  };

  var nodesCount = -1;
  var edgesCount = 1;

  final TTTree<num, Node> _nodesTree = TTTree();
  final TTTree<num, Edge> _edgesTree = TTTree();

  var loading = true;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void _init() async {
    bool testovaciaSiet = true;
    Set<String> fileNames;
    if (testovaciaSiet) {
      fileNames = _fileNames;
    } else {
      fileNames = _fileNamesSR;
    }

    var path = '';
    if (Platform.isAndroid) {
      path = await _localPath + '/';
    }

    final scEdges = File(path + fileNames.elementAt(0));
    final scEdgesInc = File(path + fileNames.elementAt(1));
    final scNodes = File(path + fileNames.elementAt(2));
    final scNodesVec = File(path + fileNames.elementAt(3));

    List<String> scNodesLines = [];
    List<String> scNodesVecLines = [];
    List<String> scEdgesIncLines = [];
    List<String> scEdgesLines = [];
    try {
      scNodesLines = await scNodes.readAsLines();
      scNodesVecLines = await scNodesVec.readAsLines();
      scEdgesIncLines = await scEdgesInc.readAsLines();
      scEdgesLines = await scEdges.readAsLines();
    } catch (e) {
      if (kDebugMode) {
        print('error files');
      }
      return;
    }

    bool startsFromZero = false;
    for (var line in scNodesLines) {
      if (nodesCount == 0) {
        startsFromZero = true;
      }
      nodesCount = int.parse(line);
      //print(_nodesCount);
    }

    if (startsFromZero) {
      nodesCount++;
    }
    if (kDebugMode) {
      print("Pocet vrcholov: " + nodesCount.toString());
    }

    for (int i = 0; i < nodesCount; i++) {
      _nodesTree.add(Node(id: i));
    }

    final intInStr = RegExp(r'\d+\.?\d*');
    for (int i = 0; i < scNodesVecLines.length; i = i + 2) {
      var line = scNodesVecLines.elementAt(i);
      var data = line.split(' ');
      int id = int.parse(data.first);
      id = startsFromZero ? id : id - 1;

      line = scNodesVecLines.elementAt(i + 1).trim();
      var data2 = intInStr.allMatches(line);
      double lon = double.parse(data2.first.group(0).toString());
      double lat = double.parse(data2.elementAt(1).group(0).toString());

      final uzol = _nodesTree.search(Node(id: id));
      uzol.lat = lat;
      uzol.lon = lon;
    }

    /*
         * Inicializacia dynamickej doprednej hviezdy
        */
    for (int i = 0; i < scEdgesIncLines.length; i++) {
      var line = scEdgesIncLines.elementAt(i);
      var data = intInStr.allMatches(line);
      int id = int.parse(data.elementAt(0).group(0).toString());
      int from = int.parse(data.elementAt(1).group(0).toString());
      from = startsFromZero ? from : from - 1;
      int to = int.parse(data.elementAt(2).group(0).toString());
      to = startsFromZero ? to : to - 1;

      var line2 = scEdgesLines.elementAt(i);
      var data2 = line2.split(' ');
      int id2 = int.parse(data2.elementAt(0));
      double length = double.parse(data2.elementAt(1));
      if (id != id2) {
        throw Exception('This should not happened');
      }
      if (from == to) {
        continue;
      }
      Edge edge = Edge(id: id, from: from, to: to, length: length);
      _edgesTree.add(edge);
      edgesCount++;

      _initDoprednaHviezda(edge);
    }

    if (kDebugMode) {
      print("Pocet hran: " + _edgesTree.getSize().toString());
    }

    loading = false;
    notifyListeners();

    //vypisHranyPreVrcholy(-1);

    //_hrany.clear();
    //_uzly.clear();

    //printDistance(1, 6, false);
  }

  void _reload() {
    loading = true;
    notifyListeners();

    for (var uzol in _nodesTree.getInOrderData()) {
      uzol.edge = null;
    }

    final hrany = _edgesTree.getInOrderData();

    for (var hrana in hrany) {
      hrana.nextEdgeFrom = null;
      hrana.nextEdgeTo = null;
    }

    for (var hrana in hrany) {
      _initDoprednaHviezda(hrana);
    }

    loading = false;
    notifyListeners();
  }

  void _initDoprednaHviezda(Edge edge) {
    var node = _nodesTree.search(Node(id: edge.from));
    Edge nodeFromEdge = node.edge;
    if (nodeFromEdge == null) {
      node.edge = edge;
    } else {
      while (true) {
        if (nodeFromEdge?.getNextEdge(edge.from) == null) {
          nodeFromEdge?.setNextEdge(edge.from, edge);
          break;
        }
        nodeFromEdge = nodeFromEdge?.getNextEdge(edge.from);
      }
    }

    node = _nodesTree.search(Node(id: edge.to));
    Edge nodeToEdge = node.edge;
    if (nodeToEdge == null) {
      node.edge = edge;
    } else {
      while (true) {
        if (nodeToEdge?.getNextEdge(edge.to) == null) {
          nodeToEdge?.setNextEdge(edge.to, edge);
          break;
        }
        nodeToEdge = nodeToEdge?.getNextEdge(edge.to);
      }
    }
  }

  void removeNode(Node node) {
    _nodesTree.remove(node);
    Edge nodeEdge = node.edge;
    while (nodeEdge != null) {
      _edgesTree.remove(nodeEdge);
      nodeEdge = nodeEdge.getNextEdge(node.id);
    }
    _reload();
  }

  void removeEdge(Edge edge) {
    _edgesTree.remove(edge);
    _reload();
  }

  void addNode(Node node) {
    _nodesTree.add(node);
    nodesCount++;
    notifyListeners();
  }

  void addEdge(Edge edge) {
    _edgesTree.add(edge);
    edgesCount++;
    _reload();
  }

  void editNode(Node node, String name, double capacity, NodeType type) {
    node.name = name;
    node.capacity = capacity;
    node.type = type;
    notifyListeners();
  }

  void editEdge(Edge edge, double length, bool active) {
    edge.length = length ?? 0;
    edge.active = active;
    notifyListeners();
  }

  Node getNode(int id) {
    return _nodesTree.search(Node(id: id));
  }

  Edge getEdge(int id) {
    return _edgesTree.search(Edge(id: id, from: -1, to: -1));
  }

  List<Node> get allNodes {
    return _nodesTree.getInOrderData();
  }

  List<Edge> get allEdges {
    return _edgesTree.getInOrderData();
  }

  List<Node> getIntervalNodes(int start, int end) {
    return _nodesTree.getIntervalData(Node(id: start), Node(id: end));
  }

  bool get isEdgesTreeEmpty {
    return _edgesTree.getSize() == 0;
  }

  bool get isNodesTreeEmpty {
    return _nodesTree.getSize() == 0;
  }

  void vypisHranyPreVrcholy(int pocet) {
    if (pocet == -1) {
      pocet = nodesCount;
    }

    var count = 0;
    for (var uzol in _nodesTree.getIntervalData(Node(id: 0), Node(id: pocet))) {
      count++;
      if (kDebugMode) {
        print("NODE: " + count.toString());
      }
      Edge nodeEdge = uzol.edge;
      while (nodeEdge != null) {
        nodeEdge.vypis();
        nodeEdge = nodeEdge.getNextEdge(uzol.id);
      }
    }
  }

  /// @param from      Zaciatocny Vrchol
  /// @param p         Pole predchodcov
  /// @return Pole vzdialenosti z vrcholu from do vsetkych ostatnych vrcholov
  List<double> _getDistances(int from) {
    List<double> d = List.generate(_nodesTree.getSize(), (_) => double.infinity,
        growable: false);
    d[from] = 0;

    Queue<int> queue = Queue();
    Queue<int> queue2 = Queue();

    queue.add(from);
    int pocetVyberani = 0;
    while (queue.isNotEmpty || queue2.isNotEmpty) {
      int nodeFrom;
      if (queue2.isNotEmpty) {
        nodeFrom = queue2.removeFirst();
      } else {
        nodeFrom = queue.removeFirst();
      }
      pocetVyberani++;
      final uzol = _nodesTree.search(Node(id: nodeFrom));
      Edge nodeEdge = uzol.edge;
      while (nodeEdge != null) {
        int nodeTo = nodeEdge.getTo(nodeFrom);
        if (d[nodeFrom] + nodeEdge.length < d[nodeTo]) {
          double oldValue = d[nodeTo];
          d[nodeTo] = d[nodeFrom] + nodeEdge.length;
          if (oldValue != double.infinity) {
            queue2.add(nodeTo);
          } else {
            queue.add(nodeTo);
          }
        }
        nodeEdge = nodeEdge.getNextEdge(nodeFrom);
      }
    }
    if (kDebugMode) {
      print("\nPocet vyberani: $pocetVyberani");
    }
    return d;
  }

  /// @param from       Zaciatocny Vrchol
  /// @param to         Koncovy vrchol
  /// @param postupnost Ak true, tak sa zobrazi aj postupnost trasy
  void printDistance(int from, int to, bool postupnost) async {
    final d = _getDistances(from);
    if (kDebugMode) {
      print("$from -> $to, Dlzka: ${d[to]}");
    }
  }

  void printAllDistances(int from, int count) async {
    final d = _getDistances(from);
    if (kDebugMode) {
      print("Vzdialenost z vrchola $from do $count vrcholov: ");
    }
    if (count == -1) {
      count = d.length;
    }
    for (int i = 0; i < count; i++) {
      if (kDebugMode) {
        print("${d[i]}, ");
      }
    }
  }
}
