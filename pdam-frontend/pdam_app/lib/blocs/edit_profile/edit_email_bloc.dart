import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/services/user_service.dart';

class EditEmailBloc extends FormBloc<String, String> {
  final UserService _userService;

  final email = TextFieldBloc(
      validators: [FieldBlocValidators.required, FieldBlocValidators.email]);

  EditEmailBloc(UserService userService)
      // ignore: unnecessary_null_comparison
      : assert(userService != null),
        _userService = userService {
    addFieldBlocs(fieldBlocs: [email]);
  }

  Future<dynamic> _updateEmail() async {
    return await _userService.updateEmail(email.value);
  }

  @override
  FutureOr<void> onSubmitting() {
    _updateEmail().then((value) {
      emitSuccess();
    }).catchError((er) {
      emitFailure();
    });
  }
}
