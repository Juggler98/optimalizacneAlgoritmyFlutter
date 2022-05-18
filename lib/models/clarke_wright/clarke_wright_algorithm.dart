import 'package:flutter/foundation.dart';
import 'package:optimalizacne_algoritmy/application.dart';
import 'package:optimalizacne_algoritmy/models/clarke_wright/saving.dart';

import '../node.dart';
import '../two_three_tree/two_three_tree.dart';

class ClarkeWrightAlgorithm {
  final int centre;
  final double vehicleCapacity;

  final app = Application();

  TTTree<num, Saving> _savings = TTTree();
  List<List<Node>> _routes = [];
  List<List<int>> _routesWithCenter;
  List<List<int>> _tracks;

  ClarkeWrightAlgorithm({
    @required this.centre,
    @required this.vehicleCapacity,
  }) {
    calculate();
  }

  void _init() {
    _savings = TTTree();
    _routes = [];
    _tracks = null;
    _routesWithCenter = null;
    var index = 0;
    for (var node in app.allNodes) {
      if (node.id != centre) {
        node.routesPosition = index;
        _routes.add([node]);
        index++;
      }
    }
  }

  void calculate() {
    _init();
    if (app.nodesCount < 10000) {
      for (int i = 0; i < app.distanceMatrix.length; i++) {
        for (int j = 0; j < app.distanceMatrix[0].length; j++) {
          final centreNode = app.getNode(centre);
          if (i != j && i != centreNode.position && j != centreNode.position) {
            final saving = app.distanceMatrix[centreNode.position][i] +
                app.distanceMatrix[centreNode.position][j] -
                app.distanceMatrix[i][j];
            if (saving > 0) {
              _savings.add(Saving(from: i, to: j, saving: saving));
            }
          }
        }
      }
    } else {
      for (int i = 0; i < app.nodesCount; i++) {
        for (int j = 0; j < app.nodesCount; j++) {
          final centreNode = app.getNode(centre);
          if (i != j && i != centreNode.position && j != centreNode.position) {
            final mI = app.getDistances(app.getNodeFromPosition(i).id);
            final mCentre = app.getDistances(centre);
            final saving = mCentre[i] + mCentre[j] - mI[j];
            if (saving > 0) {
              _savings.add(Saving(from: i, to: j, saving: saving));
            }
          }
        }
      }
    }

    while (_savings.getSize() != 0) {
      final sav = _savings.removeMaxData();
      if (kDebugMode) {
        //print(sav);
      }
      _join(sav);
    }
    routes.removeWhere((list) => list.isEmpty);
    //printRoutes();
  }

  //Try to join nodes to one route
  void _join(Saving saving) {
    final nodeFrom = app.getNodeFromPosition(saving.from);
    final nodeTo = app.getNodeFromPosition(saving.to);
    //Ak uz su uzly v jednej trase koncime
    if (nodeFrom.routesPosition == nodeTo.routesPosition) {
      return;
    }
    final routeFrom = _routes[nodeFrom.routesPosition];
    final routeTo = _routes[nodeTo.routesPosition];
    final necessity = _getNecessity(routeFrom) + _getNecessity(routeTo);
    if (necessity > vehicleCapacity) {
      return;
    }
    //Check if node is on start or end of route
    if ((routeFrom[0] == nodeFrom ||
            routeFrom[routeFrom.length - 1] == nodeFrom) &&
        (routeTo[0] == nodeTo || routeTo[routeTo.length - 1] == nodeTo)) {
      if (routeFrom[routeFrom.length - 1] == nodeFrom) {
        if (routeTo[0] == nodeTo) {
          for (var node in routeTo) {
            routeFrom.add(node);
          }
        } else {
          for (var node in routeTo.reversed) {
            routeFrom.add(node);
          }
        }
      } else {
        if (routeTo[0] == nodeTo) {
          for (var node in routeTo) {
            routeFrom.insert(0, node);
          }
        } else {
          for (var node in routeTo.reversed) {
            routeFrom.insert(0, node);
          }
        }
      }
      for (var node in routeTo) {
        node.routesPosition = nodeFrom.routesPosition;
      }
      routeTo.clear();
    }
  }

  double _getNecessity(List<Node> nodes) {
    var capacity = 0.0;
    for (var node in nodes) {
      capacity += node.capacity;
    }
    return capacity;
  }

  List<List<Node>> get routes {
    return _routes;
  }

  List<List<int>> get routesWithCenter {
    if (_routesWithCenter != null) {
      return _routesWithCenter;
    }
    _routesWithCenter = List.generate(routes.length, (index) => []);
    int index = 0;
    for (var route in routes) {
      _routesWithCenter[index].add(centre);
      for (var node in route) {
        _routesWithCenter[index].add(node.id);
      }
      _routesWithCenter[index].add(centre);
      index++;
    }
    return _routesWithCenter;
  }

  List<List<int>> get tracks {
    if (_tracks != null) {
      return _tracks;
    }
    _tracks = List.generate(routes.length, (index) => []);
    int index = 0;
    for (var route in routes) {
      final centerNode = app.getNode(centre);
      var track = app.getTrack(centerNode.id, route[0].id).reversed;
      for (var t in track) {
        tracks[index].add(t);
      }
      for (int j = 0; j < route.length - 1; j++) {
        final track = app.getTrack(route[j].id, route[j + 1].id).reversed;
        for (var t in track) {
          if (t != tracks[index].last) {
            tracks[index].add(t);
          }
        }
      }
      track = app.getTrack(route[route.length - 1].id, centerNode.id).reversed;
      for (var t in track) {
        if (t != tracks[index].last) {
          tracks[index].add(t);
        }
      }
      index++;
    }
    return _tracks;
  }

  void printRoutes() {
    for (var list in _routes) {
      var text = '';
      for (var node in list) {
        text += node.id.toString() + ' ';
      }
      if (kDebugMode) {
        print(text);
      }
    }
  }
}
