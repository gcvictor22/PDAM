import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../config/locator.dart';
import '../services/services.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login-background.png'),
              fit: BoxFit.cover)),
      child: SafeArea(
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
                    Text(msg),
                    TextButton(
                      //textColor: Theme.of(context).primaryColor,
                      child: Text('Retry'),
                      onPressed: () {
                        authBloc.add(AppLoaded());
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
    ));
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
          return Form(
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
                            cursorColor: Color.fromRGBO(173, 29, 254, 1),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelText: 'Nombre de usuario',
                                labelStyle: TextStyle(fontSize: 20),
                                fillColor:
                                    const Color.fromRGBO(217, 217, 217, 1),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 15, 10, 15),
                                filled: true,
                                isDense: true,
                                floatingLabelStyle: TextStyle(
                                    color: Color.fromRGBO(173, 29, 254, 1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide.none)),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null) {
                                return 'Email is required.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            cursorColor: Color.fromRGBO(173, 29, 254, 1),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelText: 'Contraseña',
                                labelStyle: TextStyle(fontSize: 20),
                                fillColor:
                                    const Color.fromRGBO(217, 217, 217, 1),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 15, 10, 15),
                                filled: true,
                                isDense: true,
                                floatingLabelStyle: TextStyle(
                                    color: Color.fromRGBO(173, 29, 254, 1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide.none)),
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
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                                  onPressed: () => print("Bien por ahora"),
                                  child: Text(
                                    "Registrate",
                                    style: TextStyle(
                                        fontSize: 17,
                                        decoration: TextDecoration.underline,
                                        color: Color.fromRGBO(173, 29, 254, 1)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          TextButton(
                              onPressed: () => print("Bien por ahora"),
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
              ));
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
