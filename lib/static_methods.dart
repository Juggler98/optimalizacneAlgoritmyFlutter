import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/application.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/file_result.dart';

class StaticMethods {
  static final _app = Application();

  static void showSnackBar(String text, BuildContext context, Color color,
      {int duration = 8}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        duration: Duration(seconds: duration),
      ),
    );
  }

  static String _getFileResultString(FileResult type) {
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

  static Future<void> saveData(BuildContext context) async {
    String selectedDirectory;
    try {
      if (Platform.isAndroid) {
        FilePickerResult filesPicked =
            await FilePicker.platform.pickFiles(allowMultiple: true);

        if (filesPicked != null) {
          List<File> files =
              filesPicked.paths.map((path) => File(path)).toList();
          selectedDirectory = files.elementAt(0).parent.path;
        }
      } else {
        selectedDirectory = await FilePicker.platform.getDirectoryPath();
      }
      if (selectedDirectory != null) {
        showSnackBar('Dáta sa ukladajú', context, Colors.green);
        await _app.writeToDirectory(selectedDirectory);
        showSnackBar('Dáta boli uložené', context, Colors.green);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('path', selectedDirectory);
      }
    } catch (e) {
      showSnackBar('Nastala chyba pri ukladaní', context, Colors.red);
    }
  }

  static Future<void> loadData(BuildContext context) async {
    String selectedDirectory;
    try {
      if (Platform.isAndroid) {
        FilePickerResult filesPicked =
            await FilePicker.platform.pickFiles(allowMultiple: true);

        if (filesPicked != null) {
          List<File> files =
              filesPicked.paths.map((path) => File(path)).toList();
          selectedDirectory = files.elementAt(0).parent.path;
        }
      } else {
        selectedDirectory = await FilePicker.platform.getDirectoryPath();
      }
      if (selectedDirectory != null) {
        _app.removeAllData();
        final result = await _app.loadData(selectedDirectory);
        if (result == FileResult.correct) {
          showSnackBar('Dáta boli načítané', context, Colors.green);
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('path', selectedDirectory);
        } else {
          if (kDebugMode) {
            print(_getFileResultString(result));
          }
          showSnackBar(_getFileResultString(result), context, Colors.red);
        }
      }
    } catch (e) {
      showSnackBar('Nastala chyba pri načítaní', context, Colors.red);
    }
  }
}
