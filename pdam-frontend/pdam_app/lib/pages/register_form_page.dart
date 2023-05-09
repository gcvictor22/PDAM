import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/blocs/register_form/register_form_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/pages/register_verification_form_page.dart';
import 'package:pdam_app/services/authentication_service.dart';
import 'package:pdam_app/services/city_services.dart';

import '../models/models.dart';
import '../widgets/Loading.dart';

class RegisterFormPage extends StatelessWidget {
  const RegisterFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cityService = getIt<CityService>();
    final authenticationService = getIt<JwtAuthenticationService>();
    return BlocProvider(
      create: (context) => RegisterFormBloc(cityService, authenticationService),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<RegisterFormBloc>();
          return Scaffold(
            appBar: AppBar(
              title: Text('Registro',
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
            body: SafeArea(
              top: false,
              minimum: EdgeInsets.only(left: 30, right: 30),
              child: FormBlocListener<RegisterFormBloc, String, String>(
                  onSuccess: (context, state) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return RegisterVerfificarionPage(
                              formBloc.userName.value);
                        },
                      ),
                    );
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
                  child: RegisterFormPageSF(formBloc: formBloc)),
            ),
          );
        },
      ),
    );
  }
}

class RegisterFormPageSF extends StatefulWidget {
  final RegisterFormBloc formBloc;

  const RegisterFormPageSF({super.key, required this.formBloc});

  @override
  State<RegisterFormPageSF> createState() => _RegisterFormPageSFState(formBloc);
}

class _RegisterFormPageSFState extends State<RegisterFormPageSF> {
  final RegisterFormBloc formBloc;

  _RegisterFormPageSFState(this.formBloc);

  List<Gender> genders = [];
  late GetCityDto _selectedCity;
  late List<GetCityDto> cities = [GetCityDto(id: 1, name: "A coruña")];

