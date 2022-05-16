import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/models/typ_uzla.dart';
import 'package:optimalizacne_algoritmy/widgets/node_dropdown.dart';

import '../../application.dart';
import '../../models/node.dart';
import '../../text_fields/number_textfield.dart';
import '../../text_fields/string_textfield.dart';

class NodeEditScreen extends StatefulWidget {
  final Node node;

  const NodeEditScreen({Key key, this.node}) : super(key: key);

  @override
  _NodeEditScreenState createState() => _NodeEditScreenState();
}

class _NodeEditScreenState extends State<NodeEditScreen> {
  String _name;
  double _x;
  double _y;
  double _capacity;
  NodeType _type = NodeType.nespecifikovane;
  final _nameController = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _capacityController = TextEditingController();

  final _app = Application();

  @override
  void initState() {
    super.initState();
    if (widget.node != null) {
      _name = widget.node?.name;
      _x = widget.node?.lon;
      _y = widget.node?.lat;
      _capacity = widget.node?.capacity;
      _type = (widget.node?.type);

      _nameController.text = _name ?? '';
      _capacityController.text = _capacity == null ? '' : _capacity.toString();
    }
  }

  void _clearData() {
    setState(() {
      _name = '';
      _x = null;
      _y = null;
      _capacity = null;
      _type = NodeType.nespecifikovane;
      _nameController.clear();
      _controller2.clear();
      _controller3.clear();
      _capacityController.clear();
    });
  }

  void _setName(String name) {
    setState(() {
      _name = name;
    });
  }

  void _setX(double x) {
    setState(() {
      _x = x;
    });
  }

  void _setY(double y) {
    setState(() {
      _y = y;
    });
  }

  void _setType(NodeType type) {
    setState(() {
      _type = type;
    });
  }

  void _setCapacity(double kapacita) {
    setState(() {
      _capacity = kapacita;
    });
  }

  void _save() {
    if (widget.node != null) {
      _app.editNode(widget.node, _name, _capacity, _type);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uzol bol upravený'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      final node = Node(
        id: _app.nodesCount,
        lon: _x,
        lat: _y,
        capacity: _capacity,
        type: _type,
        name: _name,
      );
      _app.addNode(node);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uzol bol vytvorený'),
          backgroundColor: Colors.green,
        ),
      );
      _clearData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.node == null ? 'Nový uzol' : 'Uzol ${widget.node?.id}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            NodeTypeDropdown(_setType, _type),
            const SizedBox(height: 2),
            StringTextField(_setName, 'Názov', _nameController),
            const SizedBox(height: 2),
            if (widget.node == null)
              NumberTextField(_setX, 'Súradnica X', _controller2, true),
            if (widget.node == null) const SizedBox(height: 2),
            if (widget.node == null)
              NumberTextField(_setY, 'Súradnica Y', _controller3, true),
            if (widget.node == null) const SizedBox(height: 2),
            NumberTextField(
                _setCapacity,
                _type == NodeType.zakaznik ? 'Požiadavka' : 'Kapacita',
                _capacityController,
                true),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _x == null || _y == null
                  ? null
                  : () {
                      setState(() {
                        _save();
                      });
                    },
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text('Ulož'),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                // backgroundColor: MaterialStateProperty.all(Colors.brown),
              ),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
