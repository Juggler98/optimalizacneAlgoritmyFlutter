import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/models/typ_uzla.dart';
import 'package:optimalizacne_algoritmy/widgets/node_dropdown.dart';

import '../../application.dart';
import '../../models/edge.dart';
import '../../models/node.dart';
import '../../text_fields/number_textfield.dart';
import '../../text_fields/string_textfield.dart';

class EdgeNewScreen extends StatefulWidget {
  const EdgeNewScreen({Key? key}) : super(key: key);

  @override
  _EdgeNewScreenState createState() => _EdgeNewScreenState();
}

class _EdgeNewScreenState extends State<EdgeNewScreen> {
  double? _length;
  int? _from;
  int? _to;
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();

  final _app = Application();

  void _clearData() {
    setState(() {
      _length = null;
      _from = null;
      _to = null;
      _controller.clear();
      _controller2.clear();
      _controller3.clear();
    });
  }

  void _setLength(double? length) {
    setState(() {
      _length = length;
    });
  }

  void _setFrom(int? from) {
    setState(() {
      _from = from;
    });
  }

  void _setTo(int? to) {
    setState(() {
      _to = to;
    });
  }

  void _save() {
    if (_app.uzly.firstWhere((element) => element.id == _from,
        orElse: () => Uzol(id: -1)).id == -1) {
      _showScaffold('Uzol \'Od\' neexistuje');
      return;
    }
    if (_app.uzly.firstWhere((element) => element.id == _to,
        orElse: () => Uzol(id: -1)).id == -1) {
      _showScaffold('Uzol \'Do\' neexistuje');
      return;
    }
    final edge = Hrana(id: _app.edgesCount, from: _from!, to: _to!, length: _length);
    _app.addEdge(edge);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hrana bola vytvorená'),
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
        title: const Text('Nová hrana'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            NumberTextField(_setFrom, 'Od', _controller, false),
            const SizedBox(height: 2),
            NumberTextField(_setTo, 'Do', _controller2, false),
            const SizedBox(height: 2),
            NumberTextField(_setLength, 'Dĺžka', _controller3, true),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _from == null || _to == null
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
