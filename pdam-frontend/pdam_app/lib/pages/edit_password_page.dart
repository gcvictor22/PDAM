import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/blocs/edit_profile/edit_password_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/services/user_service.dart';

import '../widgets/Messages.dart';

class EditPasswordPage extends StatelessWidget {
  const EditPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserService userService = getIt<UserService>();
    return BlocProvider(
        create: (context) => EditPasswordBloc(userService),
        child: Builder(
          builder: (context) {
            final formBloc = context.read<EditPasswordBloc>();
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
                child: FormBlocListener<EditPasswordBloc, String, String>(
                    onSuccess: (context, state) {
                      showOk(context,
                          "Tu contraseña se ha actualizado correctamente");
                      Navigator.pop(context);
                    },
                    onLoading: (context, state) {
                      const CircularProgressIndicator();
                    },
                    onSubmitting: (context, state) {},
                    onFailure: (context, state) {
                      showError(context,
                          "Ha ocurrido un error a la hora de cambiar la contraseña");
                    },
                    child: _EditPasswoPageSF(formBloc: formBloc)),
              ),
            );
          },
        ));
  }
}

class _EditPasswoPageSF extends StatefulWidget {
  final EditPasswordBloc formBloc;
  const _EditPasswoPageSF({super.key, required this.formBloc});

  @override
  State<_EditPasswoPageSF> createState() => _EditPasswoPageSFState();
}

class _EditPasswoPageSFState extends State<_EditPasswoPageSF> {
  _EditPasswoPageSFState();

  @override
  void initState() {
    super.initState();
  }

  late bool enable = false;

  _check() {
    setState(() {
      enable = widget.formBloc.oldPassword.value.isNotEmpty &&
          widget.formBloc.newPassword.value.isNotEmpty &&
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
                      "Editar contraseña",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                      textFieldBloc: widget.formBloc.oldPassword,
                      onChanged: (value) {
                        _check();
                      },
                      suffixButton: SuffixButton.obscureText,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(217, 217, 217, 1)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelText: 'Contraseña antigua',
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 40)),
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
        ),
      ),
    );
  }
}
