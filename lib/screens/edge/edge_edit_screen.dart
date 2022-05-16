import 'package:flutter/material.dart';

import '../../application.dart';
import '../../models/edge.dart';
import '../../text_fields/number_textfield.dart';

class EdgeEditScreen extends StatefulWidget {
  final Edge edge;

  const EdgeEditScreen({Key key, this.edge}) : super(key: key);

  @override
  _EdgeEditScreenState createState() => _EdgeEditScreenState();
}

class _EdgeEditScreenState extends State<EdgeEditScreen> {
  double _length;
  int _from;
  int _to;
  bool _active = true;
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  final _lengthController = TextEditingController();

  final _app = Application();

  @override
  void initState() {
    super.initState();
    if (widget.edge != null) {
      _length = widget.edge?.length;
      _from = widget.edge?.from;
      _to = widget.edge?.to;
      _active = (widget.edge?.active);
      _lengthController.text = _length == null ? '' : _length.toString();
    }
  }

  void _clearData() {
    setState(() {
      _length = null;
      _from = null;
      _to = null;
      _controller.clear();
      _controller2.clear();
      _lengthController.clear();
    });
  }

  void _setLength(double length) {
    setState(() {
      _length = length;
    });
  }

  void _setFrom(int from) {
    setState(() {
      _from = from;
    });
  }

  void _setTo(int to) {
    setState(() {
      _to = to;
    });
  }

  void _save() {
    if (widget.edge != null) {
      _app.editEdge(widget.edge, _length, _active);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hrana bola upravená'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      if (_app.getNode(_from) == null) {
        _showSnackBar('Uzol \'Od\' neexistuje');
        return;
      }
      if (_app.getNode(_to) == null) {
        _showSnackBar('Uzol \'Do\' neexistuje');
        return;
      }
      final edge =
          Edge(id: _app.edgesCount, from: _from, to: _to, length: _length);
      _app.addEdge(edge);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hrana bola vytvorená'),
          backgroundColor: Colors.green,
        ),
      );
      _clearData();
    }
  }

  void _showSnackBar(String text) {
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
        title: Text(
            widget.edge == null ? 'Nová hrana' : 'Hrana ${widget.edge?.id}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            if (widget.edge == null)
              NumberTextField(_setFrom, 'Od', _controller, false),
            if (widget.edge == null) const SizedBox(height: 2),
            if (widget.edge == null)
              NumberTextField(_setTo, 'Do', _controller2, false),
            if (widget.edge == null) const SizedBox(height: 2),
            NumberTextField(_setLength, 'Dĺžka', _lengthController, true),
            if (widget.edge != null) const SizedBox(height: 2),
            if (widget.edge != null)
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 4.0, bottom: 0.0),
                child: SwitchListTile.adaptive(
                  title: const Text('Aktivovaná'),
                  secondary: const Icon(
                    Icons.linear_scale,
                    color: Colors.blueAccent,
                  ),
                  value: _active,
                  activeColor: Colors.blueAccent,
                  onChanged: (value) {
                    setState(() {
                      _active = value;
                    });
                  },
                ),
              ),
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