  @override
  void initState() {
    _selectedCity = cities[0];
    formBloc.findAllCities().then((value) => cities = value);
    super.initState();
    genders.add(
        new Gender(id: 63, name: 'Hombre', isSelected: true, icon: Icons.male));
    genders.add(new Gender(
        id: 64, name: 'Mujer', isSelected: false, icon: Icons.female));
    genders.add(new Gender(
        id: 65, name: 'Otro', isSelected: false, icon: Icons.transgender));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.fullName,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(217, 217, 217, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelText: 'Nombre completo',
                labelStyle: TextStyle(fontSize: 20),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                filled: true,
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(173, 29, 254, 1), width: 1))),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                  color: genders[0].isSelected
                      ? Color.fromRGBO(173, 29, 254, 1)
                      : Colors.white,
                  child: InkWell(
                    child: Container(
                        height: 80,
                        width: 80,
                        alignment: Alignment.center,
                        margin: new EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              genders[0].icon,
                              color: genders[0].isSelected
                                  ? Colors.white
                                  : Color.fromRGBO(173, 29, 254, 1),
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              genders[0].name,
                              style: TextStyle(
                                  color: genders[0].isSelected
                                      ? Colors.white
                                      : Color.fromRGBO(173, 29, 254, 1)),
                            )
                          ],
                        )),
                    onTap: () {
                      setState(() {
                        genders.forEach((gender) => gender.isSelected = false);
                        genders[0].isSelected = true;
                        formBloc.genderId.updateValue(genders[0].id);
                      });
                    },
                  )),
              Card(
                  color: genders[1].isSelected
                      ? Color.fromRGBO(173, 29, 254, 1)
                      : Colors.white,
                  child: InkWell(
                    child: Container(
                        height: 80,
                        width: 80,
                        alignment: Alignment.center,
                        margin: new EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              genders[1].icon,
                              color: genders[1].isSelected
                                  ? Colors.white
                                  : Color.fromRGBO(173, 29, 254, 1),
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              genders[1].name,
                              style: TextStyle(
                                  color: genders[1].isSelected
                                      ? Colors.white
                                      : Color.fromRGBO(173, 29, 254, 1)),
                            )
                          ],
                        )),
                    onTap: () {
                      setState(() {
                        genders.forEach((gender) => gender.isSelected = false);
                        genders[1].isSelected = true;
                        formBloc.genderId.updateValue(genders[1].id);
                      });
                    },
                  )),
              Card(
                  color: genders[2].isSelected
                      ? Color.fromRGBO(173, 29, 254, 1)
                      : Colors.white,
                  child: InkWell(
                    child: Container(
                        height: 80,
                        width: 80,
                        alignment: Alignment.center,
                        margin: new EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              genders[2].icon,
                              color: genders[2].isSelected
                                  ? Colors.white
                                  : Color.fromRGBO(173, 29, 254, 1),
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              genders[2].name,
                              style: TextStyle(
                                  color: genders[2].isSelected
                                      ? Colors.white
                                      : Color.fromRGBO(173, 29, 254, 1)),
                            )
                          ],
                        )),
                    onTap: () {
                      setState(() {
                        genders.forEach((gender) => gender.isSelected = false);
                        genders[2].isSelected = true;
                        formBloc.genderId.updateValue(genders[2].id);
                      });
                    },
                  ))
            ],
          ),
          SizedBox(
            height: 30,
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.userName,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(217, 217, 217, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelText: 'Nombre de usuario',
                labelStyle: TextStyle(fontSize: 20),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                filled: true,
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(173, 29, 254, 1), width: 1))),
          ),
          SizedBox(
            height: 30,
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.password,
            suffixButton: SuffixButton.obscureText,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(217, 217, 217, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelText: 'Contraseña',
                labelStyle: TextStyle(fontSize: 20),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                filled: true,
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(173, 29, 254, 1), width: 1))),
          ),
          SizedBox(
            height: 30,
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.verifyPassword,
            suffixButton: SuffixButton.obscureText,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(217, 217, 217, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelText: 'Repite la contraseña',
                labelStyle: TextStyle(fontSize: 20),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                filled: true,
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(173, 29, 254, 1), width: 1))),
          ),
          SizedBox(
            height: 30,
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(217, 217, 217, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelText: 'Email',
                labelStyle: TextStyle(fontSize: 20),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                filled: true,
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(173, 29, 254, 1), width: 1))),
          ),
          SizedBox(
            height: 30,
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.phoneNumber,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(217, 217, 217, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelText: 'Número de teléfono',
                labelStyle: TextStyle(fontSize: 20),
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                filled: true,
                isDense: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(173, 29, 254, 1), width: 1))),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¿Donde resides?",
                style: TextStyle(fontSize: 20),
              ),
              CupertinoButton(
                child: Text(
                  // ignore: unnecessary_null_comparison
                  _selectedCity != null
                      ? _selectedCity.name.length > 13
                          ? _selectedCity.name.substring(0, 13) + "..."
                          : _selectedCity.name
                      : "",
                  style: TextStyle(
                      fontSize: 20, decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoActionSheet(
                        title: Text('Selecciona la provincia donde resides'),
                        actions: [
                          SizedBox(
                            height: 300,
                            child: CupertinoPicker(
                              magnification: 1.3,
                              itemExtent: 40,
                              useMagnifier: true,
                              scrollController: FixedExtentScrollController(
                                  initialItem: cities.indexOf(_selectedCity)),
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  _selectedCity = cities[index];
                                  formBloc.cityId.updateValue(_selectedCity.id);
                                });
                              },
                              children: cities.map((city) {
                                return Center(
                                  child: Text(
                                    city.name,
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                        cancelButton: CupertinoButton(
                          child: Text(
                            'Cerrar',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          )),
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(173, 29, 254, 1),
                ),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: Text('Continuar',
                  style: TextStyle(color: Colors.white, fontSize: 40)),
              onPressed: () {
                formBloc.submit();
              },
            ),
          )
        ],
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
            ))
          ],
        ),
      ),
    ),
  );
}
