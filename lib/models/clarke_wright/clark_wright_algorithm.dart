import 'package:flutter/foundation.dart';
import 'package:optimalizacne_algoritmy/application.dart';
import 'package:optimalizacne_algoritmy/models/clarke_wright/saving.dart';

import '../node.dart';
import '../two_three_tree/two_three_tree.dart';

class ClarkWrightAlgorithm {
  final int centre;
  final double maxCapacity;

  final app = Application();

  TTTree<num, Saving> _savings = TTTree();
  List<List<Node>> _routes = [];

  ClarkWrightAlgorithm({@required this.centre, this.maxCapacity}) {
    calculate();
  }

  void _init() {
    _savings = TTTree();
    _routes = [];
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
          if (i != j) {
            final saving = app.distanceMatrix[app.startZero ? centre : centre - 1][i] +
                app.distanceMatrix[app.startZero ? centre : centre - 1][j] -
                app.distanceMatrix[i][j];
            if (saving > 0) {
              _savings.add(Saving(
                  from: app.startZero ? i : i + 1,
                  to: app.startZero ? j : j + 1,
                  saving: saving));
            }
          }
        }
      }
    } else {
      for (int i = 0; i < app.nodesCount; i++) {
        for (int j = 0; j < app.nodesCount; j++) {
          if (i != j) {
            final mI = app.getDistances(app.startZero ? i : i + 1);
            final mCentre = app.getDistances(centre);
            final saving = mCentre[i] + mCentre[j] - mI[j];
            if (saving > 0) {
              _savings.add(Saving(
                  from: app.startZero ? i : i + 1,
                  to: app.startZero ? j : j + 1,
                  saving: saving));
            }
          }
        }
      }
    }

    while (_savings.getSize() != 0) {
      final sav = _savings.removeMaxData();
      if (kDebugMode) {
        print(sav);
      }
      _join(sav);
    }
    routes.removeWhere((list) => list.isEmpty);
    printRoutes();
  }

  //Try to join nodes to one route
  void _join(Saving saving) {
    final nodeFrom = app.getNode(saving.from);
    final nodeTo = app.getNode(saving.to);
    //Ak uz su uzly v jednej trase koncime
    if (nodeFrom.routesPosition == nodeTo.routesPosition) {
      return;
    }
    final routeFrom = _routes[nodeFrom.routesPosition];
    final routeTo = _routes[nodeTo.routesPosition];
    final capacity = _getCapacity(routeFrom) + _getCapacity(routeTo);
    if (capacity > maxCapacity) {
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

  double _getCapacity(List<Node> nodes) {
    var capacity = 0.0;
    for (var node in nodes) {
      capacity += node.capacity;
    }
    return capacity;
  }

  List<List<Node>> get routes {
    return _routes;
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
