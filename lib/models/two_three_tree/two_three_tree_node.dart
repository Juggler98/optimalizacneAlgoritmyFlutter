import 'package:flutter/foundation.dart';

class TTTreeNode<K extends Comparable<K>, T extends Comparable<T>> {
  TTTreeNode<K, T> _parent;
  TTTreeNode<K, T> _leftSon;
  TTTreeNode<K, T> _middleSon;
  TTTreeNode<K, T> _rightSon;

  T _dataL;
  T _dataR;

  TTTreeNode(T data) {
    _dataL = data;
  }

  bool isThreeNode() {
    return hasDataR();
  }

  void vypis() {
    if (kDebugMode) {
      if (hasMiddleSon()) {
        print("hasMIDDLESon");
      }
      if (hasRightSon()) {
        print("hasRIGHTSon");
      }
      if (hasLeftSon()) {
        print("hasLEFTSon");
      }
      if (isThreeNode()) {
        print("3 NODE");
        //print("L: " + dataL.getKey().toString());
        //print("R: " + dataR.getKey().toString());
      } else {
        print("2 NODE");
        //print("L: " + dataL.getKey().toString());
      }
      print("");
      //if (dataL.getKey() == null || dataL == null) {
      //print("-------------Error-------keyL-or-dataL---------");
      //}
    }
  }

  bool isLeaf() {
    return !hasMiddleSon() && !hasRightSon() && !hasLeftSon();
  }

  void setMiddleSon(TTTreeNode<K, T> middleSon) {
    _middleSon = middleSon;
  }

  void setDataL(T dataL) {
    _dataL = dataL;
  }

  void setDataR(T dataR) {
    _dataR = dataR;
  }

  TTTreeNode<K, T> getMiddleSon() {
    return _middleSon;
  }

  T getDataL() {
    return _dataL;
  }

  T getDataR() {
    return _dataR;
  }

  void setParent(TTTreeNode<K, T> parent) {
    _parent = parent;
  }

  void setLeftSon(TTTreeNode<K, T> leftSon) {
    _leftSon = leftSon;
  }

  void setRightSon(TTTreeNode<K, T> rightSon) {
    _rightSon = rightSon;
  }

  TTTreeNode<K, T> getParent() {
    return _parent;
  }

  TTTreeNode<K, T> getLeftSon() {
    return _leftSon;
  }

  TTTreeNode<K, T> getRightSon() {
    return _rightSon;
  }

  bool hasLeftSon() {
    return _leftSon != null;
  }

  bool hasRightSon() {
    return _rightSon != null;
  }

  bool hasParent() {
    return _parent != null;
  }

  bool hasMiddleSon() {
    return _middleSon != null;
  }

  bool hasDataL() {
    return _dataL != null;
  }

  bool hasDataR() {
    return _dataR != null;
  }
}
