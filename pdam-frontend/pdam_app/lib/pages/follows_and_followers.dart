import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/services/user_service.dart';
import 'package:pdam_app/widgets/EmptyListMessage.dart';
import 'package:pdam_app/widgets/FollowsAndFollowers.dart';
import 'package:shimmer/shimmer.dart';

import '../blocs/follow_followers/follows_followers_bloc_bloc.dart';

class FollowsAndFollowersPage extends StatelessWidget {
  final String id;
  const FollowsAndFollowersPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    UserService _userService = getIt<UserService>();
    return BlocProvider(
      create: (context) => FollowsFollowersBloc(_userService, id)
        ..add(FollowsFollowersInitialEvent()),
      child: FollowsAndFollowersPageSF(),
    );
  }
}

class FollowsAndFollowersPageSF extends StatefulWidget {
  const FollowsAndFollowersPageSF({super.key});

  @override
  State<FollowsAndFollowersPageSF> createState() =>
      _FollowsAndFollowersPageSFState();
}

class _FollowsAndFollowersPageSFState extends State<FollowsAndFollowersPageSF> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowsFollowersBloc, FollowsFollowersState>(
      builder: (context, state) {
        if (state is FollowsFollowersSuccess) {
          return FollowsAndFollowersList(state: state);
        } else if (state is FollowsFollowersFailure) {
          return Text("Toda mal");
        } else {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white, size: 45),
          );
        }
      },
    );
  }
}

class FollowsAndFollowersList extends StatefulWidget {
  final FollowsFollowersSuccess state;

  const FollowsAndFollowersList({super.key, required this.state});

  @override
  State<FollowsAndFollowersList> createState() =>
      _FollowsAndFollowersListState();
}

class _FollowsAndFollowersListState extends State<FollowsAndFollowersList>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _scrollControllerF = ScrollController();
  late bool showArrow = false;
  late bool showArrowF = false;
  late int currentTab = 0;

  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollControllerF.addListener(_onScrollF);
    _tabController.addListener(_onTabChanged);
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
        appBar: AppBar(
          leadingWidth: 0,
          backgroundColor: Colors.white,
          title: DefaultTabController(
            length: 2,
            child: TabBar(
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 5,
              labelColor: Color.fromRGBO(173, 29, 254, 1),
              unselectedLabelColor: Colors.black,
              labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  child: GestureDetector(
                    onTap: () {
                      _tabController.animateTo(0);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Siguiendo"),
                        showArrowF && currentTab == 0
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
                      _tabController.animateTo(1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Seguidores"),
                        showArrow && currentTab == 1
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
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            widget.state.follows.isNotEmpty
                ? ListView.builder(
                    itemCount: widget.state.follows.length,
                    itemBuilder: (context, index) {
                      return FollowsAndFollowers(
                        user: widget.state.follows[index],
                      );
                    },
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      child: EmptyListMessage(
                          message: "No hay ninguna persona en esta página..."),
                    ),
                  ),
            widget.state.followers.isNotEmpty
                ? ListView.builder(
                    itemCount: widget.state.followers.length,
                    itemBuilder: (context, index) {
                      return FollowsAndFollowers(
                        user: widget.state.followers[index],
                      );
                    },
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      child: EmptyListMessage(
                          message: "No hay ninguna persona en esta página..."),
                    ),
                  ),
          ],
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

    _scrollControllerF
      ..removeListener(_onScrollF)
      ..dispose();
  }

  void _onTabChanged() {
    setState(() {
      currentTab = _tabController.index;
    });
  }

  void _onScroll() {
    if (_isBottom) {
      context
          .read<FollowsFollowersBloc>()
          .add(FollowsFollowersScrollFollowsEvent());
    }
  }

  void _onScrollF() {
    if (_isBottomF) {
      context
          .read<FollowsFollowersBloc>()
          .add(FollowsFollowersScrollFollowersEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 500);
  }

  bool get _isBottomF {
    if (!_scrollControllerF.hasClients) return false;
    final maxScroll = _scrollControllerF.position.maxScrollExtent;
    final currentScroll = _scrollControllerF.offset;
    return currentScroll >= (maxScroll - 500);
  }
}
