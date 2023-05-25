import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pdam_app/blocs/parties/parties_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/services/event_service.dart';
import 'package:pdam_app/widgets/EmptyListMessage.dart';
import 'package:pdam_app/widgets/Party.dart';
import 'package:shimmer/shimmer.dart';

class PartiesPage extends StatelessWidget {
  final int id;
  final String name;
  const PartiesPage({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    EventService _eventService = getIt<EventService>();
    return BlocProvider(
      create: (context) =>
          PartiesBloc(_eventService, id)..add(PartiesInitialEvent()),
      child: PartiesPageSF(name: name),
    );
  }
}

class PartiesPageSF extends StatefulWidget {
  final String name;
  const PartiesPageSF({super.key, required this.name});

  @override
  State<PartiesPageSF> createState() => _PartiesPageSFState();
}

class _PartiesPageSFState extends State<PartiesPageSF> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartiesBloc, PartiesState>(
      builder: (context, state) {
        if (state is PartiesSuccess) {
          return PartiesPageList(
            state: state,
            name: widget.name,
          );
        } else if (state is PartiesFailure) {
          return Center(
            child: Text(state.error),
          );
        } else {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white, size: 40),
          );
        }
      },
    );
  }
}

class PartiesPageList extends StatefulWidget {
  final PartiesSuccess state;
  final String name;
  const PartiesPageList({super.key, required this.state, required this.name});

  @override
  State<PartiesPageList> createState() => _PartiesPageListState();
}

class _PartiesPageListState extends State<PartiesPageList> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/main-background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Fiestas en:",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                width: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.apartment,
                    color: Colors.black,
                    size: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: widget.state.parties.isNotEmpty
            ? ListView.builder(
                controller: _scrollController,
                itemCount: widget.state.parties.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Party(party: widget.state.parties[index]),
                      index == widget.state.parties.length - 1 &&
                              widget.state.parties.length != 1
                          ? SizedBox(
                              height: 90,
                            )
                          : SizedBox(),
                    ],
                  );
                },
              )
            : Container(
                margin: EdgeInsets.fromLTRB(20, 250, 20, 0),
                child: EmptyListMessage(
                    message: "No hay ninguna fiesta en esta discoteca..."),
              ),
        bottomNavigationBar: BlurryContainer(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 34),
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.zero,
          elevation: 6,
          blur: 8,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                Navigator.pop(context);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () => Navigator.pop(context),
                ),
                Shimmer.fromColors(
                  period: Duration(milliseconds: 3000),
                  baseColor: Colors.black,
                  highlightColor: Colors.white.withOpacity(0.85),
                  child: Text(
                    "Desliza o pulsa la flecha para volver",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PartiesBloc>().add(PartiesScrollEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 500);
  }

  Future loadList() async {
    await Future.delayed(Duration(milliseconds: 1750));
    await context.read<PartiesBloc>()
      ..add(PartiesInitialEvent());
  }
}
