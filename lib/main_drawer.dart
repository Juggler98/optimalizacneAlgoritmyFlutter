import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/application.dart';
import 'package:optimalizacne_algoritmy/models/node_type.dart';
import 'package:optimalizacne_algoritmy/screens/settings_screen.dart';
import 'package:optimalizacne_algoritmy/static_methods.dart';
import 'package:optimalizacne_algoritmy/screens/edge/edge_isolated_screen.dart';
import 'package:optimalizacne_algoritmy/screens/node/node_isolated_screen.dart';
import 'package:optimalizacne_algoritmy/widgets/capacity_dialog.dart';

import 'models/node.dart';
import 'screens/clarke_wright/cw_routes_screen.dart';

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
                Node centre;
                var eachIsCostumer = true;
                var eachHasCapacity = true;
                for (var node in _app.allNodes) {
                  if (node.type == NodeType.primarnyZdroj) {
                    centre = node;
                    break;
                  }
                }
                for (var node in _app.allNodes) {
                  if (node.type != NodeType.zakaznik && node != centre) {
                    eachIsCostumer = false;
                    break;
                  }
                  if (node.capacity == null && node != centre) {
                    eachHasCapacity = false;
                    break;
                  }
                }
                if (centre == null) {
                  StaticMethods.showSnackBar(
                      'Nie je zvolené žiadne stredisko (Primárny zdroj)',
                      context,
                      Colors.red,
                      duration: 6);
                  return;
                }

                if (!eachIsCostumer) {
                  StaticMethods.showSnackBar(
                      'Všetky vrcholy okrem strediska by mali byť typu zákazník. V nastaveniach môžeš inicializovať uzly hromadne.',
                      context,
                      Colors.red,
                      duration: 8);
                  return;
                }

                if (!eachHasCapacity) {
                  StaticMethods.showSnackBar(
                      'Všetky zákaznicke vrcholy by mali mať definovanú požiadavku. V nastaveniach môžeš inicializovať uzly hromadne.',
                      context,
                      Colors.red,
                      duration: 8);
                  return;
                }
                showDialog(
                  context: context,
                  builder: (ctx) => ChangeCapacityDialog(
                      context, ctx, true, 'Kapacita vozidla'),
                ).then((value) {
                  if (value != null) {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => RoutesScreen(
                            centre: centre.id,
                            vehicleCapacity: double.parse(value)),
                      ),
                    );
                  }
                });
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
                Icons.settings_outlined,
                color: Colors.black54,
              ),
              title: const Text('Nastavenia'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
