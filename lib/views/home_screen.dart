import 'package:capstone_project_hcmut/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.name}) : super(key: key);
  final String name;
  static const String routeName = 'HomeScreen';
  static MaterialPage page({required String page}) {
    return MaterialPage(
      child: HomeScreen(name: page),
      key: const ValueKey(routeName),
      name: routeName,
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManagerViewModel>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            value.getTitle(widget.name),
            style: Theme.of(context).textTheme.headline2?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
        body: SafeArea(
            child: IndexedStack(
          index: value.instance.currentIndex,
          children: value.instance.listofPage,
        )),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz),
              label: 'Quizzes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'English Books',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online),
              label: 'Tests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.developer_mode),
              label: 'Demo',
            ),
          ],
          currentIndex: value.instance.currentIndex,
          selectedItemColor:
              Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor:
              Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          onTap: (index) => value.goToTab(context, index),
        ),
      );
    });
  }
}
