import 'package:flutter/foundation.dart';

import 'two_three_tree_node.dart';
import 'two_three_tree_son_type.dart';

//Implementovane na predmete Algoritmy a udajove struktury 2
class TTTree<K extends Comparable<K>, T extends Comparable<T>> {
  TTTreeNode<K, T> _root;
  var _size = 0;

  var _height = 0;

  TTTree();

  /*
    Implementovane podla slovneho popisu z prednaskoveho dokumentu AUS2.
  */
  bool add(T newData) {
    if (!_tryToAdd(newData)) {
      //print("Nepodarilo sa vlozit kluc: " + newData.getKey().toString());
      return false;
    }
    ++_size;
    return true;
  }

  bool _tryToAdd(T newData) {
    if (_root == null) {
      _root = TTTreeNode<K, T>(newData);
      ++_height;
      return true;
    }

    var leaf = _findLeaf(newData);

    if (leaf == null) return false;

    TTTreeNode<K, T> min;
    TTTreeNode<K, T> max;
    TTTreeNode<K, T> middle;
    while (true) {
      if (!leaf.isThreeNode()) {
        if (leaf.getDataL().compareTo(newData) < 0) {
          leaf.setDataR(newData);
        } else {
          T tempLeftData = leaf.getDataL();
          leaf.setDataL(newData);
          leaf.setDataR(tempLeftData);
        }
        return true;
      }
      var tempMin = min;
      var tempMax = max;
      if (newData.compareTo(leaf.getDataL()) < 0) {
        min = TTTreeNode<K, T>(newData);
        max = TTTreeNode<K, T>(leaf.getDataR());
        middle = TTTreeNode<K, T>(leaf.getDataL());
      } else if (newData.compareTo(leaf.getDataR()) > 0) {
        min = TTTreeNode<K, T>(leaf.getDataL());
        max = TTTreeNode<K, T>(newData);
        middle = TTTreeNode<K, T>(leaf.getDataR());
      } else {
        min = TTTreeNode<K, T>(leaf.getDataL());
        max = TTTreeNode<K, T>(leaf.getDataR());
        middle = TTTreeNode<K, T>(newData);
      }
      if (tempMin != null && tempMax != null) {
        if (tempMin.getDataL().compareTo(leaf.getDataL()) < 0) {
          min.setLeftSon(tempMin);
          min.setRightSon(tempMax);
          max.setLeftSon(leaf.getMiddleSon());
          max.setRightSon(leaf.getRightSon());
          tempMin.setParent(min);
          tempMax.setParent(min);
          leaf.getMiddleSon().setParent(max);
          leaf.getRightSon().setParent(max);
        } else if (tempMin.getDataL().compareTo(leaf.getDataR()) > 0) {
          min.setLeftSon(leaf.getLeftSon());
          min.setRightSon(leaf.getMiddleSon());
          max.setLeftSon(tempMin);
          max.setRightSon(tempMax);
          tempMin.setParent(max);
          tempMax.setParent(max);
          leaf.getLeftSon().setParent(min);
          leaf.getMiddleSon().setParent(min);
        } else {
          min.setLeftSon(leaf.getLeftSon());
          min.setRightSon(tempMin);
          max.setLeftSon(tempMax);
          max.setRightSon(leaf.getRightSon());
          tempMin.setParent(min);
          tempMax.setParent(max);
          leaf.getLeftSon().setParent(min);
          leaf.getRightSon().setParent(max);
        }
      }
      if (leaf.hasParent()) {
        var leafParent = leaf.getParent();
        if (!leafParent.isThreeNode()) {
          if (leafParent.getDataL().compareTo(middle.getDataL()) < 0) {
            leafParent.setDataR(middle.getDataL());
            min.setParent(leafParent);
            max.setParent(leafParent);
            leafParent.setMiddleSon(min);
            leafParent.setRightSon(max);
          } else {
            T tempLeftData = leafParent.getDataL();
            leafParent.setDataL(middle.getDataL());
            leafParent.setDataR(tempLeftData);
            min.setParent(leafParent);
            max.setParent(leafParent);
            leafParent.setLeftSon(min);
            leafParent.setMiddleSon(max);
          }
          return true;
        } else {
          min.setParent(leafParent);
          max.setParent(leafParent);
          leaf = leafParent;
          newData = middle.getDataL();
        }
      } else {
        middle.setLeftSon(min);
        middle.setRightSon(max);
        min.setParent(middle);
        max.setParent(middle);
        _root = middle;
        ++_height;
        return true;
      }
    }
  }

/*
    Intervale vyhladavanie.
    Implementovane podla vlastneho navrhu.
     */
  List<T> getIntervalData(T start, T end) {
    var leaf = _root;
    if (leaf == null) {
      return _getInOrderDataInterval(leaf, start, end, true);
    }
    while (true) {
      if (leaf.isThreeNode()) {
        if (start.compareTo(leaf.getDataL()) < 0) {
          if (leaf.hasLeftSon()) {
            leaf = leaf.getLeftSon();
          } else {
            break;
          }
        } else if (start.compareTo(leaf.getDataR()) > 0) {
          if (leaf.hasRightSon()) {
            leaf = leaf.getRightSon();
          } else {
            break;
          }
        } else if (start.compareTo(leaf.getDataR()) == 0 ||
            start.compareTo(leaf.getDataL()) == 0) {
          break;
        } else {
          if (leaf.hasMiddleSon()) {
            leaf = leaf.getMiddleSon();
          } else {
            break;
          }
        }
      } else {
        if (start.compareTo(leaf.getDataL()) < 0) {
          if (leaf.hasLeftSon()) {
            leaf = leaf.getLeftSon();
          } else {
            break;
          }
        } else if (start.compareTo(leaf.getDataL()) == 0) {
          break;
        } else {
          if (leaf.hasRightSon()) {
            leaf = leaf.getRightSon();
          } else {
            break;
          }
        }
      }
    }
    bool left = true;
    while (leaf != null) {
      if (leaf.getDataL().compareTo(start) >= 0 &&
          leaf.getDataL().compareTo(end) <= 0) {
        left = true;
        break;
      }
      if (leaf.isThreeNode()) {
        if (leaf.getDataR().compareTo(start) >= 0 &&
            leaf.getDataR().compareTo(end) <= 0) {
          left = false;
          break;
        }
      }
      leaf = leaf.getParent();
    }
    return _getInOrderDataInterval(leaf, start, end, left);
  }

