import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pdam_app/blocs/festival/festival_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/pages/payment_methods.dart';
import 'package:pdam_app/services/event_service.dart';

import '../rest/rest_client.dart';
import '../widgets/SpaceLine.dart';

class BuyFestivalPage extends StatelessWidget {
  final int id;
  const BuyFestivalPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    EventService _eventService = getIt<EventService>();
    return BlocProvider(
      create: (context) =>
          FestivalBloc(_eventService, id)..add(FestivalInitialEvent()),
      child: BuyFestivalPageSF(),
    );
  }
}

class BuyFestivalPageSF extends StatefulWidget {
  const BuyFestivalPageSF({super.key});

  @override
  State<BuyFestivalPageSF> createState() => _BuyFestivalPageSFState();
}

class _BuyFestivalPageSFState extends State<BuyFestivalPageSF> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FestivalBloc, FestivalState>(
      builder: (context, state) {
        if (state is FestivalSuccess) {
          return BuyFestivalPageDetails(state: state);
        } else if (state is FestivalFailure) {
          return Center(child: Text(state.error));
        } else {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white, size: 45),
          );
        }
      },
    );
  }
}

class BuyFestivalPageDetails extends StatefulWidget {
  final FestivalSuccess state;
  const BuyFestivalPageDetails({super.key, required this.state});

  @override
  State<BuyFestivalPageDetails> createState() => _BuyFestivalPageDetailsState();
}

class _BuyFestivalPageDetailsState extends State<BuyFestivalPageDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Comprar entrada",
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
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
                  widget.state.festival.name!,
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
                  child: Image.network(ApiConstants.baseUrl +
                      "/post/file/${widget.state.festival.imgPath}"),
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
                        "${widget.state.festival.price}€",
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
                        "Consumición incluida: ${widget.state.festival.drinkIncluded! ? "Si" : "No"}",
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: widget.state.festival.drinkIncluded! ? 10 : 0,
                ),
                widget.state.festival.drinkIncluded!
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              widget.state.festival.drinkIncluded!
                                  ? "Cantidad de consumiciones: ${widget.state.festival.numberOfDrinks!}"
                                  : "",
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        ],
                      )
                    : SizedBox(),
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
                        "Mayoría de edad requerida: ${widget.state.festival.adult! ? "Si" : "No"}",
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
                        "Inicio: ${widget.state.festival.date!}",
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
                        "Duración: ${widget.state.festival.duration!} días",
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
                  context
                      .read<FestivalBloc>()
                      .add(FestivalBuyEvent(context: context));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
