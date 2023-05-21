import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/blocs/forgot_password/forgot_password_change_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/main.dart';
import 'package:pdam_app/services/authentication_service.dart';
import 'package:pdam_app/widgets/Loading.dart';

class ChangeForgotPasswordPage extends StatelessWidget {
  final String userName;
  const ChangeForgotPasswordPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    JwtAuthenticationService userService = getIt<JwtAuthenticationService>();
    return BlocProvider(
        create: (context) => ForgotPassworChangeBloc(userService, userName),
        child: Builder(
          builder: (context) {
            final formBloc = context.read<ForgotPassworChangeBloc>();
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
                child:
                    FormBlocListener<ForgotPassworChangeBloc, String, String>(
                        onSuccess: (context, state) {
                          LoadingDialog.hide(context);
                          showOk(context);
                          Future.delayed(Duration(microseconds: 3000)).then(
                            (value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyApp(),
                              ),
                            ),
                          );
                        },
                        onLoading: (context, state) {
                          const CircularProgressIndicator();
                        },
                        onSubmitting: (context, state) {
                          LoadingDialog.show(context);
                        },
                        onFailure: (context, state) {
                          showError(context);
                        },
                        child: ChangeForgotPasswordPageSF(formBloc: formBloc)),
              ),
            );
          },
        ));
  }
}

class ChangeForgotPasswordPageSF extends StatefulWidget {
  final ForgotPassworChangeBloc formBloc;
  const ChangeForgotPasswordPageSF({super.key, required this.formBloc});

  @override
  State<ChangeForgotPasswordPageSF> createState() =>
      ChangeForgotPasswordPageSFState();
}

class ChangeForgotPasswordPageSFState
    extends State<ChangeForgotPasswordPageSF> {
  ChangeForgotPasswordPageSFState();

  late bool enable = false;

  _check() {
    setState(() {
      enable = widget.formBloc.newPassword.value.isNotEmpty &&
          widget.formBloc.newPasswordVerify.value.isNotEmpty;
    });
  }

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
                    "Nueva contraseña",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Elige una contraseña segura (Mayusculas, minuscula, números y signos de puntuación)",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldBlocBuilder(
                    textFieldBloc: widget.formBloc.newPassword,
                    onChanged: (value) {
                      _check();
                    },
                    suffixButton: SuffixButton.obscureText,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(217, 217, 217, 1)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'Contraseña nueva',
                      labelStyle: TextStyle(fontSize: 20),
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      filled: true,
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(173, 29, 254, 1), width: 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldBlocBuilder(
                    textFieldBloc: widget.formBloc.newPasswordVerify,
                    onChanged: (value) {
                      _check();
                    },
                    suffixButton: SuffixButton.obscureText,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(217, 217, 217, 1)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'Repite la contraseña nueva',
                      labelStyle: TextStyle(fontSize: 20),
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      filled: true,
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            color: Color.fromRGBO(173, 29, 254, 1), width: 1),
                      ),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: Text('Continuar',
                          style: TextStyle(color: Colors.white, fontSize: 40)),
                      onPressed: enable
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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showOk(
    BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
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
                  "¡Todo bien!",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Tu contraseña se ha actualizado con éxito",
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
