import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/config/locator.dart';

import '../../services/authentication_service.dart';

class RegisterVerificationFormBloc extends FormBloc<String, String> {
  final userName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final verificationToken = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      (value) {
        if (value.isNotEmpty) {
          if (value.length == 6) {
            return null;
          }
        }
        return 'Validation Token must have 6 digits';
      }
    ],
  );

  RegisterVerificationFormBloc() {
    addFieldBlocs(fieldBlocs: [userName, verificationToken]);
  }

  @override
  FutureOr<void> onSubmitting() {
    final _authService = getIt<JwtAuthenticationService>();
    emitLoading();
    _authService
        .verifyToken(userName.value, verificationToken.value)
        .then((value) => {emitSuccess()})
        .catchError((error) => {print(error), emitFailure()});
  }
}
