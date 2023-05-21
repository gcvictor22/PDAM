import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/blocs/edit_profile/edit_email_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/pages/register_verification_form_page.dart';
import 'package:pdam_app/services/user_service.dart';
import 'package:pdam_app/widgets/Loading.dart';

class EditEmailPage extends StatelessWidget {
  final String userName;
  const EditEmailPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    UserService userService = getIt<UserService>();
    return BlocProvider(
        create: (context) => EditEmailBloc(userService),
        child: Builder(
          builder: (context) {
            final formBloc = context.read<EditEmailBloc>();
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text('Ajustes',
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
                child: FormBlocListener<EditEmailBloc, String, String>(
                    onSuccess: (context, state) {
                      LoadingDialog.hide(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return RegisterVerfificarionPage(userName);
                          },
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
                    child: _EditEmailPageSF(formBloc: formBloc)),
              ),
            );
          },
        ));
  }
}

class _EditEmailPageSF extends StatefulWidget {
  final EditEmailBloc formBloc;
  const _EditEmailPageSF({super.key, required this.formBloc});

  @override
  State<_EditEmailPageSF> createState() => _EditEmailPageSFState();
}

class _EditEmailPageSFState extends State<_EditEmailPageSF> {
  _EditEmailPageSFState();

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
                    "Editar email",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Cuando pulses el botón continuar, te enviaremos un email con un código de verificación. La cuenta se quedará inhabilitada hasta que verifiques en el siguiente paso el nuevo email con el código de verificación.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldBlocBuilder(
                    textFieldBloc: widget.formBloc.email,
                    onChanged: (value) => setState(() {}),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(217, 217, 217, 1)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelText: 'Email',
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
                          widget.formBloc.email.value.length > 0
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
                      onPressed: widget.formBloc.email.value.length > 0
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
