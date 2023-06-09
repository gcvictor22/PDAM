import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/pages/home_page.dart';
import 'package:pdam_app/pages/login_page.dart';
import 'package:pdam_app/services/authentication_service.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';
import 'blocs/authentication/authentication_state.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //await SharedPreferences.getInstance();
  setupAsyncDependencies();
  configureDependencies();
  //await getIt.allReady();

  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      //GlobalContext.ctx = context;
      final authService = getIt<JwtAuthenticationService>();
      return AuthenticationBloc(authService)..add(AppLoaded());
    },
    child: MyApp(),
  ));
}

class GlobalContext {
  static late BuildContext ctx;
}

class MyApp extends StatelessWidget {
  //static late  AuthenticationBloc _authBloc;

  static late MyApp _instance;

  static Route route() {
    print("Enrutando al login");
    return MaterialPageRoute<void>(builder: (context) {
      var authBloc = BlocProvider.of<AuthenticationBloc>(context);
      authBloc..add(SessionExpiredEvent());
      return _instance;
    });
    /*return MaterialPageRoute<void>(builder: (context) {
      return BlocProvider<AuthenticationBloc>(create: (context) {
        final authService = getIt<JwtAuthenticationService>();
        return AuthenticationBloc(authService)..add(SessionExpiredEvent());
      }, 
      child: MyApp(),);
    });*/
  }

  MyApp() {
    _instance = this;
  }

  @override
  Widget build(BuildContext context) {
    //GlobalContext.ctx = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Discotkeo',
      theme: ThemeData(
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.dark,
        ),
        primarySwatch: MaterialColor(0xFFAD1DFE, {
          50: Color.fromRGBO(173, 29, 254, 0.1),
          100: Color.fromRGBO(173, 29, 254, 0.2),
          200: Color.fromRGBO(173, 29, 254, 0.3),
          300: Color.fromRGBO(173, 29, 254, 0.4),
          400: Color.fromRGBO(173, 29, 254, 0.5),
          500: Color.fromRGBO(173, 29, 254, 0.6),
          600: Color.fromRGBO(173, 29, 254, 0.7),
          700: Color.fromRGBO(173, 29, 254, 0.8),
          800: Color.fromRGBO(173, 29, 254, 0.9),
          900: Color.fromRGBO(173, 29, 254, 1),
        }),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          GlobalContext.ctx = context;
          if (state is AuthenticationAuthenticated) {
            // show home page
            return HomePage(
              user: state.user,
            );
          }
          // otherwise show login page
          return LoginPage();
        },
      ),
    );
  }
}
