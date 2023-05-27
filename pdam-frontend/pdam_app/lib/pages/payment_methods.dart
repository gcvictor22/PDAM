import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/models/payment_method.dart';
import 'package:pdam_app/pages/new_payment_method.dart';
import 'package:pdam_app/services/user_service.dart';

import '../blocs/payment_methods/payment_methods_bloc.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserService _userService = getIt<UserService>();
    return BlocProvider(
      create: (context) =>
          PaymentMethodsBloc(_userService)..add(PaymentMethodsInitialEvent()),
      child: PaymentMethodsSF(),
    );
  }
}

class PaymentMethodsSF extends StatefulWidget {
  const PaymentMethodsSF({super.key});

  @override
  State<PaymentMethodsSF> createState() => _PaymentMethodsSFState();
}

class _PaymentMethodsSFState extends State<PaymentMethodsSF> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodsBloc, PaymentMethodsState>(
      builder: (context, state) {
        if (state is PaymentMethodsSuccess) {
          return PaymentMethodsList(state: state);
        } else if (state is PaymentMethodsFailure) {
          return Center(
            child: Text(state.error),
          );
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

class PaymentMethodsList extends StatefulWidget {
  final PaymentMethodsSuccess state;
  const PaymentMethodsList({super.key, required this.state});

  @override
  State<PaymentMethodsList> createState() => _PaymentMethodsListState();
}

class _PaymentMethodsListState extends State<PaymentMethodsList> {
  late Image image;

  ImageProvider setCardImg(String type) {
    switch (type) {
      case "VISA":
        return AssetImage(
          'assets/visa.png',
        );
      case "MASTERCARD":
        return AssetImage('assets/mastercard.png');
      case "AMERICAN_EXPRESS":
        return AssetImage('assets/american_express.png');
      case "DISCOVER":
        return AssetImage('assets/discover.png');
      default:
        return AssetImage('assets/login-logo.png');
    }
  }

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
          "Métodos de pago",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.state.list.length,
                itemBuilder: (context, index) {
                  return PMCard(
                      p: widget.state.list[index],
                      image: setCardImg(widget.state.list[index].type!));
                },
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
                child: Text('Añadir método de pago',
                    style: TextStyle(color: Colors.white, fontSize: 25)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          NewPaymentMethodPage(superContext: context),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PMCard extends StatelessWidget {
  final GetPaymentMethodDto p;
  final ImageProvider image;
  const PMCard({super.key, required this.p, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!p.active!) {
          context
              .read<PaymentMethodsBloc>()
              .add(PaymentMethodsUptadeEvente(id: p.id!));
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: p.active! ? Color.fromRGBO(173, 29, 254, 1) : Colors.grey,
            width: p.active! ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            opacity: 0.10,
            fit: BoxFit.cover,
            image: image,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  p.number!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  p.holder!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  p.expiredDate!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
