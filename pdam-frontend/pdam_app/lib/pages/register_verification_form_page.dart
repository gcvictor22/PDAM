import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/blocs/register_form/regirter_verification_form_bloc.dart';
import 'package:pdam_app/main.dart';

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
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) {
                          return MyApp();
                        },
                      ));
                    },
                    onLoading: (context, state) {
                      const CircularProgressIndicator();
                    },
                    onSubmitting: (context, state) {
                      const CircularProgressIndicator();
                    },
                    onFailure: (context, state) {
                      showError(context);
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
                TextFieldBlocBuilder(
                  textFieldBloc: formBloc.verificationToken,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(217, 217, 217, 1)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'Token de verificación',
                      labelStyle: TextStyle(fontSize: 20),
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      filled: true,
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(173, 29, 254, 1),
                              width: 1))),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(173, 29, 254, 1)),
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
                    onPressed: () {
                      formBloc.submit();
                    },
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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
    BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      content: Container(
        padding: const EdgeInsets.all(8),
        height: 80,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Error",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Ha ocurrido un error a la hora de verificar el token. Intentelo de nuevo.",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ))
          ],
        ),
      )));
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showOk(
    BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      content: Container(
        padding: const EdgeInsets.all(8),
        height: 80,
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "¡Bienvenido!",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Te has registrado correctamente, ya puedes iniciar sesión",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ))
          ],
        ),
      )));
}
