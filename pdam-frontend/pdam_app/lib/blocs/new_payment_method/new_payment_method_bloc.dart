import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/models/payment_method.dart';
import 'package:pdam_app/services/user_service.dart';

class NewPaymentMethodBloc extends FormBloc<String, String> {
  final UserService _userService;
  final number = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final holder = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final expiredDate = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final cvv = TextFieldBloc(validators: [FieldBlocValidators.required]);

  NewPaymentMethodBloc(UserService userService)
      // ignore: unnecessary_null_comparison
      : assert(userService != null),
        _userService = userService {
    number.addAsyncValidators([
      (value) {
        if (value.length != 16) {
          return Future(
              () => "El número de tarjeta debe tener 16 dígitos numéricos");
        }
        return Future(() => null);
      }
    ]);
    cvv.addAsyncValidators([
      (value) {
        if (value.length != 3) {
          return Future(
              () => "El código de seguridad debe tener 3 dígitos numéricos");
        }
        return Future(() => null);
      }
    ]);
  }

  Future<dynamic> _newPaymentMethod() async {
    return await _userService.newPaymentMethod(NewPaymentMethodDto(
      number: number.value.replaceAll(RegExp(r'\s+'), ''),
      holder: holder.value,
      expiredDate: expiredDate.value,
      cvv: cvv.value,
    ));
  }

  @override
  FutureOr<void> onSubmitting() {
    _newPaymentMethod().then((value) {
      emitSuccess();
    }).catchError((onError) {
      emitFailure();
    });
  }
}
