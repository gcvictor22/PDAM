import 'dart:async';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdam_app/blocs/search/search_bloc.dart';
import 'package:pdam_app/services/event_service.dart';
import 'package:pdam_app/services/user_service.dart';
import 'package:pdam_app/widgets/Search.dart';
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
  const SearchList({
    super.key,
    required this.state,
    required this.text,
  });

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: widget.text.text.length > 0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 40,
                      itemBuilder: (context, index) {
                        var sum = 0;

                        if (widget.state.users is! bool) {
                          sum += widget.state.users.length as int;
                        }
                        if (widget.state.events is! bool) {
                          sum += widget.state.events.length as int;
                        }

                        var end = sum == index - 1;

                        return Column(
                          children: [
                            widget.state.users is! bool
                                ? index < widget.state.users.length
                                    ? UserCard(
                                        user: widget.state.users[index],
                                        context: context,
                                      )
                                    : SizedBox()
                                : SizedBox(),
                            widget.state.events is! bool
                                ? index < widget.state.events.length
                                    ? EventCard(
                                        event: widget.state.events[index])
                                    : SizedBox()
                                : SizedBox(),
                            end == true
                                ? Container(
                                    height: 100,
                                    color: Colors.transparent,
                                    width: double.infinity,
                                  )
                                : SizedBox()
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )
            : widget.text.text.length == 0
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.only(top: 200),
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
                  )
                : SizedBox(),
      ),
    );
  }
}