  List<T> _getInOrderDataInterval(
      TTTreeNode<K, T> node, T start, T end, bool left) {
    List<T> data = [];
    if (node == null) {
      return data;
    }
    var current = node;
    T actualData;

    if (!current.isLeaf()) {
      if (left) {
        actualData = current.getDataL();
      } else {
        actualData = current.getDataR();
      }
      data.add(actualData);
      if (left && current.isThreeNode()) {
        current = current.getMiddleSon();
      } else {
        current = current.getRightSon();
      }
    }
    bool isParent;
    while (current != null) {
      while (current.hasLeftSon()) {
        current = current.getLeftSon();
      }
      actualData = current.getDataL();
      if (actualData.compareTo(end) > 0) {
        break;
      }
      if (actualData.compareTo(start) >= 0) {
        data.add(actualData);
      }
      if (current.isThreeNode()) {
        actualData = current.getDataR();
        if (actualData.compareTo(end) > 0) {
          break;
        }
        if (actualData.compareTo(start) >= 0) {
          data.add(actualData);
        }
      }
      current = current.getParent();
      isParent = true;
      while (isParent && current != null) {
        if (current.isThreeNode()) {
          if (actualData.compareTo(current.getDataL()) < 0) {
            actualData = current.getDataL();
            if (actualData.compareTo(end) > 0) {
              current = null;
              break;
            }
            data.add(actualData);
            current = current.getMiddleSon();
            isParent = false;
          } else if (actualData.compareTo(current.getDataR()) > 0) {
            current = current.getParent();
            isParent = true;
          } else {
            actualData = current.getDataR();
            if (actualData.compareTo(end) > 0) {
              current = null;
              break;
            }
            data.add(actualData);
            current = current.getRightSon();
            isParent = false;
          }
        } else {
          if (actualData.compareTo(current.getDataL()) < 0) {
            actualData = current.getDataL();
            if (actualData.compareTo(end) > 0) {
              current = null;
              break;
            }
            data.add(actualData);
            current = current.getRightSon();
            isParent = false;
          } else {
            current = current.getParent();
            isParent = true;
          }
        }
      }
    }
    return data;
  }

/*
    Inorder bez rekurzie.
    Implementovane podla vlastneho navrhu.
     */
  List<T> getInOrderData() {
    var current = _root;
    List<T> data = [];
    if (current == null) {
      return data;
    }
    T actualData;
    bool isParent;
    while (current != null) {
      while (current.hasLeftSon()) {
        current = current.getLeftSon();
      }
      actualData = current.getDataL();
      data.add(actualData);
      if (current.isThreeNode()) {
        actualData = current.getDataR();
        data.add(actualData);
      }
      current = current.getParent();
      isParent = true;
      while (isParent && current != null) {
        if (current.isThreeNode()) {
          if (actualData.compareTo(current.getDataL()) < 0) {
            actualData = current.getDataL();
            data.add(actualData);
            current = current.getMiddleSon();
            isParent = false;
          } else if (actualData.compareTo(current.getDataR()) > 0) {
            current = current.getParent();
            isParent = true;
          } else {
            actualData = current.getDataR();
            data.add(actualData);
            current = current.getRightSon();
            isParent = false;
          }
        } else {
          if (actualData.compareTo(current.getDataL()) < 0) {
            actualData = current.getDataL();
            data.add(actualData);
            current = current.getRightSon();
            isParent = false;
          } else {
            current = current.getParent();
            isParent = true;
          }
        }
      }
    }
    return data;
  }

