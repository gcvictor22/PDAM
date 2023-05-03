import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:pdam_app/models/post/GetPostDto.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../config/locator.dart';
import '../models/models.dart';
import '../services/authentication_service.dart';

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
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    List<Widget> _screens = [
      PostsPage(),
      EventsPage(),
      NewPostPage(),
      SearchPage(),
      ProfilePage(authBloc, user)
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
                  setState(() {
                    _onItemSelected(value);
                  });
                },
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: "Inicio",
                    iconColor: Colors.white,
                    iconActiveColor: Colors.black,
                  ),
                  GButton(
                    icon: Icons.my_library_music,
                    text: "Eventos",
                    iconColor: Colors.white,
                    iconActiveColor: Colors.black,
                  ),
                  GButton(
                    icon: Icons.add_circle_outline,
                    text: "Postear",
                    iconColor: Colors.white,
                    iconActiveColor: Colors.black,
                  ),
                  GButton(
                    icon: Icons.person_search,
                    text: "Conocer",
                    iconColor: Colors.white,
                    iconActiveColor: Colors.black,
                  ),
                  GButton(
                    icon: Icons.account_circle,
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

Widget PostsPage() {
  return DefaultTabController(
    length: 2,
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 99, 99, 99),
              ),
            ),
          ),
          padding: EdgeInsets.only(top: 50, bottom: 8),
          child: TabBar(
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 5,
            labelColor: Color.fromRGBO(173, 29, 254, 1),
            unselectedLabelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: "Siguiendo",
              ),
              Tab(
                text: "Todos",
              )
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      Post(
                        new GetPostDto.fromJson(
                          {
                            "id": 57,
                            "affair": "Marketing Manager",
                            "content":
                                "Dejaré las redes sociales. Tengo todo el derecho de defender a mis amigos. Digan lo que quieran sobre mí, pero moriría por mis amigos. Muchas gracias.",
                            "imgPath": ["VACIO"],
                            "userWhoPost": {
                              "userName": "ferxxo",
                              "imgPath": "default.png",
                              "verified": true
                            },
                            "usersWhoLiked": 0,
                            "comments": 0,
                            "likedByUser": false,
                            "postDate": "17/01/2023 00:00:00"
                          },
                        ),
                      ),
                      SizedBox(
                        height: 90,
                      )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        height: 200,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                      ),
                      Container(
                        color: Colors.white,
                        height: 200,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                      ),
                      Container(
                        color: Colors.white,
                        height: 200,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                      ),
                      Container(
                        color: Colors.white,
                        height: 200,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                      ),
                      Container(
                        color: Colors.red,
                        height: 200,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                      ),
                      Container(
                        color: Colors.white,
                        height: 200,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                      ),
                      Container(
                        color: Colors.white,
                        height: 200,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                      ),
                      SizedBox(
                        height: 90,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget EventsPage() {
  return Container();
}

Widget NewPostPage() {
  return Container();
}

Widget SearchPage() {
  return Container();
}

Widget ProfilePage(AuthenticationBloc authBloc, User user) {
  return SafeArea(
    bottom: false,
    minimum: const EdgeInsets.all(16),
    child: Center(
      child: Column(
        children: <Widget>[
          Text(
            'Welcome, ${user.fullName}',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
            child: Text('Logout'),
            onPressed: () {
              authBloc.add(UserLoggedOut());
            },
          ),
          ElevatedButton(
              onPressed: () async {
                print("Check");
                JwtAuthenticationService service =
                    getIt<JwtAuthenticationService>();
                await service.getCurrentUser();
              },
              child: Text('Check'))
        ],
      ),
    ),
  );
}

Widget Post(GetPostDto post) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
      border: Border.all(
        color: Color.fromRGBO(173, 29, 254, 1),
      ),
    ),
    width: double.infinity,
    padding: EdgeInsets.all(15),
    child: TextButton(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStatePropertyAll(Colors.transparent),
      ),
      onPressed: () => print(post.id),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => print(post.userWhoPost.userName),
            style: ButtonStyle(
              padding: MaterialStatePropertyAll(
                EdgeInsets.only(top: 5, bottom: 5),
              ),
              backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 233, 233, 233),
              ),
              shadowColor: MaterialStatePropertyAll(
                Color.fromRGBO(173, 29, 254, 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(
                    "https://i1.sndcdn.com/artworks-qouKA7r3wgshfj9G-mF77dg-t500x500.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  post.userWhoPost.userName.length < 15
                      ? post.userWhoPost.userName
                      : post.userWhoPost.userName.substring(0, 12) + "...",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  width: 5,
                ),
                post.userWhoPost.verified
                    ? Icon(
                        Icons.verified,
                        color: Colors.blue,
                      )
                    : Text(""),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(
              post.affair,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            width: double.infinity,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              post.content,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            width: double.infinity,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LikeButton(
                  likeCount: post.usersWhoLiked,
                  isLiked: post.likedByUser,
                  likeBuilder: (isLiked) {
                    var color = isLiked
                        ? const Color.fromARGB(255, 255, 17, 0)
                        : Colors.black;
                    return Icon(
                      Icons.favorite,
                      color: color,
                    );
                  },
                  countBuilder: (likeCount, isLiked, text) {
                    return Text(
                      "${text}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    );
                  },
                ),
                Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.message,
                        size: 25,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${post.comments}",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${post.postDate.split(" ")[0]}\n${post.postDate.split(" ")[1]}",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
