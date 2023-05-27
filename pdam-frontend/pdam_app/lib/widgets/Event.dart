import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdam_app/models/event/GetEventDtoReponse.dart';
import 'package:pdam_app/pages/buy_festival_page.dart';
import 'package:pdam_app/pages/parties_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../rest/rest_client.dart';

class Event extends StatelessWidget {
  final GetEventDto event;
  final int type;
  const Event({super.key, required this.event, required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (type == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PartiesPage(id: event.id, name: event.name),
            ),
          );
        } else if (type == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BuyFestivalPage(id: event.id),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15, top: 0),
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
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    event.name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  event.type != null
                      ? Text(
                          " · ",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        )
                      : SizedBox(),
                  event.type != null
                      ? event.type! == "[DISCOTHEQUE]"
                          ? Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromRGBO(173, 29, 254, 1),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Text("Discoteca"),
                            )
                          : Container(
                              child: Text(
                                "Festival",
                                style: TextStyle(color: Colors.white),
                              ),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(173, 29, 254, 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                            )
                      : SizedBox()
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Image.network(
                fit: BoxFit.cover,
                ApiConstants.baseUrl + "/event/${event.id}/img",
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                GestureDetector(
                  onLongPress: () => showCupertinoDialog(
                    context: context,
                    builder: createDialog,
                    barrierDismissible: true,
                  ),
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
                GestureDetector(
                  onTap: () {
                    MapUtils.openMap(event.location.split("/")[0],
                        event.location.split("/")[1]);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        color: Colors.black,
                        Icons.map_sharp,
                      ),
                      Text(
                        " Ir",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

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
