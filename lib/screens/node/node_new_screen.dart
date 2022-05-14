import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/models/typ_uzla.dart';
import 'package:optimalizacne_algoritmy/widgets/node_dropdown.dart';

import '../../application.dart';
import '../../models/node.dart';
import '../../text_fields/number_textfield.dart';
import '../../text_fields/string_textfield.dart';

class NodeNewScreen extends StatefulWidget {
  const NodeNewScreen({Key? key}) : super(key: key);

  @override
  _NodeNewScreenState createState() => _NodeNewScreenState();
}

class _NodeNewScreenState extends State<NodeNewScreen> {
  String? _name;
  double? _x;
  double? _y;
  double? _kapacita;
  NodeType? _type;
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();

  final _app = Application();

  void _clearData() {
    setState(() {
      _name = '';
      _x = null;
      _y = null;
      _kapacita = null;
      _controller.clear();
      _controller2.clear();
      _controller3.clear();
      _controller4.clear();
    });
  }

  void _setName(String? name) {
    setState(() {
      _name = name;
    });
  }

  void _setX(double? x) {
    setState(() {
      _x = x;
    });
  }

  void _setY(double? y) {
    setState(() {
      _y = y;
    });
  }

  void _setType(NodeType type) {
    setState(() {
      _type = type;
    });
  }

  void _setKapacita(double? kapacita) {
    setState(() {
      _kapacita = kapacita;
    });
  }

  void _save() {
    final node = Uzol(
      id: _app.nodesCount,
      lon: _x,
      lat: _y,
      capacity: _kapacita,
      type: _type,
      name: _name,
    );
    _app.addNode(node);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Uzol bol vytvorený'),
      ),
    );
    _clearData();
  }

  void _showScaffold(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nový uzol'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            NodeTypeDropdown(_setType),
            const SizedBox(height: 2),
            StringTextField(_setName, 'Názov', _controller),
            const SizedBox(height: 2),
            NumberTextField(_setX, 'Súradnica X', _controller2, true),
            const SizedBox(height: 2),
            NumberTextField(_setY, 'Súradnica Y', _controller3, true),
            const SizedBox(height: 2),
            NumberTextField(_setKapacita, 'Kapacita', _controller4, true),
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
