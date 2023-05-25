import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdam_app/pages/buy_party_page.dart';
import 'package:pdam_app/rest/rest_client.dart';
import 'package:pdam_app/widgets/SpaceLine.dart';

import '../models/event/GetPartiesResponse.dart';

class Party extends StatelessWidget {
  final GetPartyDto party;
  const Party({super.key, required this.party});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BuyPartyPage(
            id: party.id!,
            name: party.name!,
            imgPath: party.imgPath!,
            price: party.price!,
            drinkIncluded: party.drinkIncluded!,
            numberOfDrinks: party.numberOfDrinks!,
            adult: party.adult!,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color.fromRGBO(173, 29, 254, 1)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              party.name!,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              party.description!,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network(
                ApiConstants.baseUrl + "/post/file/${party.imgPath}",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 20,
            ),
            Text("Inicio: ${party.startAt}",
                style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(
              height: 10,
            ),
            Text("Cierre: ${party.endsAt}",
                style: TextStyle(
                    fontSize: 18, color: Color.fromRGBO(173, 29, 254, 1))),
            SizedBox(
              height: 20,
            ),
            SpaceLine(color: Colors.grey),
            SizedBox(
              height: 10,
            ),
            Text(
              "Entradas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Disponibles: ${party.remainingTickets}",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Precio: ${party.price}€",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SpaceLine(color: Colors.grey),
            SizedBox(
              height: 20,
            ),
            party.drinkIncluded!
                ? Text(
                    "Con la compra de la entrada se incluye${party.numberOfDrinks == 1 ? " ${party.numberOfDrinks}" : "n ${party.numberOfDrinks}"} ${party.numberOfDrinks == 1 ? "consumición" : "consumiciones"}",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18),
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            party.adult!
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Entrada restringida a mayores de edad",
                        style:
                            TextStyle(color: Colors.red.shade900, fontSize: 17),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () => showCupertinoDialog(
                          context: context,
                          builder: createDialog,
                          barrierDismissible: true,
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.red.shade900,
                        ),
                      )
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget createDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Información",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
          "Puedes comprar la entrada desde nuestra aplicación pero no podrás entrar a la fiesta"),
      actions: [
        CupertinoDialogAction(
          child: Text("Aceptar"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
