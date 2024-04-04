import 'package:flutter/material.dart';

import 'package:nket/services/firebase/auth.dart';
import 'package:nket/services/utils.dart';

// subscreens
import 'Home.dart';
import 'PriceList.dart';
import 'InsertItem.dart';

class Index extends StatefulWidget {
  Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _currentIndex = 0;
  final List<String> _titles = ['Home', 'Research', 'INsert'];

  void _onChangeScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String? _userEmail = Auth().currentUser()!.email;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void openScaffold() {
    if (_currentIndex != 0) return;
    scaffoldKey.currentState?.openDrawer();
  }

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    PriceList(),
    InsertItem()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_titles[_currentIndex]),
        actions: [
          if (_currentIndex == 0)
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: openScaffold,
                  child: CircleAvatar(
                    backgroundColor:
                        Utils().genRGBAfromEmail(email: _userEmail),
                    child: Text(
                      _userEmail!.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ))
        ],
      ),
      body: _widgetOptions.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onChangeScreen,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "research"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "insert")
        ],
      ),
      drawer: Drawer(
          semanticLabel: 'nnn',
          child: ListView(
            children: [
              ListTile(
                title: TextButton(
                    child: Text('logout'),
                    onPressed: () async => await Auth().logout()),
              ),
              const ListTile(
                title: TextButton(child: Text('guadagni'), onPressed: null),
              )
            ],
          )),
    );
  }
}
