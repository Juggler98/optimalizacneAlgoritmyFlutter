import 'package:flutter_settings_screens/flutter_settings_screens.dart' as sett;
import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/models/node_type.dart';
import 'package:optimalizacne_algoritmy/widgets/capacity_dialog.dart';

import '../application.dart';
import '../constants.dart';
import '../models/node.dart';
import '../static_methods.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key key}) : super(key: key);

  final Application _app = Application();

  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey,
      ),
      title: Text(
        title,
        style: const TextStyle(),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sett.SettingsScreen(
        title: 'Nastavenia',
        children: [
          const ListTile(
            title: Text(
              'Uzly',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              const Icon(
                Icons.crop,
                color: Colors.grey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: sett.RadioModalSettingsTile<int>(
                  title: 'Nastaviť typ pre všetky uzly',
                  settingKey: 'key_type',
                  subtitle: null,
                  values: <int, String>{
                    0: Node.getNodeTypeString(NodeType.primarnyZdroj),
                    1: Node.getNodeTypeString(NodeType.zakaznik),
                    2: Node.getNodeTypeString(NodeType.prekladiskoMozne),
                    3: Node.getNodeTypeString(NodeType.nespecifikovane),
                  },
                  selected: 0,
                  onChange: (value) {
                    for (var node in _app.allNodes) {
                      node.type = NodeType.values.elementAt(value);
                    }
                    _app.update();
                    sett.Settings.setValue('key_type', -1);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          const Divider(),
          buildListTile(
            'Nastaviť kapacitu všetkým uzlom',
            Icons.crop_square,
            () {
              showDialog(
                context: context,
                builder: (ctx) => ChangeCapacityDialog(
                    context, ctx, true, 'Kapacita pre uzly'),
              ).then((value) {
                if (value != null) {
                  _app.setCapacity(double.parse(value));
                }
              });
            },
          ),
          const Divider(),
          buildListTile(
            'Nastaviť náhodnu kapacitu všetkým uzlom',
            Icons.crop_free,
            () {
              showDialog(
                context: context,
                builder: (ctx) => ChangeCapacityDialog(
                    context, ctx, false, 'Rozmedzie náhodnej kapacity'),
              ).then((value) {
                if (value != null) {
                  _app.setRandomCapacity(int.parse(value));
                }
              });
            },
          ),
          const Divider(),
          const ListTile(
            title: Text(
              'Ostatné',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          buildListTile('Vymaž všetko', Icons.delete_forever_outlined, () {
            showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text('Určite?'),
                    content: const Text('Určite chceš vymazať všetky dáta?'),
                    actions: [
                      TextButton(
                        child: const Text("Vymazať"),
                        onPressed: () {
                          _app.removeAllData();
                          StaticMethods.showSnackBar(
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
          }),
          buildListTile('Info', Icons.info_outline, () {
            showAboutDialog(
              context: context,
              applicationIcon: Image.asset(
                'assets/icon.png',
                width: 48,
              ),
              applicationName: 'Optimalizačné algoritmy',
              applicationVersion: version,
              applicationLegalese: '© 2022 Adam Belianský',
            );
          })
        ],
      ),
    );
  }
}
