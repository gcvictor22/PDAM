import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdam_app/blocs/new_post_form/new_post_form_bloc.dart';

import '../config/locator.dart';
import '../services/post_service.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  @override
  Widget build(BuildContext context) {
    final _postService = getIt<PostService>();
    return BlocProvider(
      create: (context) => NewPostFormBloc(_postService),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<NewPostFormBloc>();
          return FormBlocListener<NewPostFormBloc, String, String>(
            onSuccess: (context, state) {
              showOk(context);
              formBloc.clear();
              formBloc.files.clear();
              setState(() {});
            },
            child: NewPostPageSF(formBloc: formBloc),
          );
        },
      ),
    );
  }
}

class NewPostPageSF extends StatefulWidget {
  final NewPostFormBloc formBloc;
  const NewPostPageSF({super.key, required this.formBloc});

  @override
  State<NewPostPageSF> createState() => _NewPostPageSFState();
}

class _NewPostPageSFState extends State<NewPostPageSF> {
  final ImagePicker imagePicker = ImagePicker();

  Future getImage(ImageSource source) async {
    List<XFile> imagesTemporary = await imagePicker.pickMultiImage();

    if (imagesTemporary.isNotEmpty) {
      if (imagesTemporary.length > 4) {
        for (var i = 0; i < 4; i++) {
          widget.formBloc.files.add(imagesTemporary[i]);
        }
      } else {
        widget.formBloc.files = imagesTemporary;
      }
    }

    setState(() {});
  }

  Future getPhoto() async {
    XFile? _newImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (_newImage != null) {
      widget.formBloc.files.add(_newImage);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 90,
            ),
            BlurryContainer(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.white.withOpacity(0.35),
              blur: 8,
              elevation: 6,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      children: [
                        TextFieldBlocBuilder(
                          textFieldBloc: widget.formBloc.affair,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(217, 217, 217, 1),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: '¿Título?',
                            labelStyle: TextStyle(fontSize: 20),
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            filled: true,
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(173, 29, 254, 1),
                                  width: 1),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFieldBlocBuilder(
                          maxLines: null,
                          minLines: 8,
                          maxLength: 250,
                          buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 150,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width:
                                          (currentLength.ceilToDouble() * 200) /
                                              250,
                                      height: 3,
                                      color: Color.fromRGBO(173, 29, 254, 1),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("$currentLength/$maxLength")
                              ],
                            );
                          },
                          textFieldBloc: widget.formBloc.content,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(217, 217, 217, 1),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            labelText: '¿Hoy qué se hace?',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(fontSize: 20),
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            filled: true,
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(173, 29, 254, 1),
                                  width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          child: Row(
                            children: [
                              Text("Abrir galaría "),
                              Icon(
                                Icons.image,
                                size: 20,
                              )
                            ],
                          ),
                          onPressed: () => getImage(ImageSource.gallery),
                        ),
                        CupertinoButton(
                          child: Row(
                            children: [
                              Text("Tomar foto "),
                              Icon(
                                Icons.camera_alt,
                                size: 20,
                              ),
                            ],
                          ),
                          onPressed: () => getPhoto(),
                        ),
                      ],
                    ),
                  ),
                  widget.formBloc.files.length > 0
                      ? SizedBox(
                          height: 20,
                        )
                      : SizedBox(),
                  widget.formBloc.files.length > 0
                      ? Container(
                          height: (9 * 175) / 16,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.formBloc.files.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 170,
                                height: (9 * 170) / 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                        File(widget.formBloc.files[index].path),
                                      )),
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      widget.formBloc.files
                                          .remove(widget.formBloc.files[index]);
                                      setState(() {});
                                    },
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        margin: EdgeInsets.only(
                                          top: 5,
                                          right: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Icon(Icons.close_rounded)),
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                    right: widget.formBloc.files.length - 1 !=
                                            index
                                        ? 10
                                        : 0),
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(173, 29, 254, 1),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(10)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: Text('Postear',
                          style: TextStyle(color: Colors.white, fontSize: 40)),
                      onPressed: () {
                        widget.formBloc.submit();
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showOk(
    BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      content: Container(
        padding: const EdgeInsets.all(8),
        height: 80,
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "¡Todo bien!",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Tu post se ha publicado con exito",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ))
          ],
        ),
      ),
    ),
  );
}
