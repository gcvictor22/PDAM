import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/blocs/register_form/regirter_verification_form_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../widgets/Messages.dart';

class RegisterVerfificarionPage extends StatelessWidget {
  final String userName;
  const RegisterVerfificarionPage(this.userName, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterVerificationFormBloc(),
        child: Builder(
          builder: (context) {
            final formBloc = context.read<RegisterVerificationFormBloc>();
            return Scaffold(
              appBar: AppBar(
                leading: Icon(Icons.do_disturb, color: Colors.white),
                title: Text('Registro',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                backgroundColor: Colors.white,
                centerTitle: true,
              ),
              body: SafeArea(
                top: false,
                minimum: EdgeInsets.only(left: 30, right: 30),
                child: FormBlocListener<RegisterVerificationFormBloc, String,
                        String>(
                    onSuccess: (context, state) {
                      showOk(context,
                          "Te has registrado correctamente, ya puedes iniciar sesión");

                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    onLoading: (context, state) {
                      const CircularProgressIndicator();
                    },
                    onSubmitting: (context, state) {},
                    onFailure: (context, state) {
                      showError(context,
                          "Ha ocurrido un error a la hora de verificar tu email");
                    },
                    child: _RegisterVerificationPageSF(
                        formBloc: formBloc, userName: userName)),
              ),
            );
          },
        ));
  }
}

class _RegisterVerificationPageSF extends StatefulWidget {
  final RegisterVerificationFormBloc formBloc;
  final String userName;
  const _RegisterVerificationPageSF(
      {super.key, required this.formBloc, required this.userName});

  @override
  State<_RegisterVerificationPageSF> createState() =>
      _RegisterVerificationPageSFState(formBloc, userName);
}

class _RegisterVerificationPageSFState
    extends State<_RegisterVerificationPageSF> {
  final RegisterVerificationFormBloc formBloc;
  final String userName;

  _RegisterVerificationPageSFState(this.formBloc, this.userName);

  @override
  void initState() {
    super.initState();
    formBloc.userName.updateValue(userName);
  }

  late bool enable = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      height: 700,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(30),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(173, 29, 254, 1)),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                Text(
                  "Verifica tu email",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Te hemos enviado a tu email un código de verificación. Introducelo a continuación:",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                PinCodeTextField(
                  keyboardType: TextInputType.number,
                  onCompleted: (value) {
                    setState(() {
                      enable = true;
                    });
                  },
                  pinTheme: PinTheme(
                      activeColor: Colors.black,
                      selectedColor: Color.fromRGBO(173, 29, 254, 1),
                      inactiveColor: Colors.black),
                  autoFocus: true,
                  appContext: context,
                  length: 6,
                  onChanged: (value) => setState(
                    () {
                      formBloc.verificationToken.updateValue(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        enable
                            ? Color.fromRGBO(173, 29, 254, 1)
                            : Color.fromRGBO(214, 143, 255, 1),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(10)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: Text('Terminar',
                        style: TextStyle(color: Colors.white, fontSize: 40)),
                    onPressed: enable
                        ? () {
                            formBloc.submit();
                          }
                        : null,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
