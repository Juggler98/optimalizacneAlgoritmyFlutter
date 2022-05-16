import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/application.dart';
import 'package:optimalizacne_algoritmy/models/file_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatelessWidget {
  final Application _app = Application();

  MainDrawer({Key key}) : super(key: key);

  void _showSnackBar(String text, BuildContext context, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        duration: const Duration(seconds: 8),
      ),
    );
  }

  String _getFileResultString(FileResult type) {
    switch (type) {
      case FileResult.fileNotExist:
        return 'Jeden zo súborov neexistuje';
      case FileResult.idIsNotId2:
        return 'V súbore edges_incid by malo byť na každom riadku rovnaké ID ako v edges.atr (ak hrana nemá dĺžku nastav jej -1)';
      case FileResult.notIncident:
        return 'Jednej z hrán chýba vrchol';
      case FileResult.notCoordinate:
        return 'Jeden z vrcholov nemá súradnicu';
      case FileResult.incidentCountLength:
        return 'Súbor edges_incid.txt by mal mať rovnaký počet riadkov ako edges.atr (ak hrana nemá dĺžku nastav jej -1)';
      case FileResult.nodeIdCountCoordinate:
        return 'Súbor nodes.atr by mal mať rovnaký počet riadkov ako nodes.atr (skús vymazať celý súbor nodes.atr)';
      case FileResult.correct:
        return 'correct';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 110,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomLeft,
              color: Colors.indigo,
              child: const Text(
                'Optimalizačné algoritmy',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(
                Icons.calculate_outlined,
                color: Colors.black54,
              ),
              title: const Text('Klasický Clarke-Wrightov algoritmus'),
              onTap: () {
                Navigator.of(context).pop();
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (ctx) => GeneratorScreen(),
                //   ),
                // );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.upload_outlined,
                color: Colors.black54,
              ),
              title: const Text('Načítaj z priečinka'),
              onTap: () async {
                try {
                  String selectedDirectory =
                      await FilePicker.platform.getDirectoryPath();
                  if (selectedDirectory != null) {
                    _app.removeAllData();
                    final result = await _app.loadData(selectedDirectory);
                    if (result == FileResult.correct) {
                      _showSnackBar(
                          'Dáta boli načítané', context, Colors.green);
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString('path', selectedDirectory);
                    } else {
                      if (kDebugMode) {
                        print(_getFileResultString(result));
                      }
                      _showSnackBar(
                          _getFileResultString(result), context, Colors.red);
                    }
                  }
                } catch (e) {
                  _showSnackBar(
                      'Nastala chyba pri načítaní', context, Colors.red);
                }
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.save_outlined,
                color: Colors.black54,
              ),
              title: const Text('Ulož do priečinka'),
              onTap: () async {
                try {
                  String selectedDirectory =
                      await FilePicker.platform.getDirectoryPath();
                  if (selectedDirectory != null) {
                    _showSnackBar('Dáta sa ukladajú', context, Colors.green);
                    await _app.writeToDirectory(selectedDirectory);
                  }
                  _showSnackBar('Dáta boli uložené', context, Colors.green);
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString('path', selectedDirectory);
                } catch (e) {
                  _showSnackBar(
                      'Nastala chyba pri ukladaní', context, Colors.red);
                }
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.black54,
              ),
              title: const Text('Vymaž všetko'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Určite?'),
                        content:
                            const Text('Určite chceš vymazať všetky dáta?'),
                        actions: [
                          TextButton(
                            child: const Text("Vymazať"),
                            onPressed: () {
                              _app.removeAllData();
                              _showSnackBar(
                                  'Dáta boli vymazané', context, Colors.green);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text("Zrušiť"),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
