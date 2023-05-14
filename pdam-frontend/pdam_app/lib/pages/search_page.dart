import 'dart:async';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdam_app/blocs/search/search_bloc.dart';
import 'package:pdam_app/services/event_service.dart';
import 'package:pdam_app/services/user_service.dart';
import 'package:skeletons/skeletons.dart';

import '../config/locator.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final eventService = getIt<EventService>();
  final userService = getIt<UserService>();
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SearchBloc(_textEditingController, userService, eventService)
          ..add(SearchInitialEvent());
      },
      child: SearchPageSF(
        text: _textEditingController,
      ),
    );
  }
}

class SearchPageSF extends StatefulWidget {
  final TextEditingController text;
  const SearchPageSF({super.key, required this.text});

  @override
  State<SearchPageSF> createState() => _SearchPageSFState();
}

class _SearchPageSFState extends State<SearchPageSF> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.name,
              controller: widget.text,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                suffixStyle: TextField.materialMisspelledTextStyle,
                label: Text("Usuarios, eventos..."),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                filled: true,
                fillColor: FocusScope.of(context).isFirstFocus
                    ? Colors.white
                    : Colors.grey,
                suffixIcon: GestureDetector(
                  onTap: () {
                    widget.text.text = "";
                    search();
                  },
                  child: Icon(
                    color: FocusScope.of(context).isFirstFocus
                        ? Colors.black
                        : Colors.grey[1500],
                    Icons.close,
                  ),
                ),
              ),
              onChanged: (value) => search(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchSuccess) {
                return SearchList(
                  state: state,
                  text: widget.text,
                );
              } else if (state is SearchFailure) {
                return Center(
                  child: Text(
                      "Ha ocurrido un error a la hora de cargar la busqueda"),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return SkeletonListTile();
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future search() async {
    setState(() {});
    context.read<SearchBloc>().add(SearchWriteEvent());
  }
}

class SearchList extends StatefulWidget {
  final SearchSuccess state;
  final TextEditingController text;
  const SearchList({super.key, required this.state, required this.text});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: widget.state.users is! bool && widget.text.text.length > 0
            ? Column(
                // Agrega un widget Column aquí
                children: [
                  Expanded(
                    // Mueve el widget Expanded dentro del Column
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: widget.state.users.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                            bottom:
                                index == widget.state.users.length - 1 ? 0 : 10,
                          ),
                          color: Colors.red,
                          height: 40,
                          width: double.infinity,
                          child: Center(
                            child: Text(widget.state.users[index].userName),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Align(
                alignment: Alignment.topCenter,
                child: BlurryContainer(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Conoce gente o busca eventos aquí",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Image.asset(
                        "assets/search.gif",
                        scale: 5,
                      ),
                    ],
                  ),
                  color: Colors.white.withOpacity(0.35),
                  blur: 8,
                  elevation: 9,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
      ),
    );
  }
}
