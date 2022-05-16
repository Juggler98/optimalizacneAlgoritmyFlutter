import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/application.dart';
import 'package:optimalizacne_algoritmy/constants.dart';
import 'package:optimalizacne_algoritmy/static_methods.dart';
import 'package:optimalizacne_algoritmy/screens/edge/edge_isolated_screen.dart';
import 'package:optimalizacne_algoritmy/screens/node/node_isolated_screen.dart';

class MainDrawer extends StatelessWidget {
  final Application _app = Application();

  MainDrawer({Key key}) : super(key: key);

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
                await StaticMethods.loadData(context);
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
                await StaticMethods.saveData(context);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.crop_square,
                color: Colors.black54,
              ),
              title: const Text('Zobraz izolované uzly'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => NodeIsolatedScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.linear_scale,
                color: Colors.black54,
              ),
              title: const Text('Zobraz izolované hrany'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => EdgeIsolatedScreen(),
                  ),
                );
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
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.insert_drive_file_outlined,
                color: Colors.black54,
              ),
              title: const Text('Info k súborom'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    scrollable: true,
                    title: const Text('Info k súborom'),
                    content: const Text(
                        'Súbory s dátami musia byť v jednom priečinku.\n'
                        'Tento priečinok je potrebné pri načítaní zvoliť.\n'
                        '----------\n'
                        'Súbory musia mať nasledovné názvy:\n'
                        'nodes.vec\n'
                        'edges_incid.txt\n'
                        'edges.atr\n'
                        'nodes.atr\n'
                        'nodes_data.txt\n'
                        'edges_data.txt\n'
                        '----------\n'
                        'Potrebné sú 2 súbory:\n'
                        '1. nodes.vec s formátom:\n'
                        'ID\n'
                        'X Y\n'
                        '\n'
                        '2. edges_incid.txt s formátom:\n'
                        'IDhrany IDuzla IDuzla2\n'
                        '----------\n'
                        'Súbor edges.atr je voliteľný a obsahuje dĺžky jednotlivých\n'
                        'hrán s formátom:\n'
                        'ID DĹŽKA\n'
                        '----------\n'
                        'Súbor nodes.atr obsahuje iba ID uzlov, tento súbor je nepovinný.\n'
                        '----------\n'
                        'Súbor nodes_data.txt generuje aplikácia pri uložení dát s formátom:\n'
                        'ID TYPEINDEX CAPACITY NAME\n'
                        '\n'
                        'TYPEINDEX:\n'
                        '0 = primárny zdroj\n'
                        '1 = zákazník\n'
                        '2 = možné prekladisko\n'
                        '3 = nešpecifikované\n'
                        '----------\n'
                        'Súbor edges_data.txt generuje aplikácia pri uložení dát s formátom:\n'
                        'ID ACTIVE\n'
                        '\n'
                        'Ak ACTIVE = 1, hrana je aktívna, ak ACTIVE = 0, hrana je deaktivovaná'),
                    actions: [
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: Colors.black54,
              ),
              title: const Text('Info'),
              onTap: () {
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
