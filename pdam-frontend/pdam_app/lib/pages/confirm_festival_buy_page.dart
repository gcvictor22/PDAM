import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/blocs/confirm_buy/confirm_party_buy_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/services/event_service.dart';
import 'package:pdam_app/widgets/Loading.dart';

class ConfirmFestivalBuyPage extends StatelessWidget {
  final String stripeId;
  const ConfirmFestivalBuyPage({super.key, required this.stripeId});

  @override
  Widget build(BuildContext context) {
    EventService _eventService = getIt<EventService>();
    return BlocProvider(
      create: (context) => ConfirmBuyBloc(_eventService, stripeId),
      child: ConfirmFestivalBuyPageSF(),
    );
  }
}

class ConfirmFestivalBuyPageSF extends StatefulWidget {
  const ConfirmFestivalBuyPageSF({super.key});

  @override
  State<ConfirmFestivalBuyPageSF> createState() =>
      _ConfirmFestivalBuyPageSFState();
}

class _ConfirmFestivalBuyPageSFState extends State<ConfirmFestivalBuyPageSF> {
  @override
  Widget build(BuildContext context) {
    final formBloc = context.read<ConfirmBuyBloc>();
    return FormBlocListener<ConfirmBuyBloc, String, String>(
      onSuccess: (context, state) {
        LoadingDialog.show(context);
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      onSubmitting: (context, state) {
        LoadingDialog.show(context);
      },
      child: ConfirmFestivalBuyWidget(
        formBloc: formBloc,
      ),
    );
  }
}

class ConfirmFestivalBuyWidget extends StatefulWidget {
  final ConfirmBuyBloc formBloc;
  const ConfirmFestivalBuyWidget({super.key, required this.formBloc});

  @override
  State<ConfirmFestivalBuyWidget> createState() =>
      _ConfirmFestivalBuyWidgetState();
}

class _ConfirmFestivalBuyWidgetState extends State<ConfirmFestivalBuyWidget> {
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
          "Confirma el pago",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(173, 29, 254, 1), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 150),
              child: Text(
                "El pago se creado pero todavía no se te va a cobrar nada.\n\n\t· En el caso que confirmes el pago, se creará una solicitud de pago a tu entidad bancaria. A parte, te mandaremos un correo con un pdf adjunto con la entrada y tus datos.\n\n\t· Por otra parte, si lo cancelas, no se te hará ningún cargo.\n\nPodrás repetir este proceso cuantas veces quieras.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(40, 20, 40, 30),
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
                child: Text('Confirmar compra',
                    style: TextStyle(color: Colors.white, fontSize: 25)),
                onPressed: () {
                  widget.formBloc.confirmFestivalBuy();
                },
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(40, 10, 40, 30),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red.shade900),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Text('Cancelar compra',
                    style: TextStyle(color: Colors.white, fontSize: 25)),
                onPressed: () {
                  widget.formBloc.cancelFestivalBuy();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