  T getMaxData() {
    var current = _root;
    if (current == null) {
      return null;
    }
    while (current.hasRightSon()) {
      current = current.getRightSon();
    }
    if (current.hasDataR()) {
      return current.getDataR();
    }
    return current.getDataL();
  }

  T removeMaxData() {
    return remove(getMaxData());
  }

  /*
    Len pre testove ucely.
   */
  void inOrderRecursive(TTTreeNode<K, T> node) {
    if (node == null) return;
    inOrderRecursive(node.getLeftSon());
    node.vypis();
    inOrderRecursive(node.getMiddleSon());
    inOrderRecursive(node.getRightSon());
  }

  /*
    Len pre testove ucely.
  */
  void preorder(TTTreeNode<K, T> node) {
    if (node == null) return;
    node.vypis();
    preorder(node.getLeftSon());
    preorder(node.getMiddleSon());
    preorder(node.getRightSon());
  }

  /*
    Len pre testove ucely. Vypis hlbky kazdeho listu pomocou rekurzie.
    Implementacia inspirovana podla toho, co som pocul na cviceni.
  */
  void deepOfLeaf(TTTreeNode<K, T> node) {
    if (node == null) {
      //print("null");
      return;
    }
    if (node.isLeaf()) {
      var leaf = node;
      var deep = 1;
      while (true) {
        if (leaf.hasParent()) {
          leaf = leaf.getParent();
          deep++;
        } else {
          break;
        }
      }
      if (kDebugMode) {
        print("Leaf deep: " + deep.toString());
      }
    }
    deepOfLeaf(node.getLeftSon());
    deepOfLeaf(node.getMiddleSon());
    deepOfLeaf(node.getRightSon());
  }

  TTTreeNode<K, T> _findLeaf(T data) {
    var leaf = _root;
    while (true) {
      if (leaf.isThreeNode()) {
        if (data.compareTo(leaf.getDataL()) < 0) {
          if (leaf.hasLeftSon()) {
            leaf = leaf.getLeftSon();
          } else {
            break;
          }
        } else if (data.compareTo(leaf.getDataR()) > 0) {
          if (leaf.hasRightSon()) {
            leaf = leaf.getRightSon();
          } else {
            break;
          }
        } else if (data.compareTo(leaf.getDataR()) == 0 ||
            data.compareTo(leaf.getDataL()) == 0) {
          break;
        } else {
          if (leaf.hasMiddleSon()) {
            leaf = leaf.getMiddleSon();
          } else {
            break;
          }
        }
      } else {
        if (data.compareTo(leaf.getDataL()) < 0) {
          if (leaf.hasLeftSon()) {
            leaf = leaf.getLeftSon();
          } else {
            break;
          }
        } else if (data.compareTo(leaf.getDataL()) == 0) {
          break;
        } else {
          if (leaf.hasRightSon()) {
            leaf = leaf.getRightSon();
          } else {
            break;
          }
        }
      }
    }
    if (leaf.isThreeNode()) {
      if (data.compareTo(leaf.getDataL()) != 0 &&
          data.compareTo(leaf.getDataR()) != 0) {
        return leaf;
      }
    } else {
      if (data.compareTo(leaf.getDataL()) != 0) {
        return leaf;
      }
    }
    return null;
  }

