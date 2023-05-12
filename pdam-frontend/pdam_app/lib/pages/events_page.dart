import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pdam_app/blocs/events/events_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/services/event_service.dart';
import 'package:pdam_app/widgets/Discotheque.dart';

import '../widgets/BottomLoader.dart';
import '../widgets/EmptyListMessage.dart';
import '../widgets/RefreshWidget.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final eventService = getIt<EventService>();
        return EventsBloc(eventService)..add(EventsInitialEvent());
      },
      child: EventsPageSF(),
    );
  }
}

class EventsPageSF extends StatefulWidget {
  const EventsPageSF({super.key});

  @override
  State<EventsPageSF> createState() => _EventsPageSFState();
}

class _EventsPageSFState extends State<EventsPageSF> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        if (state is EventsSuccess) {
          return EventsList(state: state);
        } else if (state is EventsFailure) {
          return Center(
            child: Text("Ha ocurrido un error a la hora de cargar los eventos"),
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

class EventsList extends StatefulWidget {
  final EventsSuccess state;

  const EventsList({super.key, required this.state});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList>
    with SingleTickerProviderStateMixin {
  final _scrollControllerD = ScrollController();
  final _scrollControllerF = ScrollController();
  final _scrollControllerA = ScrollController();
  late bool showArrowD = false;
  late bool showArrowF = false;
  late bool showArrowA = false;
  late int currentTab = 0;

  late TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    _scrollControllerD.addListener(_onScrollD);
    _scrollControllerF.addListener(_onScrollF);
    _scrollControllerA.addListener(_onScrollA);
    _tabController.addListener(_onTabChanged);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 99, 99, 99),
                ),
              ),
            ),
            padding: EdgeInsets.only(top: 50, bottom: 8),
            child: TabBar(
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 5,
              labelColor: Color.fromRGBO(173, 29, 254, 1),
              unselectedLabelColor: Colors.black,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  child: GestureDetector(
                    onTap: () {
                      if (currentTab == 0 &&
                          widget.state.discotheques is! String &&
                          _scrollControllerD.offset >= 750 &&
                          _scrollControllerD.hasClients) {
                        scrollToTopTab1();
                      } else {
                        _tabController.animateTo(0);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(showArrowD && currentTab == 0
                            ? "Disco..."
                            : "Discotecas"),
                        showArrowD && currentTab == 0
                            ? Icon(Icons.arrow_upward)
                            : SizedBox(
                                height: 0,
                                width: 0,
                              ),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: GestureDetector(
                    onTap: () {
                      if (currentTab == 1 &&
                          widget.state.festivals is! String &&
                          _scrollControllerF.offset >= 750 &&
                          _scrollControllerF.hasClients) {
                        scrollToTopTab2();
                      } else {
                        _tabController.animateTo(1);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(showArrowF && currentTab == 1
                            ? "Festi..."
                            : "Festivales"),
                        showArrowF && currentTab == 1
                            ? Icon(Icons.arrow_upward)
                            : SizedBox(
                                height: 0,
                                width: 0,
                              ),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: GestureDetector(
                    onTap: () {
                      if (currentTab == 2 &&
                          widget.state.festivals is! String &&
                          _scrollControllerA.offset >= 750 &&
                          _scrollControllerA.hasClients) {
                        scrollToTopTab3();
                      } else {
                        _tabController.animateTo(2);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Todo"),
                        showArrowA && currentTab == 2
                            ? Icon(Icons.arrow_upward)
                            : SizedBox(
                                height: 0,
                                width: 0,
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                widget.state.discotheques is! String
                    ? SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: RefreshWidget(
                            onRefresh: () => loadlistF(),
                            scrollController: _scrollControllerD,
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: widget.state.discotheques.length,
                              padding: EdgeInsets.only(top: 20),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    index >= widget.state.discotheques.length
                                        ? const BottomLoader()
                                        : Event(
                                            event: widget
                                                .state.discotheques[index]),
                                    index ==
                                            widget.state.discotheques.length - 1
                                        ? SizedBox(
                                            height: 210,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            top: 200, bottom: 350, left: 40, right: 40),
                        child: EmptyListMessage(
                          message: widget.state.discotheques is String
                              ? widget.state.discotheques
                              : "",
                        ),
                      ),
                widget.state.festivals is! String
                    ? SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: RefreshWidget(
                            onRefresh: () => loadlistF(),
                            scrollController: _scrollControllerF,
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: widget.state.festivals.length,
                              padding: EdgeInsets.only(top: 20),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    index >= widget.state.festivals.length
                                        ? const BottomLoader()
                                        : Event(
                                            event:
                                                widget.state.festivals[index]),
                                    index == widget.state.festivals.length - 1
                                        ? SizedBox(
                                            height: 210,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            top: 200, bottom: 350, left: 40, right: 40),
                        child: EmptyListMessage(
                          message: widget.state.festivals is String
                              ? widget.state.discotheques
                              : "",
                        ),
                      ),
                widget.state.events is! String
                    ? SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: RefreshWidget(
                            onRefresh: () => loadlistF(),
                            scrollController: _scrollControllerA,
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: widget.state.events.length,
                              padding: EdgeInsets.only(top: 20),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    index >= widget.state.events.length
                                        ? const BottomLoader()
                                        : Event(
                                            event: widget.state.events[index]),
                                    index == widget.state.events.length - 1
                                        ? SizedBox(
                                            height: 210,
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            top: 200, bottom: 350, left: 40, right: 40),
                        child: EmptyListMessage(
                          message: widget.state.events is String
                              ? widget.state.discotheques
                              : "",
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollControllerD
      ..removeListener(_onScrollD)
      ..dispose();

    _scrollControllerF
      ..removeListener(_onScrollF)
      ..dispose();

    _scrollControllerA
      ..removeListener(_onScrollA)
      ..dispose();
  }

  void _onTabChanged() {
    setState(() {
      currentTab = _tabController.index;
    });
  }

  void _onScrollD() {
    if (_isTopD) {
      setState(() {
        showArrowD = true;
      });
    } else {
      setState(() {
        showArrowD = false;
      });
    }
    if (_isBottomD) {
      context.read<EventsBloc>().add(ScrollDiscothequesEvent());
    }
  }

  void _onScrollF() {
    if (_isTopF) {
      setState(() {
        showArrowF = true;
      });
    } else {
      setState(() {
        showArrowF = false;
      });
    }
    if (_isBottomF) {
      context.read<EventsBloc>().add(ScrollFestivalEvent());
    }
  }

  void _onScrollA() {
    if (_isTopA) {
      setState(() {
        showArrowA = true;
      });
    } else {
      setState(() {
        showArrowA = false;
      });
    }
    if (_isBottomA) {
      context.read<EventsBloc>().add(ScrollEventsEvent());
    }
  }

  bool get _isBottomD {
    if (!_scrollControllerD.hasClients) return false;
    final maxScroll = _scrollControllerD.position.maxScrollExtent;
    final currentScroll = _scrollControllerD.offset;
    return currentScroll >= (maxScroll - 500);
  }

  bool get _isTopD {
    if (!_scrollControllerD.hasClients) return false;
    final currentScroll = _scrollControllerD.offset;
    return currentScroll >= 750;
  }

  bool get _isBottomF {
    if (!_scrollControllerF.hasClients) return false;
    final maxScroll = _scrollControllerF.position.maxScrollExtent;
    final currentScroll = _scrollControllerF.offset;
    return currentScroll >= (maxScroll - 500);
  }

  bool get _isTopF {
    if (!_scrollControllerF.hasClients) return false;
    final currentScroll = _scrollControllerF.offset;
    return currentScroll >= 750;
  }

  bool get _isBottomA {
    if (!_scrollControllerA.hasClients) return false;
    final maxScroll = _scrollControllerA.position.maxScrollExtent;
    final currentScroll = _scrollControllerA.offset;
    return currentScroll >= (maxScroll - 500);
  }

  bool get _isTopA {
    if (!_scrollControllerA.hasClients) return false;
    final currentScroll = _scrollControllerA.offset;
    return currentScroll >= 750;
  }

  Future loadlistD() async {
    await Future.delayed(Duration(milliseconds: 1750));
    context.read<EventsBloc>().add(RefreshDiscothequesEvent());
  }

  void scrollToTopTab1() {
    _scrollControllerD.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Future loadlistF() async {
    await Future.delayed(Duration(milliseconds: 1750));
    context.read<EventsBloc>().add(RefreshFestivalsEvent());
  }

  void scrollToTopTab2() {
    _scrollControllerF.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Future loadlistA() async {
    await Future.delayed(Duration(milliseconds: 1750));
    context.read<EventsBloc>().add(RefreshEventsEvent());
  }

  void scrollToTopTab3() {
    _scrollControllerA.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
