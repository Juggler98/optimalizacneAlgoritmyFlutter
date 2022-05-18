import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:optimalizacne_algoritmy/models/file_result.dart';
import 'package:optimalizacne_algoritmy/models/two_three_tree/two_three_tree.dart';
import 'package:optimalizacne_algoritmy/models/node_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    "edges.atr",
    "edges_incid.txt",
    "nodes.atr",
    "nodes.vec",
    "edges_data.txt",
    "nodes_data.txt",
  };

  var nodesCountSequence = 1;
  var edgesCountSequence = 1;

  TTTree<num, Node> _nodesTree = TTTree();
  TTTree<num, Edge> _edgesTree = TTTree();

  List<Node> _nodesInOrder;
  List<Edge> _edgesInOrder;

  List<List<double>> _distanceMatrix;
  List<List<int>> _predecessorsMatrix;

  var loading = true;

  void _init() async {
    final prefs = await SharedPreferences.getInstance();
    var path = prefs.getString('path');
    path ??= 'dataTest';

    await loadData(path);

    //test();
  }

  void removeAllData() {
    _nodesTree = TTTree();
    _edgesTree = TTTree();
    _distanceMatrix = null;
    _predecessorsMatrix = null;
    _nodesInOrder = null;
    _edgesInOrder = null;
    nodesCountSequence = 1;
    edgesCountSequence = 1;
    notifyListeners();
  }

  void _reload() {
    loading = true;
    notifyListeners();

    var index = 0;
    for (var node in _nodesTree.getInOrderData()) {
      node.position = index++;
      node.edge = null;
    }

    final edges = _edgesTree.getInOrderData();

    for (var edge in edges) {
      edge.nextEdgeFrom = null;
      edge.nextEdgeTo = null;
    }

    for (var edge in edges) {
      _initDoprednaHviezda(edge);
    }

    _distanceMatrix = null;
    _predecessorsMatrix = null;
    _nodesInOrder = null;
    _edgesInOrder = null;

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
    _nodesInOrder.add(node);
    nodesCountSequence++;
    notifyListeners();
  }

  void addEdge(Edge edge) {
    _edgesTree.add(edge);
    edgesCountSequence++;
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
    if (_nodesInOrder != null) {
      return _nodesInOrder;
    }
    _nodesInOrder = _nodesTree.getInOrderData();
    return _nodesInOrder;
  }

  List<Edge> get allEdges {
    if (_edgesInOrder != null) {
      return _edgesInOrder;
    }
    _edgesInOrder = _edgesTree.getInOrderData();
    return _edgesInOrder;
  }

  Node getNodeFromPosition(int position) {
    return allNodes.elementAt(position);
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

  int get nodesCount {
    return _nodesTree.getSize();
  }

  int get edgesCount {
    return _edgesTree.getSize();
  }

  void update() {
    notifyListeners();
  }

  void setCapacity(double capacity) {
    for (var node in allNodes) {
      node.capacity = capacity;
    }
    notifyListeners();
  }

  void setRandomCapacity(int bound) {
    final random = Random();
    for (var node in allNodes) {
      node.capacity = random.nextInt(bound) * 1.0;
    }
    notifyListeners();
  }

  void printEdgesForNodes(int pocet) {
    if (pocet == -1) {
      pocet = nodesCount;
    }

    var count = 0;
    for (var node in _nodesTree.getIntervalData(Node(id: 0), Node(id: pocet))) {
      count++;
      if (kDebugMode) {
        print("NODE: " + count.toString());
      }
      Edge nodeEdge = node.edge;
      while (nodeEdge != null) {
        if (kDebugMode) {
          print(nodeEdge);
        }
        nodeEdge = nodeEdge.getNextEdge(node.id);
      }
    }
  }

  /// @param from      Zaciatocny Vrchol
  /// @param p         Pole predchodcov
  /// @return Pole vzdialenosti z vrcholu from do vsetkych ostatnych vrcholov
  List<double> getDistances(int from, {List<int> p}) {
    List<double> d = List.generate(_nodesTree.getSize(), (_) => double.infinity,
        growable: false);

    final nodeFrom = getNode(from);
    d[nodeFrom.position] = 0;

    Queue<int> queue = Queue();
    Queue<int> queue2 = Queue();

    queue.add(nodeFrom.id);
    // ignore: unused_local_variable
    var pocetVyberani = 0;
    while (queue.isNotEmpty || queue2.isNotEmpty) {
      int nodeFromIndex;
      if (queue2.isNotEmpty) {
        nodeFromIndex = queue2.removeFirst();
      } else {
        nodeFromIndex = queue.removeFirst();
      }
      pocetVyberani++;
      final nodeFrom = getNode(nodeFromIndex);
      var nodeEdge = nodeFrom.edge;
      while (nodeEdge != null) {
        final nodeToIndex = nodeEdge.getTo(nodeFromIndex);
        final nodeTo = getNode(nodeToIndex);
        if (nodeEdge.active) {
          if (d[nodeFrom.position] + nodeEdge.length < d[nodeTo.position]) {
            final oldValue = d[nodeTo.position];
            d[nodeTo.position] = d[nodeFrom.position] + nodeEdge.length;
            if (p != null) {
              p[nodeTo.position] = nodeFrom.position;
            }
            if (oldValue != double.infinity) {
              queue2.add(nodeToIndex);
            } else {
              queue.add(nodeToIndex);
            }
          }
        }
        nodeEdge = nodeEdge.getNextEdge(nodeFromIndex);
      }
    }
    if (kDebugMode) {
      //print("\nPocet vyberani: $pocetVyberani");
    }
    return d;
  }

  List<List<double>> get distanceMatrix {
    if (_distanceMatrix != null) {
      return _distanceMatrix;
    }
    final matrix = List.generate(_nodesTree.getSize(),
        (_) => List.generate(_nodesTree.getSize(), (_) => 0.0, growable: false),
        growable: false);

    var index = 0;
    for (var node in _nodesTree.getInOrderData()) {
      matrix[index++] = getDistances(node.id);
    }

    for (int i = 0; i < matrix.length; i++) {
      if (kDebugMode) {
        //print(matrix[i]);
      }
    }
    _distanceMatrix = matrix;
    return matrix;
  }

  List<List<int>> get predecessorsMatrix {
    if (_predecessorsMatrix != null) {
      return _predecessorsMatrix;
    }

    List<List<int>> matrix = List.generate(_nodesTree.getSize(),
        (_) => List.generate(_nodesTree.getSize(), (_) => -1, growable: false),
        growable: false);

    var index = 0;
    for (var node in _nodesTree.getInOrderData()) {
      getDistances(node.id, p: matrix[index++]);
    }

    for (int i = 0; i < matrix.length; i++) {
      if (kDebugMode) {
        print(matrix[i]);
      }
    }
    _predecessorsMatrix = matrix;
    return matrix;
  }

  /// @param from       Zaciatocny Vrchol
  /// @param to         Koncovy vrchol
  /// @param postupnost Ak true, tak sa zobrazi aj postupnost trasy
  void printDistance(int from, int to, bool postupnost) async {
    List<int> p =
        List.generate(_nodesTree.getSize(), (_) => -1, growable: false);
    final d = getDistances(from, p: p);
    final nodeTo = getNode(to);

    if (postupnost) {
      if (kDebugMode) {
        print("$from -> $to, Dlzka: ${d[nodeTo.position]}, Postupnost: ");
      }
      var text = to.toString();
      int tempNode = p[nodeTo.position];
      while (tempNode != -1) {
        final node = getNodeFromPosition(tempNode);
        if (kDebugMode) {
          text += " <- " + (node.id).toString();
        }
        tempNode = p[tempNode];
      }
      if (kDebugMode) {
        print(text);
      }
    } else {
      if (kDebugMode) {
        print("$from -> $to, Dlzka: ${d[nodeTo.position]}");
      }
    }
  }

  List<int> getTrack(int from, int to) {
    List<int> p =
        List.generate(_nodesTree.getSize(), (_) => -1, growable: false);
    List<int> nodes = [];
    getDistances(from, p: p);
    final nodeTo = getNode(to);
    nodes.add(nodeTo.id);
    var tempNode = p[nodeTo.position];
    while (tempNode != -1) {
      final node = getNodeFromPosition(tempNode);
      nodes.add(node.id);
      tempNode = p[tempNode];
    }
    return nodes;
  }

  void printAllDistances(int from, {int count}) async {
    var d = getDistances(from);
    if (kDebugMode) {
      print("Vzdialenost z vrchola $from do $count vrcholov: ");
    }
    count ??= d.length;
    var text = '';
    for (int i = 0; i < count; i++) {
      text += '${d[i]}, ';
    }
    if (kDebugMode) {
      print(text);
    }
  }

  void test() {}

  Future<FileResult> loadData(String path) async {
    loading = true;
    notifyListeners();

    final fileEdges = File('$path/${_fileNames.elementAt(0)}');
    final fileEdgesInc = File('$path/${_fileNames.elementAt(1)}');
    final fileNodes = File('$path/${_fileNames.elementAt(2)}');
    final fileNodesVec = File('$path/${_fileNames.elementAt(3)}');

    final fileEdgesData = File('$path/${_fileNames.elementAt(4)}');
    final fileNodesData = File('$path/${_fileNames.elementAt(5)}');

    // ignore: unused_local_variable
    List<String> nodesLines = [];
    List<String> nodesVecLines = [];
    List<String> edgesIncLines = [];
    List<String> edgesLines = [];

    List<String> edgesDataLines = [];
    List<String> nodesDataLines = [];

    final lengthFileExist = await fileEdges.exists();
    final nodesFileExist = await fileNodes.exists();

    final edgesDataFileExist = await fileEdgesData.exists();
    final nodesDataFileExist = await fileNodesData.exists();

    try {
      if (nodesFileExist) {
        nodesLines = await fileNodes.readAsLines();
      }
      nodesVecLines = await fileNodesVec.readAsLines();
      edgesIncLines = await fileEdgesInc.readAsLines();
      if (lengthFileExist) {
        edgesLines = await fileEdges.readAsLines();
      }
      if (edgesDataFileExist) {
        edgesDataLines = await fileEdgesData.readAsLines();
      }
      if (nodesDataFileExist) {
        nodesDataLines = await fileNodesData.readAsLines();
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      if (kDebugMode) {
        print(e);
        print(FileResult.fileNotExist);
      }
      return FileResult.fileNotExist;
    }

    final intInStr = RegExp(r'\d+\.?\d*');
    try {
      for (int i = 0; i < nodesVecLines.length; i = i + 2) {
        var line = nodesVecLines[i];
        var data = line.split(' ');
        int id = int.parse(data.first);

        final node = Node(id: id, position: nodesCount);
        _nodesTree.add(node);
        nodesCountSequence++;

        line = nodesVecLines[i + 1].trim();
        var data2 = intInStr.allMatches(line);
        if (data2.length < 2) {
          loading = false;
          notifyListeners();
          if (kDebugMode) {
            print(FileResult.notCoordinate);
          }
          return FileResult.notCoordinate;
        }
        double lon = double.parse(data2.first.group(0).toString());
        double lat = double.parse(data2.elementAt(1).group(0).toString());

        node.lat = lat;
        node.lon = lon;

        if (nodesDataFileExist &&
            nodesVecLines.length / 2 == nodesDataLines.length) {
          final line = nodesDataLines[i ~/ 2];
          final data = line.split(' ');
          node.type = NodeType.values.elementAt(int.parse(data.elementAt(1)));
          if (double.parse(data.elementAt(2)) >= 0) {
            node.capacity = double.parse(data.elementAt(2));
          }
          if (data.length > 3) {
            node.name = data.elementAt(3);
          }
        }
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      if (kDebugMode) {
        print(e);
        print(FileResult.nodeFileFormat);
      }
      return FileResult.nodeFileFormat;
    }

    if (kDebugMode) {
      print("Pocet vrcholov: " + (nodesCount - 1).toString());
    }

    //Inicializacia hran a dynamickej doprednej hviezdy
    try {
      for (int i = 0; i < edgesIncLines.length; i++) {
        final line = edgesIncLines[i];
        final data = intInStr.allMatches(line);
        int id = int.parse(data.elementAt(0).group(0).toString());
        if (data.length < 3) {
          loading = false;
          notifyListeners();
          if (kDebugMode) {
            print(FileResult.notIncident);
          }
          return FileResult.notIncident;
        }
        int from = int.parse(data.elementAt(1).group(0).toString());
        int to = int.parse(data.elementAt(2).group(0).toString());

        if (from == to) {
          continue;
        }

        double length;
        if (lengthFileExist) {
          final line = edgesLines[i];
          final data = line.split(' ');
          int id2 = int.parse(data.elementAt(0));
          if (data.length > 1) {
            length = double.parse(data.elementAt(1));
          }
          if (id != id2) {
            loading = false;
            notifyListeners();
            if (kDebugMode) {
              print(FileResult.idIsNotId2);
            }
            return FileResult.idIsNotId2;
          }
        }

        var active = true;
        if (edgesDataFileExist &&
            edgesIncLines.length == edgesDataLines.length) {
          final line = edgesDataLines[i];
          final data = line.split(' ');
          if (int.parse(data.elementAt(1)) == 0) {
            active = false;
          }
        }

        if (length == null) {
          final nodeFrom = getNode(from);
          final nodeTo = getNode(to);
          if (nodeFrom != null && nodeTo != null) {
            length = sqrt(pow((nodeFrom.lon - nodeTo.lon), 2) +
                pow((nodeFrom.lat - nodeTo.lat), 2));
            length /= 10; //TODO: Divide because of test network format
          }
        }

        Edge edge =
            Edge(id: id, from: from, to: to, length: length, active: active);
        _edgesTree.add(edge);
        edgesCountSequence++;

        _initDoprednaHviezda(edge);
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      if (kDebugMode) {
        print(e);
        print(FileResult.incidentCountLength);
      }
      return FileResult.incidentCountLength;
    }

    if (kDebugMode) {
      print("Pocet hran: " + _edgesTree.getSize().toString());
    }

    loading = false;
    notifyListeners();

    //vypisHranyPreVrcholy(-1);
    //printDistance(1, 6, false);

    return FileResult.correct;
  }

  Future<void> writeToDirectory(String path) async {
    final fileEdgesAtr = File('$path/${_fileNames.elementAt(0)}');
    final fileEdgesIncid = File('$path/${_fileNames.elementAt(1)}');
    final fileNodesAtr = File('$path/${_fileNames.elementAt(2)}');
    final fileNodesVec = File('$path/${_fileNames.elementAt(3)}');
    final fileEdgesData = File('$path/${_fileNames.elementAt(4)}');
    final fileNodesData = File('$path/${_fileNames.elementAt(5)}');

    await fileEdgesAtr.writeAsString('');
    await fileEdgesIncid.writeAsString('');
    await fileNodesAtr.writeAsString('');
    await fileNodesVec.writeAsString('');
    await fileEdgesData.writeAsString('');
    await fileNodesData.writeAsString('');

    for (var edge in _edgesTree.getInOrderData()) {
      await fileEdgesAtr.writeAsString(
          edge.id.toString() + ' ' + edge.length.toString() + '\n',
          mode: FileMode.append);

      await fileEdgesIncid.writeAsString(
          edge.id.toString() +
              ' ' +
              edge.from.toString() +
              ' ' +
              edge.to.toString() +
              '\n',
          mode: FileMode.append);

      await fileEdgesData.writeAsString(
          edge.id.toString() + (edge.active ? ' 1' : ' 0') + '\n',
          mode: FileMode.append);
    }

    for (var node in _nodesTree.getInOrderData()) {
      await fileNodesAtr.writeAsString(node.id.toString() + '\n',
          mode: FileMode.append);

      await fileNodesVec.writeAsString(
          node.id.toString() +
              ' 1\n ' +
              node.lon.toString() +
              ' ' +
              node.lat.toString() +
              '\n',
          mode: FileMode.append);

      await fileNodesData.writeAsString(
          node.id.toString() +
              ' ' +
              node.type.index.toString() +
              ' ' +
              (node.capacity == null ? '-1' : node.capacity.toString()) +
              (node.name == null ? '' : ' ') +
              (node.name ?? '') +
              '\n',
          mode: FileMode.append);
    }
  }
}
