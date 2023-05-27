import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/blocs/new_payment_method/new_payment_method_bloc.dart';
import 'package:pdam_app/blocs/payment_methods/payment_methods_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/services/user_service.dart';
import 'package:pdam_app/widgets/Loading.dart';
import 'package:pdam_app/widgets/Messages.dart';

class NewPaymentMethodPage extends StatelessWidget {
  final BuildContext superContext;
  const NewPaymentMethodPage({super.key, required this.superContext});

  @override
  Widget build(BuildContext context) {
    UserService _userService = getIt<UserService>();
    return BlocProvider(
      create: (context) => NewPaymentMethodBloc(_userService),
      child: NewPaymentMethodSF(superContext: superContext),
    );
  }
}

class NewPaymentMethodSF extends StatefulWidget {
  final BuildContext superContext;
  const NewPaymentMethodSF({super.key, required this.superContext});

  @override
  State<NewPaymentMethodSF> createState() => _NewPaymentMethodSFState();
}

class _NewPaymentMethodSFState extends State<NewPaymentMethodSF> {
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  OutlineInputBorder? focusBorder;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2.0,
      ),
    );
    focusBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(173, 29, 254, 1),
        width: 3.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formBloc = context.read<NewPaymentMethodBloc>();

    void _onValidate() {
      if (formKey.currentState!.validate()) {
        formBloc.submit();
      } else {
        print('invalid!');
      }
    }

    void onCreditCardModelChange(CreditCardModel? creditCardModel) {
      setState(() {
        formBloc.number.updateValue(creditCardModel!.cardNumber);
        formBloc.expiredDate.updateValue(creditCardModel.expiryDate);
        formBloc.holder.updateValue(creditCardModel.cardHolderName);
        formBloc.cvv.updateValue(creditCardModel.cvvCode);
        isCvvFocused = creditCardModel.isCvvFocused;
      });
    }

    return FormBlocListener<NewPaymentMethodBloc, String, String>(
      onSuccess: (context, state) {
        LoadingDialog.hide(context);
        showOk(context, "Método de pago creado con éxito");
        widget.superContext
            .read<PaymentMethodsBloc>()
            .add(PaymentMethodsInitialEvent());
        Navigator.pop(context);
      },
      onSubmitting: (context, state) {
        LoadingDialog.show(context);
      },
      onFailure: (context, state) {
        LoadingDialog.hide(context);
        showError(context,
            "Ha ocurrido un error al intentar registrar el método de pago");
      },
      child: Scaffold(
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
            "Añadir método de pago",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CreditCardWidget(
              cardNumber: formBloc.number.value,
              expiryDate: formBloc.expiredDate.value,
              cardHolderName: formBloc.holder.value,
              cvvCode: formBloc.cvv.value,
              bankName: 'DISCOTKEO',
              frontCardBorder: Border.all(color: Colors.grey),
              backCardBorder: Border.all(color: Colors.grey),
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              backgroundImage: 'assets/main-background.png',
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: formBloc.number.value,
                      cvvCode: formBloc.cvv.value,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: formBloc.holder.value,
                      expiryDate: formBloc.expiredDate.value,
                      themeColor: Color.fromRGBO(173, 29, 254, 1),
                      textColor: Colors.black,
                      cardNumberDecoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Número',
                        hintText: "XXXX XXXX XXXX XXXX",
                        labelStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        filled: true,
                        isDense: true,
                        floatingLabelStyle: TextStyle(
                          color: Color.fromRGBO(173, 29, 254, 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(173, 29, 254, 1),
                            width: 1,
                          ),
                        ),
                      ),
                      expiryDateDecoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Caducidad',
                        hintText: "XX/XX",
                        labelStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        filled: true,
                        isDense: true,
                        floatingLabelStyle: TextStyle(
                          color: Color.fromRGBO(173, 29, 254, 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(173, 29, 254, 1),
                            width: 1,
                          ),
                        ),
                      ),
                      cvvCodeDecoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'CVV',
                        hintText: CardType == CardType.americanExpress
                            ? '0000'
                            : '000',
                        labelStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        filled: true,
                        isDense: true,
                        floatingLabelStyle: TextStyle(
                          color: Color.fromRGBO(173, 29, 254, 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(173, 29, 254, 1),
                            width: 1,
                          ),
                        ),
                      ),
                      cardHolderDecoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(217, 217, 217, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Titular',
                        labelStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        filled: true,
                        isDense: true,
                        floatingLabelStyle: TextStyle(
                          color: Color.fromRGBO(173, 29, 254, 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(173, 29, 254, 1),
                            width: 1,
                          ),
                        ),
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(173, 29, 254, 1),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(10)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: Text('Validar y continuar',
                            style:
                                TextStyle(color: Colors.white, fontSize: 35)),
                        onPressed: () {
                          _onValidate();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppColors {
  AppColors._();

  static const Color cardBgColor = Color(0xff363636);
  static const Color colorB58D67 = Color(0xffB58D67);
  static const Color colorE5D1B2 = Color(0xffE5D1B2);
  static const Color colorF9EED2 = Color(0xffF9EED2);
  static const Color colorFFFFFD = Color(0xffFFFFFD);
}
