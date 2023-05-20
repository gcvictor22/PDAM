import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/services/user_service.dart';

class ForgotPasswordBloc extends FormBloc<String, String> {
  final UserService _userService;

  final userName = TextFieldBloc(validators: [FieldBlocValidators.required]);

  ForgotPasswordBloc(UserService userService)
      // ignore: unnecessary_null_comparison
      : assert(userService != null),
        _userService = userService {
    addFieldBlocs(fieldBlocs: [
      userName,
    ]);
  }

  Future<dynamic> _forgotPassword() async {
    return await _userService.forgotPassword(userName.value);
  }

  @override
  FutureOr<void> onSubmitting() {
    _forgotPassword().then((value) {
      emitSuccess();
    }).catchError((onError) {
      emitFailure();
      print(onError);
    });
  }
}