  /*
    Implementovane podla slovneho popisu z prednaskoveho dokumentu.
   */
  T search(T data) {
    var result = _searchNode(data);
    if (result == null) {
      return null;
    }
    if (data.compareTo(result.getDataL()) == 0) {
      return result.getDataL();
    } else if (result.isThreeNode() && data.compareTo(result.getDataR()) == 0) {
      return result.getDataR();
    }
    return null;
  }

  TTTreeNode<K, T> _searchNode(T data) {
    var result = _root;
    if (result == null) {
      return null;
    }
    while (data.compareTo(result.getDataL()) != 0) {
      if (result.hasDataR() && data.compareTo(result.getDataR()) == 0) {
        break;
      }
      if (result.isThreeNode()) {
        if (data.compareTo(result.getDataL()) < 0) {
          if (result.hasLeftSon()) {
            result = result.getLeftSon();
          } else {
            break;
          }
        } else if (data.compareTo(result.getDataR()) > 0) {
          if (result.hasRightSon()) {
            result = result.getRightSon();
          } else {
            break;
          }
        } else {
          if (result.hasMiddleSon()) {
            result = result.getMiddleSon();
          } else {
            break;
          }
        }
      } else {
        if (data.compareTo(result.getDataL()) < 0) {
          if (result.hasLeftSon()) {
            result = result.getLeftSon();
          } else {
            break;
          }
        } else {
          if (result.hasRightSon()) {
            result = result.getRightSon();
          } else {
            break;
          }
        }
      }
    }
    if (result.isThreeNode()) {
      return (data.compareTo(result.getDataL()) == 0 ||
              data.compareTo(result.getDataR()) == 0)
          ? result
          : null;
    }
    return data.compareTo(result.getDataL()) == 0 ? result : null;
  }

  TTTreeNode<K, T> getRoot() {
    return _root;
  }

  int getSize() {
    return _size;
  }

  /*
    Implementovane podla slovneho popisu z prednaskoveho dokumentu.
  */
  T remove(T data) {
    var node = _searchNode(data);
    if (node == null) {
      //print("Mazanie, prvok neexistuje: " + key.toString());
      return null;
    }
    T deletedData;
    bool left;
    if (data.compareTo(node.getDataL()) == 0) {
      deletedData = node.getDataL();
      left = true;
    } else {
      deletedData = node.getDataR();
      left = false;
    }
    if (!_tryToRemove(node, left)) {
      //print("Mazanie sa nepodarilo, kluc: " + deletedData.getKey());
      return null;
    }
    _size--;
    return deletedData;
  }

