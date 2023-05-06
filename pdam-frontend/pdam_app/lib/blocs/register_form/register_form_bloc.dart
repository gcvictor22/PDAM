import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/services/services.dart';

class RegisterFormBloc extends FormBloc<String, String> {
  final fullName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final genderId = InputFieldBloc<int, Object>(
      initialValue: 63, validators: [FieldBlocValidators.required]);
  final userName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final password = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final verifyPassword =
      TextFieldBloc(validators: [FieldBlocValidators.required]);
  final email = TextFieldBloc(
      validators: [FieldBlocValidators.email, FieldBlocValidators.required]);
  final phoneNumber = TextFieldBloc(validators: [
    FieldBlocValidators.required,
    (value) {
      if (value.isNotEmpty) {
        if (value.length == 9) {
          return null;
        }
      }
      return 'Phone number must be 9 digits';
    }
  ]);
  final cityId = InputFieldBloc<int, Object>(
      initialValue: 1, validators: [FieldBlocValidators.required]);

  RegisterFormBloc() {
    addFieldBlocs(fieldBlocs: [
      fullName,
      genderId,
      userName,
      password,
      verifyPassword,
      email,
      phoneNumber,
      cityId
    ]);
  }

  @override
  FutureOr<void> onSubmitting() {
    late JwtAuthenticationService authService = JwtAuthenticationService();
    emitLoading();
    authService
        .register(
            userName.value,
            password.value,
            verifyPassword.value,
            email.value,
            phoneNumber.value,
            fullName.value,
            cityId.value,
            genderId.value)
        .then((value) => {
              Future.delayed(
                Duration(seconds: 1),
              ).then(
                (value) => emitSuccess(),
              ),
            })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => {emitFailure()});
  }
}
