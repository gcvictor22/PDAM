import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/services/authentication_service.dart';

class ForgotPassworChangeBloc extends FormBloc<String, String> {
  final JwtAuthenticationService _userService;
  final String userName;

  final newPassword = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final newPasswordVerify =
      TextFieldBloc(validators: [FieldBlocValidators.required]);

  ForgotPassworChangeBloc(JwtAuthenticationService userService, this.userName)
      // ignore: unnecessary_null_comparison
      : assert(userService != null),
        _userService = userService {
    newPasswordVerify.addAsyncValidators([
      (value) {
        if (value != newPassword.value) {
          return Future(() => "Las contraseñas no coinciden");
        }
        return Future(() => null);
      }
    ]);
    addFieldBlocs(fieldBlocs: [newPassword, newPasswordVerify]);
  }

  Future<dynamic> _changePassword() async {
    return await _userService.forgotPasswordChange(
        userName, newPassword.value, newPasswordVerify.value);
  }

  @override
  FutureOr<void> onSubmitting() {
    _changePassword().then((value) {
      emitSuccess();
    }).catchError((onError) {
      emitFailure();
    });
  }
}
