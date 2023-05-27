import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/services/user_service.dart';

class EditPasswordBloc extends FormBloc<String, String> {
  final UserService _userService;

  final oldPassword = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final newPassword = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final newPasswordVerify =
      TextFieldBloc(validators: [FieldBlocValidators.required]);

  Future<dynamic> _updatePassword() async {
    return await _userService.updatePassword(
        oldPassword.value, newPassword.value, newPasswordVerify.value);
  }

  EditPasswordBloc(UserService userService)
      // ignore: unnecessary_null_comparison
      : assert(userService != null),
        _userService = userService {
    newPassword.addAsyncValidators([
      (value) {
        if (value == oldPassword.value) {
          return Future(() => "Esta contraseña ya está en uso");
        }
        return Future(() => null);
      }
    ]);

    newPasswordVerify.addAsyncValidators([
      (value) {
        if (value != newPassword.value) {
          return Future(() => "Las contraseñas no coinciden");
        }
        return Future(() => null);
      }
    ]);

    addFieldBlocs(fieldBlocs: [oldPassword, newPassword, newPasswordVerify]);
  }

  @override
  FutureOr<void> onSubmitting() {
    _updatePassword().then((value) {
      emitSuccess();
    }).catchError((er) {
      emitFailure();
    });
  }
}
