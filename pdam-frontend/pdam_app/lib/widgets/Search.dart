import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdam_app/models/event/GetEventDtoReponse.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/search/search_bloc.dart';
import '../models/user/GetUserDto.dart';
import '../rest/rest_client.dart';

class UserCard extends StatefulWidget {
  final GetUserDto user;
  final BuildContext context;
  const UserCard({super.key, required this.user, required this.context});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late bool followed;
  late int numberOfFollowers;

  @override
  void initState() {
    super.initState();
    followed = widget.user.followedByUser;
    numberOfFollowers = widget.user.followers;
  }

  dynamic _convertNumber(int number) {
    if (number < 1000) {
      return number;
    } else if (number >= 1000 && number < 1000000) {
      return (number / 1000).toString().split(".")[0] +
          "." +
          (number / 1000).toString().split(".")[1][0] +
          "k";
    } else {
      return (number / 1000000).toStringAsFixed(1) + "M";
    }
  }

  Widget createDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Alerta",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
          "¿Estas seguro que quires dejar de seguir a ${widget.user.userName}?"),
      actions: [
        CupertinoDialogAction(
          child: Text("Cancelar"),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text("Dejar de seguir"),
          onPressed: () {
            Navigator.pop(context);
            follow(widget.user.userName);
            setState(() {
              followed = !followed;
              numberOfFollowers -= 1;
            });
          },
          isDestructiveAction: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print(widget.user.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        margin: EdgeInsets.only(bottom: 10),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  ApiConstants.baseUrl +
                      "/user/userImg/${widget.user.userName}",
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 160,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${widget.user.userName.length >= 10 ? widget.user.userName.substring(0, 8) + "..." : widget.user.userName}",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            widget.user.verified
                                ? Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                  )
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "${widget.user.fullName}",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.groups_2),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${_convertNumber(numberOfFollowers)}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Row(
                              children: [
                                Icon(Icons.photo_library),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${widget.user.countOfPosts}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (!followed) {
                    follow(widget.user.userName);
                    setState(() {
                      followed = !followed;
                      numberOfFollowers += 1;
                    });
                  } else {
                    showCupertinoDialog(
                      context: context,
                      builder: createDialog,
                      barrierDismissible: true,
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.zero,
                  width: 75,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: followed
                        ? Colors.white
                        : Color.fromRGBO(173, 29, 254, 1),
                    border: Border.all(
                      color: Color.fromRGBO(173, 29, 254, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(75)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        followed
                            ? Icons.person_remove
                            : Icons.person_add_alt_sharp,
                        color: !followed
                            ? Colors.white
                            : Color.fromRGBO(173, 29, 254, 1),
                        size: 25,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future follow(String userName) async {
    widget.context
        .read<SearchBloc>()
        .add(SearchFollowEvent(userName: userName));
  }
}

class EventCard extends StatelessWidget {
  final GetEventDto event;
  const EventCard({super.key, required this.event});

  Widget createDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Popularidad",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
          "La popularidad de un evento se calcula a partir de todas las personas de la ciudad que han ido a éste."),
      actions: [
        CupertinoDialogAction(
          child: Text("Aceptar"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print(event.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        margin: EdgeInsets.only(bottom: 10),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  ApiConstants.baseUrl + "/event/${event.id}/img",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: 170,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          event.name.length >= 12
                              ? event.name.substring(0, 8).toUpperCase()
                              : event.name.toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  color: Colors.black,
                                  Icons.location_on_sharp,
                                ),
                                Text(
                                  event.city,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onLongPress: () => showCupertinoDialog(
                              context: context,
                              builder: createDialog,
                              barrierDismissible: true,
                            ),
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    color: Colors.black,
                                    Icons.groups_2_sharp,
                                  ),
                                  Text(
                                    " ${event.popularity.toString()}%",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  MapUtils.openMap(event.location.split("/")[0],
                      event.location.split("/")[1]);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 75,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(173, 29, 254, 1),
                    border: Border.all(
                      color: Color.fromRGBO(173, 29, 254, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(75)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        color: Colors.white,
                        Icons.map_sharp,
                        size: 25,
                      ),
                      Text(
                        " Ir",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(String lat, String lng) async {
    Uri url =
        Uri.parse('https://www.google.com/maps/search/?api=1?query=$lat,$lng');
    Uri urlApple = Uri.parse('https://maps.apple.com/?q=$lat,$lng');

    // ignore: deprecated_member_use
    if (await canLaunch(url.toString()) && Platform.isAndroid) {
      // ignore: deprecated_member_use
      await launch(url.toString());
    } else if (Platform.isIOS) {
      await LaunchApp.openApp(
        iosUrlScheme: '${urlApple}',
        openStore: true,
      );
    }
  }
}