  bool _tryToRemove(TTTreeNode<K, T> node, bool leftToDelete) {
    if (node.isLeaf()) {
      if (!node.isThreeNode()) {
        if (node == _root) {
          _root = null;
          _height--;
          return true;
        } else {
          node.setDataL(null);
        }
      } else {
        if (leftToDelete) {
          node.setDataL(node.getDataR());
        }
        node.setDataR(null);
        return true;
      }
    }
    var inOrderLeaf = node;
    if (!node.isLeaf()) {
      inOrderLeaf = _findInOrderLeaf(node, leftToDelete);
    }

    if (!node.isLeaf()) {
      if (leftToDelete) {
        if (node.isThreeNode()) {
          if (node.getDataR().compareTo(inOrderLeaf.getDataL()) > 0) {
            node.setDataL(inOrderLeaf.getDataL());
          } else {
            T tempLeftData = node.getDataL();
            node.setDataL(inOrderLeaf.getDataL());
            node.setDataR(tempLeftData);
          }
        } else {
          node.setDataL(inOrderLeaf.getDataL());
        }
      } else {
        if (node.getDataL().compareTo(inOrderLeaf.getDataL()) < 0) {
          node.setDataR(inOrderLeaf.getDataL());
        } else {
          T tempLeftData = node.getDataR();
          node.setDataR(inOrderLeaf.getDataL());
          node.setDataL(tempLeftData);
        }
      }
      if (inOrderLeaf.isThreeNode()) {
        inOrderLeaf.setDataL(inOrderLeaf.getDataR());
        inOrderLeaf.setDataR(null);
      } else {
        inOrderLeaf.setDataL(null);
      }
    }

    while (true) {
      if (inOrderLeaf.hasDataL()) {
        return true;
      }

      if (inOrderLeaf == _root) {
        if (inOrderLeaf.hasLeftSon() && inOrderLeaf.getLeftSon().hasDataL()) {
          _root = inOrderLeaf.getLeftSon();
        } else if (inOrderLeaf.hasMiddleSon() &&
            inOrderLeaf.getMiddleSon().hasDataL()) {
          _root = inOrderLeaf.getMiddleSon();
        } else if (inOrderLeaf.hasRightSon() &&
            inOrderLeaf.getRightSon().hasDataL()) {
          _root = inOrderLeaf.getRightSon();
        } else {
          _root = null;
        }
        if (_root != null) {
          _root.setParent(null);
        }
        _height--;
        return true;
      }

      var inOrderLeafSonType = _getSonType(inOrderLeaf);
      var parent = inOrderLeaf.getParent();
      if (inOrderLeafSonType == TTTreeSonType.left) {
        if ((parent.isThreeNode() && parent.getMiddleSon().isThreeNode()) ||
            (!parent.isThreeNode() && parent.getRightSon().isThreeNode())) {
          if (parent.isThreeNode()) {
            inOrderLeaf.setDataL(parent.getDataL());
            parent.setDataL(parent.getMiddleSon().getDataL());
            parent.getMiddleSon().setDataL(parent.getMiddleSon().getDataR());
            parent.getMiddleSon().setDataR(null);
            if (!inOrderLeaf.isLeaf() && !parent.getMiddleSon().isLeaf()) {
              if (!inOrderLeaf.getLeftSon().hasDataL()) {
                inOrderLeaf.setLeftSon(inOrderLeaf.getRightSon());
              }
              inOrderLeaf.setRightSon(parent.getMiddleSon().getLeftSon());
              parent
                  .getMiddleSon()
                  .setLeftSon(parent.getMiddleSon().getMiddleSon());
              parent.getMiddleSon().setMiddleSon(null);
              inOrderLeaf.getRightSon().setParent(inOrderLeaf);
            }
          } else {
            inOrderLeaf.setDataL(parent.getDataL());
            parent.setDataL(parent.getRightSon().getDataL());
            parent.getRightSon().setDataL(parent.getRightSon().getDataR());
            parent.getRightSon().setDataR(null);
            if (!inOrderLeaf.isLeaf() && !parent.getRightSon().isLeaf()) {
              if (!inOrderLeaf.getLeftSon().hasDataL()) {
                inOrderLeaf.setLeftSon(inOrderLeaf.getRightSon());
              }
              inOrderLeaf.setRightSon(parent.getRightSon().getLeftSon());
              parent
                  .getRightSon()
                  .setLeftSon(parent.getRightSon().getMiddleSon());
              parent.getRightSon().setMiddleSon(null);
              inOrderLeaf.getRightSon().setParent(inOrderLeaf);
            }
          }
          return true;
        } else {
          if (parent.isThreeNode()) {
            T tempLeftData = parent.getMiddleSon().getDataL();
            parent.getMiddleSon().setDataL(parent.getDataL());
            parent.getMiddleSon().setDataR(tempLeftData);

            parent
                .getMiddleSon()
                .setMiddleSon(parent.getMiddleSon().getLeftSon());

            if (!parent.getLeftSon().isLeaf()) {
              if (parent.getLeftSon().getRightSon().hasDataL()) {
                parent
                    .getMiddleSon()
                    .setLeftSon(parent.getLeftSon().getRightSon());
                parent
                    .getLeftSon()
                    .getRightSon()
                    .setParent(parent.getMiddleSon());
              } else {
                parent
                    .getMiddleSon()
                    .setLeftSon(parent.getLeftSon().getLeftSon());
                parent
                    .getLeftSon()
                    .getLeftSon()
                    .setParent(parent.getMiddleSon());
              }
            }

            parent.setLeftSon(parent.getMiddleSon());
            parent.setMiddleSon(null);

            parent.setDataL(parent.getDataR());
            parent.setDataR(null);
          } else {
            T tempLeftData = parent.getRightSon().getDataL();
            parent.getRightSon().setDataL(parent.getDataL());
            parent.getRightSon().setDataR(tempLeftData);
            parent.setDataL(null);

            parent
                .getRightSon()
                .setMiddleSon(parent.getRightSon().getLeftSon());
            if (inOrderLeaf.hasLeftSon() &&
                inOrderLeaf.getLeftSon().hasDataL()) {
              parent.getRightSon().setLeftSon(inOrderLeaf.getLeftSon());
              inOrderLeaf.getLeftSon().setParent(parent.getRightSon());
            } else if (inOrderLeaf.hasRightSon() &&
                inOrderLeaf.getRightSon().hasDataL()) {
              parent.getRightSon().setLeftSon(inOrderLeaf.getRightSon());
              inOrderLeaf.getRightSon().setParent(parent.getRightSon());
            }
          }
        }
      } else if (inOrderLeafSonType == TTTreeSonType.right) {
        if ((parent.isThreeNode() && parent.getMiddleSon().isThreeNode()) ||
            (!parent.isThreeNode() && parent.getLeftSon().isThreeNode())) {
          if (parent.isThreeNode()) {
            inOrderLeaf.setDataL(parent.getDataR());
            parent.setDataR(parent.getMiddleSon().getDataR());
            parent.getMiddleSon().setDataR(null);
            if (!inOrderLeaf.isLeaf() && !parent.getMiddleSon().isLeaf()) {
              if (!inOrderLeaf.getRightSon().hasDataL()) {
                inOrderLeaf.setRightSon(inOrderLeaf.getLeftSon());
              }
              inOrderLeaf.setLeftSon(parent.getMiddleSon().getRightSon());
              parent
                  .getMiddleSon()
                  .setRightSon(parent.getMiddleSon().getMiddleSon());
              parent.getMiddleSon().setMiddleSon(null);
              inOrderLeaf.getLeftSon().setParent(inOrderLeaf);
            }
          } else {
            inOrderLeaf.setDataL(parent.getDataL());
            parent.setDataL(parent.getLeftSon().getDataR());
            if (!inOrderLeaf.isLeaf() && !parent.getLeftSon().isLeaf()) {
              if (!inOrderLeaf.getRightSon().hasDataL()) {
                inOrderLeaf.setRightSon(inOrderLeaf.getLeftSon());
              }
              inOrderLeaf.setLeftSon(parent.getLeftSon().getRightSon());
              parent
                  .getLeftSon()
                  .setRightSon(parent.getLeftSon().getMiddleSon());
              parent.getLeftSon().setMiddleSon(null);
              inOrderLeaf.getLeftSon().setParent(inOrderLeaf);
            }
            parent.getLeftSon().setDataR(null);
          }
          return true;
        } else {
          if (parent.isThreeNode()) {
            parent.getMiddleSon().setDataR(parent.getDataR());

            parent
                .getMiddleSon()
                .setMiddleSon(parent.getMiddleSon().getRightSon());

            if (!parent.getRightSon().isLeaf()) {
              if (parent.getRightSon().getRightSon().hasDataL()) {
                parent
                    .getMiddleSon()
                    .setRightSon(parent.getRightSon().getRightSon());
                parent
                    .getRightSon()
                    .getRightSon()
                    .setParent(parent.getMiddleSon());
              } else {
                parent
                    .getMiddleSon()
                    .setRightSon(parent.getRightSon().getLeftSon());
                parent
                    .getRightSon()
                    .getLeftSon()
                    .setParent(parent.getMiddleSon());
              }
            }

            parent.setRightSon(parent.getMiddleSon());

            parent.setMiddleSon(null);

            parent.setDataR(null);
          } else {
            parent.getLeftSon().setDataR(parent.getDataL());
            parent.setDataL(null);

            parent.getLeftSon().setMiddleSon(parent.getLeftSon().getRightSon());
            if (inOrderLeaf.hasLeftSon() &&
                inOrderLeaf.getLeftSon().hasDataL()) {
              parent.getLeftSon().setRightSon(inOrderLeaf.getLeftSon());
              inOrderLeaf.getLeftSon().setParent(parent.getLeftSon());
            } else if (inOrderLeaf.hasRightSon() &&
                inOrderLeaf.getRightSon().hasDataL()) {
              parent.getLeftSon().setRightSon(inOrderLeaf.getRightSon());
              inOrderLeaf.getRightSon().setParent(parent.getLeftSon());
            }
          }
        }
      } else {
        if (parent.getLeftSon().isThreeNode() ||
            parent.getRightSon().isThreeNode()) {
          if (parent.getLeftSon().isThreeNode()) {
            inOrderLeaf.setDataL(parent.getDataL());
            parent.setDataL(parent.getLeftSon().getDataR());
            parent.getLeftSon().setDataR(null);
            if (!inOrderLeaf.isLeaf() && !parent.getLeftSon().isLeaf()) {
              if (!inOrderLeaf.getRightSon().hasDataL()) {
                inOrderLeaf.setRightSon(inOrderLeaf.getLeftSon());
              }
              inOrderLeaf.setLeftSon(parent.getLeftSon().getRightSon());
              parent
                  .getLeftSon()
                  .setRightSon(parent.getLeftSon().getMiddleSon());
              parent.getLeftSon().setMiddleSon(null);
              inOrderLeaf.getLeftSon().setParent(inOrderLeaf);
            }
            return true;
          } else if (parent.getRightSon().isThreeNode()) {
            inOrderLeaf.setDataL(parent.getDataR());
            parent.setDataR(parent.getRightSon().getDataL());
            parent.getRightSon().setDataL(parent.getRightSon().getDataR());
            parent.getRightSon().setDataR(null);
            if (!inOrderLeaf.isLeaf() && !parent.getRightSon().isLeaf()) {
              if (!inOrderLeaf.getLeftSon().hasDataL()) {
                inOrderLeaf.setLeftSon(inOrderLeaf.getRightSon());
              }
              inOrderLeaf.setRightSon(parent.getRightSon().getLeftSon());
              parent
                  .getRightSon()
                  .setLeftSon(parent.getRightSon().getMiddleSon());
              parent.getRightSon().setMiddleSon(null);
              inOrderLeaf.getRightSon().setParent(inOrderLeaf);
            }
            return true;
          }
        } else {
          if (!parent.isThreeNode()) {
            if (kDebugMode) {
              print("Error: !parent.isThreeNode()");
            }
          }
          parent.getLeftSon().setDataR(parent.getDataL());
          parent.setDataL(parent.getDataR());

          parent.getLeftSon().setMiddleSon(parent.getLeftSon().getRightSon());

          if (!parent.getMiddleSon().isLeaf()) {
            if (parent.getMiddleSon().getRightSon().hasDataL()) {
              parent
                  .getLeftSon()
                  .setRightSon(parent.getMiddleSon().getRightSon());
              parent
                  .getMiddleSon()
                  .getRightSon()
                  .setParent(parent.getLeftSon());
            } else {
              parent
                  .getLeftSon()
                  .setRightSon(parent.getMiddleSon().getLeftSon());
              parent.getMiddleSon().getLeftSon().setParent(parent.getLeftSon());
            }
          }

          parent.setMiddleSon(null);

          parent.setDataR(null);
        }
      }

      inOrderLeaf = inOrderLeaf.getParent();
    }
  }

