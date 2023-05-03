import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdam_app/pages/register_form_page.dart';
import '../blocs/blocs.dart';
import '../config/locator.dart';
import '../services/services.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login-background.png'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            top: false,
            bottom: false,
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                final authBloc = BlocProvider.of<AuthenticationBloc>(context);
                if (state is AuthenticationNotAuthenticated) {
                  return _AuthForm();
                }
                if (state is AuthenticationFailure ||
                    state is SessionExpiredState) {
                  var msg = (state as AuthenticationFailure).message;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        msg,
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        //textColor: Theme.of(context).primaryColor,
                        child: Text('Retry'),
                        onPressed: () {
                          authBloc.add(UserLoggedOut());
                        },
                      )
                    ],
                  );
                }
                // return splash screen
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              },
            )),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authService = getIt<JwtAuthenticationService>();
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      alignment: Alignment.bottomCenter,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed() {
      if (_key.currentState!.validate()) {
        _loginBloc.add(LoginInWithEmailButtonPressed(
            email: _emailController.text, password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Form(
                key: _key,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SafeArea(
                      child: Container(
                        child: Image.asset(
                          'assets/login-logo.png',
                        ),
                        margin: EdgeInsets.only(top: 100),
                        width: double.infinity,
                      ),
                      minimum: EdgeInsets.all(15),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 100),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      padding: EdgeInsets.fromLTRB(50, 50, 50, 30),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                              style: TextStyle(fontSize: 20),
                              cursorColor: Color.fromRGBO(173, 29, 254, 1),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(217, 217, 217, 1)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  labelText: 'Nombre de usuario',
                                  labelStyle: TextStyle(fontSize: 20),
                                  fillColor: Colors.white,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  filled: true,
                                  isDense: true,
                                  floatingLabelStyle: TextStyle(
                                      color: Color.fromRGBO(173, 29, 254, 1)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(173, 29, 254, 1),
                                          width: 1))),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              validator: (value) {
                                if (value == null) {
                                  return 'UserName is required.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              cursorColor: Color.fromRGBO(173, 29, 254, 1),
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(217, 217, 217, 1)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  labelText: 'Contraseña',
                                  labelStyle: TextStyle(fontSize: 20),
                                  fillColor: Colors.white,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  filled: true,
                                  isDense: true,
                                  floatingLabelStyle: TextStyle(
                                      color: Color.fromRGBO(173, 29, 254, 1)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(173, 29, 254, 1),
                                          width: 1))),
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null) {
                                  return 'Password is required.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            //RaisedButton(
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(173, 29, 254, 1)),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(10)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              child: Text('Iniciar sesión',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 40)),
                              onPressed: state is LoginLoading
                                  ? () {}
                                  : _onLoginButtonPressed,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 50,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "¿Eres nuevo? ",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  TextButton(
                                    onPressed: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterFormPage()))
                                    },
                                    child: Text(
                                      "Registrate",
                                      style: TextStyle(
                                          fontSize: 17,
                                          decoration: TextDecoration.underline,
                                          color:
                                              Color.fromRGBO(173, 29, 254, 1)),
                                    ),
                                    style: ButtonStyle(
                                        overlayColor: MaterialStatePropertyAll(
                                            Colors.transparent)),
                                  )
                                ],
                              ),
                            ),
                            TextButton(
                                onPressed: () => print("Bien por ahora"),
                                style: ButtonStyle(
                                    overlayColor: MaterialStatePropertyAll(
                                        Colors.transparent)),
                                child: Text("¿Has olvidado tu contraseña?",
                                    style: TextStyle(
                                        fontSize: 17,
                                        decoration: TextDecoration.underline,
                                        color: Colors.black)))
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

  void _showError(String error) {
    /*Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));*/

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }
}
