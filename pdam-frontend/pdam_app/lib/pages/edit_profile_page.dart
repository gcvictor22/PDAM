import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdam_app/blocs/authentication/authentication_bloc.dart';
import 'package:pdam_app/blocs/authentication/authentication_event.dart';
import 'package:pdam_app/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:pdam_app/blocs/profile/profile_bloc.dart';
import 'package:pdam_app/main.dart';
import 'package:pdam_app/services/user_service.dart';
import 'package:pdam_app/widgets/SpaceLine.dart';

import '../config/locator.dart';
import '../rest/rest_client.dart';
import '../widgets/Loading.dart';

class SettingsPage extends StatelessWidget {
  final String fullName;
  final String userName;
  final String phoneNumber;
  final String email;
  final String imgPath;
  final BuildContext contextSuper;
  const SettingsPage(
      {super.key,
      required this.fullName,
      required this.userName,
      required this.phoneNumber,
      required this.email,
      required this.contextSuper,
      required this.imgPath});

  @override
  Widget build(BuildContext context) {
    final userService = getIt<UserService>();
    return BlocProvider(
      create: (context) => EditProfileFormBloc(
        fullNameInitialValue: fullName,
        userNameInitialValue: userName,
        phoneNumberInitialValue: phoneNumber,
        emailInitialValue: email,
        userService: userService,
      ),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<EditProfileFormBloc>();
          return Scaffold(
            appBar: AppBar(
              title: Text('Ajustes',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: Colors.black,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: FormBlocListener<EditProfileFormBloc, String, String>(
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);
                  contextSuper.read<ProfileBloc>().add(ProfileInitialEvent());
                  Navigator.pop(context);
                },
                onLoading: (context, state) {
                  const CircularProgressIndicator();
                },
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSubmissionFailed: (context, state) {
                  LoadingDialog.hide(context);
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);
                  showError(context);
                },
                child: SettingsPageSF(
                  formBloc: formBloc,
                  userName: userName,
                  imgPath: imgPath,
                )),
          );
        },
      ),
    );
  }
}

class SettingsPageSF extends StatefulWidget {
  final EditProfileFormBloc formBloc;
  final String userName;
  final String imgPath;
  const SettingsPageSF(
      {super.key,
      required this.formBloc,
      required this.userName,
      required this.imgPath});

  @override
  State<SettingsPageSF> createState() => _SettingsPageSFState();
}

class _SettingsPageSFState extends State<SettingsPageSF> {
  final ImagePicker imagePicker = ImagePicker();
  bool enable = false;
  late Image image;
  bool newImage = false;

  _onValueChange() {
    setState(() {
      enable = widget.formBloc.fullName.value !=
              widget.formBloc.fullNameInitialValue ||
          widget.formBloc.userName.value !=
              widget.formBloc.userNameInitialValue ||
          widget.formBloc.phoneNumber.value !=
              widget.formBloc.phoneNumberInitialValue ||
          newImage;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    image = Image.network(
      ApiConstants.baseUrl + "/post/file/${widget.imgPath}",
      fit: BoxFit.cover,
    );
  }

  Future getPhoto() async {
    if (widget.formBloc.profileImg.isNotEmpty) {
      widget.formBloc.profileImg.clear();
    }
    XFile? _newImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (_newImage != null) {
      image = Image.file(
        File(_newImage.path),
        fit: BoxFit.cover,
      );
      setState(() {
        newImage = true;
      });
      widget.formBloc.profileImg.add(_newImage);
    }
    _onValueChange();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 125,
                  height: 125,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: image,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Abrir galaría "),
                        Icon(
                          Icons.image,
                          size: 20,
                        )
                      ],
                    ),
                    onPressed: () => getPhoto(),
                  ),
                  newImage ? Text("|") : SizedBox(),
                  newImage
                      ? CupertinoButton(
                          child: Text(
                            "Restablecer",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            image = Image.network(
                              ApiConstants.baseUrl +
                                  "/user/userImg/${widget.userName}",
                              fit: BoxFit.cover,
                            );
                            newImage = false;
                            _onValueChange();
                          })
                      : SizedBox()
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Column(
                  children: [
                    TextFieldBlocBuilder(
                      textFieldBloc: widget.formBloc.fullName,
                      onChanged: (value) => _onValueChange(),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(217, 217, 217, 1)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: 'Nombre completo',
                          labelStyle: TextStyle(fontSize: 20),
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          filled: true,
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(173, 29, 254, 1),
                                  width: 1))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: widget.formBloc.userName,
                      onChanged: (value) => _onValueChange(),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(217, 217, 217, 1)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: 'Nombre de usuario',
                          labelStyle: TextStyle(fontSize: 20),
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          filled: true,
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(173, 29, 254, 1),
                                  width: 1))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: widget.formBloc.phoneNumber,
                      onChanged: (value) => _onValueChange(),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(217, 217, 217, 1)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelText: 'Número de teléfono',
                        labelStyle: TextStyle(fontSize: 20),
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        filled: true,
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(173, 29, 254, 1),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      enable
                          ? Color.fromRGBO(173, 29, 254, 1)
                          : Color.fromRGBO(173, 29, 254, 1).withOpacity(0.35),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(10)),
                    splashFactory: NoSplash.splashFactory,
                    elevation: enable
                        ? MaterialStatePropertyAll(10)
                        : MaterialStatePropertyAll(0),
                    overlayColor: enable
                        ? MaterialStatePropertyAll(
                            Colors.white.withOpacity(0.35))
                        : MaterialStatePropertyAll(Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text('Guardar',
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                  onPressed: () {
                    if (enable) {
                      widget.formBloc.submit();
                    }
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SpaceLine(color: Colors.grey),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cambiar email",
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              SpaceLine(color: Colors.grey),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cambiar contraseña",
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              SpaceLine(color: Colors.grey),
              SizedBox(
                height: 40,
              ),
              SpaceLine(color: Colors.red.shade900),
              GestureDetector(
                onTap: () => showCupertinoDialog(
                  context: context,
                  builder: createDialog,
                  barrierDismissible: true,
                ),
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cerrar sesión",
                        style:
                            TextStyle(fontSize: 20, color: Colors.red.shade900),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.red.shade900)
                    ],
                  ),
                ),
              ),
              SpaceLine(color: Colors.red.shade900),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
    BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      content: Container(
        padding: const EdgeInsets.all(8),
        height: 80,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
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
                    "Error",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    "Comprueba que todos los campos están rellenos con el formato esperado",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget createDialog(BuildContext context) {
  final authBloc = BlocProvider.of<AuthenticationBloc>(context);
  return CupertinoAlertDialog(
    title: Text(
      "Alerta",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Text("¿Estás seguro que quieres cerrar sesión?"),
    actions: [
      CupertinoDialogAction(
        child: Text("Cancelar"),
        onPressed: () => Navigator.pop(context),
      ),
      CupertinoDialogAction(
        child: Text("Cerrar sesión"),
        onPressed: () {
          authBloc.add(UserLoggedOut());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return MyApp();
              },
            ),
          );
        },
        isDestructiveAction: true,
      ),
    ],
  );
}