  TTTreeSonType _getSonType(TTTreeNode<K, T> node) {
    if (node != null) {
      var parent = node.getParent();
      if (parent != null) {
        if (parent.getRightSon() == node) {
          return TTTreeSonType.right;
        }
        if (parent.getMiddleSon() == node) {
          return TTTreeSonType.middle;
        }
        if (parent.getLeftSon() == node) {
          return TTTreeSonType.left;
        }
      }
    }
    return null;
  }

  TTTreeNode<K, T> _findInOrderLeaf(TTTreeNode<K, T> node, bool leftToDelete) {
    TTTreeNode<K, T> result;
    if (leftToDelete) {
      if (node.isThreeNode()) {
        if (node.hasMiddleSon()) {
          result = node.getMiddleSon();
        } else if (node.hasRightSon()) {
          result = node.getRightSon();
          if (kDebugMode) {
            print("Error in findInOrderLeaf, this should not happened.");
          }
        }
      } else {
        if (node.hasRightSon()) {
          result = node.getRightSon();
        }
      }
    } else {
      if (node.hasRightSon()) {
        result = node.getRightSon();
      }
    }
    if (result != null) {
      while (true) {
        if (result.hasLeftSon()) {
          result = result.getLeftSon();
        } else {
          break;
        }
      }
      return result;
    }
    if (kDebugMode) {
      print("Error in findInOrderLeaf, this should not happened.");
    }
    return null;
  }

  int getHeight() {
    return _height;
  }
}
