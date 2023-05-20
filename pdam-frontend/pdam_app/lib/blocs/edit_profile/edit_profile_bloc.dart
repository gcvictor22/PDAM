import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdam_app/services/user_service.dart';

class EditProfileFormBloc extends FormBloc<String, String> {
  final String phoneNumberInitialValue;
  final String userNameInitialValue;
  final String fullNameInitialValue;
  final String emailInitialValue;
  final UserService _userService;
  late List<XFile> profileImg = [];

  final fullName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final userName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final phoneNumber = TextFieldBloc(validators: [
    FieldBlocValidators.required,
    (value) {
      if (value.isNotEmpty) {
        if (value.length == 9) {
          return null;
        }
      }
      return 'Phone number must have 9 digits';
    }
  ]);

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

  Future<dynamic> _updateProfileImg(XFile file) async {
    return await _userService.updateProfileImg(file);
  }

  Future<void> _updateOnSubmit() async {
    if (fullName.isValueChanged) {
      await _updateFullName(fullName.value);
    }
    if (userName.isValueChanged) {
      await _updateUserName(userName.value);
    }
    if (phoneNumber.isValueChanged) {
      await _updatePhoneNumber(phoneNumber.value);
    }
    if (profileImg.isNotEmpty) {
      if (profileImg[0].name.isNotEmpty) {
        await _updateProfileImg(profileImg[0]);
      }
    }
  }

  @override
  FutureOr<void> onSubmitting() {
    _updateOnSubmit().then((value) {
      emitSuccess();
      // ignore: invalid_return_type_for_catch_error
    }).catchError((er) => print(er));
  }
}
