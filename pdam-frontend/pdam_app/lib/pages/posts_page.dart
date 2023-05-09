import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pdam_app/blocs/posts/posts_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/services/post_service.dart';
import 'package:pdam_app/widgets/EmptyListMessage.dart';
import 'package:pdam_app/widgets/RefreshWidget.dart';

import '../widgets/BottomLoader.dart';
import '../widgets/Post.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final postService = getIt<PostService>();
        return PostsBloc(postService)..add(PostsInitialEvent());
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
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is PostsSucces) {
          return PostsList(
            state: state,
          );
        } else if (state is PostsFailure) {
          return Center(
            child: Text("Ha ocurrido un error a la hora de cargar los posts"),
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

class PostsList extends StatefulWidget {
  final PostsSucces state;
  const PostsList({super.key, required this.state});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList>
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
    return DefaultTabController(
      length: 2,
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
              labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  child: GestureDetector(
                    onTap: () {
                      if (currentTab == 0 &&
                          widget.state.followedPosts is! String &&
                          _scrollControllerF.offset >= 750) {
                        scrollToTopTab2();
                      } else {
                        _tabController.animateTo(0);
                      }
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
                      if (currentTab == 1 &&
                          widget.state.posts is! String &&
                          _scrollController.offset >= 750) {
                        scrollToTopTab1();
                      } else {
                        _tabController.animateTo(1);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Todos"),
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                widget.state.followedPosts is! String
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
                              itemCount: widget.state.followedPosts.length,
                              padding: EdgeInsets.only(top: 20),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    index >= widget.state.followedPosts.length
                                        ? const BottomLoader()
                                        : Post(
                                            post: widget
                                                .state.followedPosts[index],
                                            context: context,
                                          ),
                                    index ==
                                            widget.state.followedPosts.length -
                                                1
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
                          message: widget.state.followedPosts is String
                              ? widget.state.followedPosts
                              : "",
                        ),
                      ),
                widget.state.posts is! String
                    ? SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: RefreshWidget(
                            onRefresh: () => loadlist(),
                            scrollController: _scrollController,
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: widget.state.posts.length,
                              padding: EdgeInsets.only(top: 20),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    index >= widget.state.posts.length
                                        ? const BottomLoader()
                                        : Post(
                                            post: widget.state.posts[index],
                                            context: context,
                                          ),
                                    index == widget.state.posts.length - 1
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
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.state.posts is String
                                  ? widget.state.posts
                                  : "",
                            ),
                            ElevatedButton(
                              onPressed: () => loadlist(),
                              child: Text("Recargar"),
                            )
                          ],
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
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    _scrollControllerF
      ..removeListener(_onScrollF)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      currentTab = _tabController.index;
    });
  }

  void _onScroll() {
    if (_isTop) {
      setState(() {
        showArrow = true;
      });
    } else {
      setState(() {
        showArrow = false;
      });
    }
    if (_isBottom) {
      context.read<PostsBloc>().add(PostsScrollEvent());
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
      context.read<PostsBloc>().add(FollowedPostsScrollEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 500);
  }

  bool get _isTop {
    if (!_scrollController.hasClients) return false;
    final currentScroll = _scrollController.offset;
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

  Future loadlist() async {
    await Future.delayed(Duration(milliseconds: 1750));
    context.read<PostsBloc>().add(PostsRefreshEvent());
  }

  void scrollToTopTab1() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Future loadlistF() async {
    await Future.delayed(Duration(milliseconds: 1750));
    context.read<PostsBloc>().add(FollowedPostsRefreshEvent());
  }

  void scrollToTopTab2() {
    _scrollControllerF.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
