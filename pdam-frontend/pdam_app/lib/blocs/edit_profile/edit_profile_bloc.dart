import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/services/user_service.dart';

class EditProfileFormBloc extends FormBloc<String, String> {
  final String phoneNumberInitialValue;
  final String userNameInitialValue;
  final String fullNameInitialValue;
  final String emailInitialValue;
  final UserService _userService;

  final fullName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final userName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final phoneNumber = TextFieldBloc(validators: [FieldBlocValidators.required]);

  EditProfileFormBloc({
    required this.phoneNumberInitialValue,
    required this.userNameInitialValue,
    required this.fullNameInitialValue,
    required this.emailInitialValue,
    required UserService userService,
    // ignore: unnecessary_null_comparison
  })  : assert(userService != null),
        _userService = userService {
    fullName.updateValue(fullNameInitialValue);
    userName.updateValue(userNameInitialValue);
    phoneNumber.updateValue(phoneNumberInitialValue);
    addFieldBlocs(fieldBlocs: [
      fullName,
      userName,
      phoneNumber,
    ]);
  }

  Future<dynamic> _updateFullName(String fullName) async {
    return await _userService.updateFullName(fullName);
  }

  Future<dynamic> _updateUserName(String userName) async {
    return await _userService.updateUserName(userName);
  }

  Future<dynamic> _updatePhoneNumber(String phoneNumber) async {
    return await _userService.updatePhoneNumber(phoneNumber);
  }

  @override
  FutureOr<void> onSubmitting() {
    // TODO: implement onSubmitting
    throw UnimplementedError();
  }
}
