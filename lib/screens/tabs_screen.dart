import 'package:flutter/material.dart';
import 'package:optimalizacne_algoritmy/screens/edge/edge_edit_screen.dart';
import 'package:optimalizacne_algoritmy/screens/edge/edges_screen.dart';
import 'package:optimalizacne_algoritmy/screens/graph_screen.dart';
import 'package:optimalizacne_algoritmy/screens/node/node_edit_screen.dart';
import 'package:optimalizacne_algoritmy/screens/node/nodes_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  late List<Widget> _pages;

  late PageController _pageController;

  var _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      const NodesScreen(),
      const EdgesScreen(),
      const GraphScreen(),
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    if (_selectedPageIndex != index) {
      setState(() {
        _selectedPageIndex = index;
        _pageController.jumpToPage(index);
      });
    }
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Optimalizačné algoritmy',
        ),
        actions: [
          // IconButton(
          //     icon: const Icon(Icons.refresh),
          //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          //     tooltip: 'Reload',
          //     onPressed: () {
          //       setState(() {
          //         _selectEvenSamePage(0);
          //       });
          //     }),
        ],
      ),
      // drawer: const MainDrawer(),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _selectedPageIndex == 0 ||  _selectedPageIndex == 1 ? FloatingActionButton(
        tooltip: 'Vytvor',
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.crop_square),
                      title: const Text('Nový uzol'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const NodeEditScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.linear_scale),
                      title: const Text('Nová hrana'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const EdgeEditScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              });
        },
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blue,
        currentIndex: _selectedPageIndex,
        // selectedIconTheme: IconThemeData(color: Colors.green),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.crop_square),
            label: 'Uzly',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.linear_scale),
            label: 'Hrany',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Graficky',
          ),
        ],
      ),
    );
  }
}
