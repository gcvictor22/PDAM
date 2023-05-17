import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pdam_app/pages/events_page.dart';
import 'package:pdam_app/pages/posts_page.dart';
import 'package:pdam_app/pages/profile_page.dart';
import 'package:pdam_app/pages/search_page.dart';
import '../models/models.dart';
import 'new_post_page.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return HomePageStates(user: user);
  }
}

class HomePageStates extends StatefulWidget {
  final User user;
  const HomePageStates({super.key, required this.user});

  @override
  State<HomePageStates> createState() => _HomePageStatesState(user);
}

class _HomePageStatesState extends State<HomePageStates> {
  final User user;
  _HomePageStatesState(this.user);

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      PostsPage(),
      EventsPage(),
      NewPostPage(),
      SearchPage(),
      ProfilePage()
    ];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/main-background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _screens[_selectedIndex],
        extendBody: true,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(255, 99, 99, 99),
              ),
            ),
          ),
          child: BlurryContainer(
            color: Color.fromRGBO(173, 29, 254, 1).withOpacity(0.35),
            blur: 8,
            elevation: 4,
            borderRadius: BorderRadius.all(Radius.zero),
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
              child: GNav(
                gap: 8,
                onTabChange: (value) {
                  _onItemSelected(value);
                },
                tabs: [
                  GButton(
                    icon: Icons.home,
                    iconSize: 25,
                    text: "Inicio",
                    iconColor: Colors.white,
                    iconActiveColor: Colors.black,
                  ),
                  GButton(
                    icon: Icons.my_library_music,
                    iconSize: 25,
                    text: "Eventos",
                    iconColor: Colors.white,
                    iconActiveColor: Colors.black,
                  ),
                  GButton(
                    icon: Icons.add_circle_outline,
                    iconSize: 25,
                    text: "Postear",
                    iconColor: Colors.white,
                    iconActiveColor: Colors.black,
                  ),
                  GButton(
                    icon: Icons.search,
                    iconSize: 25,
                    text: "Buscar",
                    iconColor: Colors.white,
                    iconActiveColor: Colors.black,
                  ),
                  GButton(
                    icon: Icons.account_circle,
                    iconSize: 25,
                    text: "Perfil",
                    iconColor: Colors.white,
                    iconActiveColor: Colors.black,
                  )
                ],
                backgroundColor: Colors.transparent,
                tabBackgroundColor: Colors.white,
                padding: EdgeInsets.all(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
