import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdam_app/models/post/NewPostDto.dart';
import 'package:pdam_app/services/post_service.dart';

class NewPostFormBloc extends FormBloc<String, String> {
  final affair = TextFieldBloc();
  final content = TextFieldBloc(validators: [
    FieldBlocValidators.required,
  ]);
  late List<XFile> files = [];

  final PostService _postService;

  NewPostFormBloc(PostService postService)
      // ignore: unnecessary_null_comparison
      : assert(postService != null),
        _postService = postService {
    addFieldBlocs(fieldBlocs: [affair, content]);
  }

  @override
  FutureOr<void> onSubmitting() {
    emitLoading();
    try {
      _postService
          .create(NewPostDto(affair: affair.value, content: content.value))
          .then((value) {
        switch (files.length) {
          case 0:
            emitSuccess();
            break;
          default:
            _postService.uploadFiles(files, value).then((value) {
              emitSuccess();
            });
        }
      });
    } catch (e) {
      throw new Exception("Ha ocurrido un error en el bloc");
    }
  }
}
