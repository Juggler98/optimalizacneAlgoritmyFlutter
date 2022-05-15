import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/models/typ_uzla.dart';

import '../models/node.dart';

class NodeTypeDropdown extends StatefulWidget {
  final Function changeValue;
  final NodeType type;

  const NodeTypeDropdown(this.changeValue, this.type, {Key key}) : super(key: key);

  @override
  _NodeTypeDropdownState createState() => _NodeTypeDropdownState();
}

class _NodeTypeDropdownState extends State<NodeTypeDropdown> {
  NodeType _nodeTypeChoose = NodeType.nespecifikovane;

  @override
  void initState() {
    super.initState();
  }

  final _nodeTypeItems = [
    NodeType.primarnyZdroj,
    NodeType.zakaznik,
    NodeType.prekladiskoMozne,
    NodeType.nespecifikovane,
  ];

  @override
  Widget build(BuildContext context) {
    _nodeTypeChoose = widget.type;
    return Padding(
      padding:
          const EdgeInsets.only(left: 30.0, right: 30.0, top: 8.0, bottom: 2.0),
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 24, top: 0, bottom: 0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: DropdownButton(
          hint: const Text('Vyber typ uzla'),
          isExpanded: true,
          underline: const SizedBox(),
          value: _nodeTypeChoose,
          onChanged: (newValue) {
            setState(() {
              _nodeTypeChoose = newValue as NodeType;
              widget.changeValue(newValue);
            });
          },
          items: _nodeTypeItems.map((valueItem) {
            return DropdownMenuItem(
              value: valueItem,
              child: Text(Node.getNodeTypeString(valueItem)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
