import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/pages/change_forgo_password_change.dart';
import 'package:pdam_app/services/user_service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../blocs/register_form/regirter_verification_form_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserService userService = getIt<UserService>();
    return BlocProvider(
        create: (context) => ForgotPasswordBloc(userService),
        child: Builder(
          builder: (context) {
            final formBloc = context.read<ForgotPasswordBloc>();
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text('Contraseña olvidada',
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
                child: FormBlocListener<ForgotPasswordBloc, String, String>(
                    onSuccess: (context, state) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return EditPasswordVerificationPage(
                                formBloc.userName.value);
                          },
                        ),
                      );
                    },
                    onLoading: (context, state) {
                      const CircularProgressIndicator();
                    },
                    onSubmitting: (context, state) {},
                    onFailure: (context, state) {
                      showError(context);
                    },
                    child: _EditPasswordPageSF(formBloc: formBloc)),
              ),
            );
          },
        ));
  }
}

class _EditPasswordPageSF extends StatefulWidget {
  final ForgotPasswordBloc formBloc;
  const _EditPasswordPageSF({super.key, required this.formBloc});

  @override
  State<_EditPasswordPageSF> createState() => _EditPasswordPageSFState();
}

class _EditPasswordPageSFState extends State<_EditPasswordPageSF> {
  _EditPasswordPageSFState();

  @override
  void initState() {
    super.initState();
  }

  late bool enable = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
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
                    "Nombre de usuario",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enviaremos un correo al email asociado al nombre de usuario que escribas con un código para verificar que eres tú.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldBlocBuilder(
                    textFieldBloc: widget.formBloc.userName,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(217, 217, 217, 1)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelText: 'Nombre de usuario',
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
                          widget.formBloc.userName.value.length > 0
                              ? Color.fromRGBO(173, 29, 254, 1)
                              : Color.fromRGBO(214, 143, 255, 1),
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
                      child: Text('Continuar',
                          style: TextStyle(color: Colors.white, fontSize: 40)),
                      onPressed: widget.formBloc.userName.value.length > 0
                          ? () {
                              widget.formBloc.submit();
                            }
                          : null,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
    BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
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
      ),
    ),
  );
}

///////////////////////////////////////////////////////////////////////////////

class EditPasswordVerificationPage extends StatelessWidget {
  final String userName;
  const EditPasswordVerificationPage(this.userName, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterVerificationFormBloc(),
        child: Builder(
          builder: (context) {
            final formBloc = context.read<RegisterVerificationFormBloc>();
            return Scaffold(
              appBar: AppBar(
                title: Text('Recuperar contraseña',
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
                      Future.delayed(Duration(seconds: 3)).then((value) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return ChangeForgotPasswordPage(
                                    userName: userName,
                                  );
                                },
                              ),
                            ),
                          });
                    },
                    onLoading: (context, state) {
                      const CircularProgressIndicator();
                    },
                    onSubmitting: (context, state) {},
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
