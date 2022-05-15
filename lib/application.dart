import 'dart:io';

import 'package:flutter/foundation.dart';
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
  List<Uzol> uzly = [];
  List<Hrana> hrany = [];

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
    print("Pocet vrcholov: " + nodesCount.toString());

    for (int i = 0; i < nodesCount; i++) {
      uzly.add(Uzol(id: i));
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

      uzly[id].lat = lat;
      uzly[id].lon = lon;
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
      Hrana edge = Hrana(id: id, from: from, to: to, length: length);
      hrany.add(edge);
      edgesCount++;

      Hrana? nodeFromEdge = uzly[from].edge;
      if (nodeFromEdge == null) {
        uzly[from].edge = edge;
      } else {
        while (true) {
          if (nodeFromEdge?.getNextEdge(from) == null) {
            nodeFromEdge?.setNextEdge(from, edge);
            break;
          }
          nodeFromEdge = nodeFromEdge?.getNextEdge(from);
        }
      }

      Hrana? nodeToEdge = uzly[to].edge;
      if (nodeToEdge == null) {
        uzly[to].edge = edge;
      } else {
        while (true) {
          if (nodeToEdge?.getNextEdge(to) == null) {
            nodeToEdge?.setNextEdge(to, edge);
            break;
          }
          nodeToEdge = nodeToEdge?.getNextEdge(to);
        }
      }
    }

    print("Pocet hran: " + hrany.length.toString());

    loading = false;
    notifyListeners();

    vypisHranyPreVrcholy(-1);
  }

  void _reload() {
    loading = true;
    notifyListeners();

    List<Uzol> uzly = [];
    List<Hrana> hrany = [];
    for (var uzol in this.uzly) {
      uzly.add(Uzol(
        id: uzol.id,
        name: uzol.name,
        type: uzol.type,
        capacity: uzol.capacity,
        lat: uzol.lat,
        lon: uzol.lon,
      ));
    }

    for (var hrana in this.hrany) {
      hrany.add(Hrana(
        id: hrana.id,
        from: hrana.from,
        to: hrana.to,
        length: hrana.length,
      ));
    }

    for (var hrana in hrany) {
      var node = uzly.firstWhere((element) => element.id == hrana.from);
      Hrana? nodeFromEdge = node.edge;
      if (nodeFromEdge == null) {
        node.edge = hrana;
      } else {
        while (true) {
          if (nodeFromEdge?.getNextEdge(hrana.from) == null) {
            nodeFromEdge?.setNextEdge(hrana.from, hrana);
            break;
          }
          nodeFromEdge = nodeFromEdge?.getNextEdge(hrana.from);
        }
      }

      node = uzly.firstWhere((element) => element.id == hrana.to);
      Hrana? nodeToEdge = node.edge;
      if (nodeToEdge == null) {
        node.edge = hrana;
      } else {
        while (true) {
          if (nodeToEdge?.getNextEdge(hrana.to) == null) {
            nodeToEdge?.setNextEdge(hrana.to, hrana);
            break;
          }
          nodeToEdge = nodeToEdge?.getNextEdge(hrana.to);
        }
      }
    }
    this.uzly = uzly;
    this.hrany = hrany;

    loading = false;
    notifyListeners();
  }

  void removeNode(Uzol node) {
    uzly.removeWhere((element) => element.id == node.id);
    Hrana? nodeEdge = node.edge;
    while (nodeEdge != null) {
      hrany.removeWhere((element) => element.id == nodeEdge?.id);
      nodeEdge = nodeEdge.getNextEdge(node.id);
    }
    _reload();
  }

  void removeEdge(Hrana edge) {
    hrany.removeWhere((element) => element.id == edge.id);
    _reload();
  }

  void addNode(Uzol node) {
    uzly.add(node);
    nodesCount++;
    notifyListeners();
  }

  void addEdge(Hrana edge) {
    hrany.add(edge);
    edgesCount++;
    _reload();
  }

  void editNode(Uzol node, String? name, double? capacity, NodeType type) {
    node.name = name;
    node.capacity = capacity;
    node.type = type;
    notifyListeners();
  }

  void editEdge(Hrana edge, double? length, bool active) {
    edge.length = length ?? 0;
    edge.active = active;
    notifyListeners();
  }

  void vypisHranyPreVrcholy(int pocet) {
    if (pocet == -1) {
      pocet = nodesCount;
    }
    for (int i = 0; i < pocet; i++) {
      print("NODE: " + i.toString());
      Hrana? nodeEdge = uzly[i].edge;
      while (nodeEdge != null) {
        nodeEdge.vypis();
        nodeEdge = nodeEdge.getNextEdge(i);
      }
    }
  }
}
