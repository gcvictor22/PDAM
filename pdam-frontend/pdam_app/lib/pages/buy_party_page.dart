import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/blocs/buy_ticket/buy_party_bloc.dart';
import 'package:pdam_app/pages/confirm_party_buy.dart';
import 'package:pdam_app/pages/payment_methods.dart';
import 'package:pdam_app/rest/rest_client.dart';
import 'package:pdam_app/services/event_service.dart';
import 'package:pdam_app/widgets/Loading.dart';
import 'package:pdam_app/widgets/SpaceLine.dart';

import '../config/locator.dart';
import '../widgets/Messages.dart';

class BuyPartyPage extends StatelessWidget {
  final int id;
  final String name;
  final String imgPath;
  final double price;
  final bool drinkIncluded;
  final int numberOfDrinks;
  final bool adult;
  const BuyPartyPage({
    super.key,
    required this.id,
    required this.name,
    required this.imgPath,
    required this.price,
    required this.drinkIncluded,
    required this.numberOfDrinks,
    required this.adult,
  });

  @override
  Widget build(BuildContext context) {
    EventService _eventService = getIt<EventService>();
    return BlocProvider(
      create: (context) => BuyTicketsBloc(_eventService, id),
      child: BuyPartyPageSF(
        id: id,
        name: name,
        imgPath: imgPath,
        price: price,
        drinkIncluded: drinkIncluded,
        numberOfDrinks: numberOfDrinks,
        adult: adult,
      ),
    );
  }
}

class BuyPartyPageSF extends StatefulWidget {
  final int id;
  final String name;
  final String imgPath;
  final double price;
  final bool drinkIncluded;
  final int numberOfDrinks;
  final bool adult;
  const BuyPartyPageSF({
    super.key,
    required this.id,
    required this.name,
    required this.imgPath,
    required this.price,
    required this.drinkIncluded,
    required this.numberOfDrinks,
    required this.adult,
  });

  @override
  State<BuyPartyPageSF> createState() => _BuyPartyPageSFState();
}

class _BuyPartyPageSFState extends State<BuyPartyPageSF> {
  @override
  Widget build(BuildContext context) {
    final formBloc = context.read<BuyTicketsBloc>();
    return FormBlocListener<BuyTicketsBloc, String, String>(
      onSuccess: (context, state) {
        LoadingDialog.hide(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConfirmPartyBuyPage(stripeId: formBloc.stripeId),
          ),
        );
      },
      onFailure: (context, state) {
        showError(context,
            "Comprueba tus metodos de pago, o que todavía queden entradas disponibles");
      },
      onSubmitting: (context, state) {
        LoadingDialog.show(context);
      },
      child: BuyPartyPageWidget(
          id: widget.id,
          name: widget.name,
          imgPath: widget.imgPath,
          price: widget.price,
          drinkIncluded: widget.drinkIncluded,
          numberOfDrinks: widget.numberOfDrinks,
          adult: widget.adult),
    );
  }
}

class BuyPartyPageWidget extends StatefulWidget {
  final int id;
  final String name;
  final String imgPath;
  final double price;
  final bool drinkIncluded;
  final int numberOfDrinks;
  final bool adult;

  const BuyPartyPageWidget({
    super.key,
    required this.id,
    required this.name,
    required this.imgPath,
    required this.price,
    required this.drinkIncluded,
    required this.numberOfDrinks,
    required this.adult,
  });

  @override
  State<BuyPartyPageWidget> createState() => _BuyPartyPageWidget();
}

class _BuyPartyPageWidget extends State<BuyPartyPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Comprar entrada",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 40,
        ),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  widget.name,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(
                      ApiConstants.baseUrl + "/post/file/${widget.imgPath}"),
                ),
                SizedBox(
                  height: 20,
                ),
                SpaceLine(color: Colors.grey),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Precio de entrada",
                        style: TextStyle(
                          fontSize: 22,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "${widget.price}€",
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Especificaciones de la fiesta",
                        style: TextStyle(
                          fontSize: 22,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Consumición incluida: ${widget.drinkIncluded ? "Si" : "No"}",
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        widget.drinkIncluded
                            ? "Cantidad de consumiciones: ${widget.numberOfDrinks}"
                            : "",
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Mayoría de edad requerida: ${widget.adult ? "Si" : "No"}",
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                SpaceLine(color: Colors.grey),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentMethodsPage(),
                    ),
                  ),
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Métodos de pago",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
                SpaceLine(color: Colors.grey),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(173, 29, 254, 1),
                  ),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Text('Continuar y confirmar pago',
                    style: TextStyle(color: Colors.white, fontSize: 25)),
                onPressed: () {
                  final formBloc = context.read<BuyTicketsBloc>();
                  formBloc.buyParty();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
