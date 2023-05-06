import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pdam_app/blocs/posts/posts_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pdam_app/widgets/RefreshWidget.dart';

import '../widgets/BottomLoader.dart';
import '../widgets/Post.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostsBloc(httpClient: http.Client())..add(PostsInitialEvent()),
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
  late bool showArrow = false;
  late int currentTab = 0;

  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
                      if (currentTab == 0) {
                        scrollToTopTab1();
                      } else {
                        _tabController.animateTo(0);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Siguiendo"),
                        showArrow && currentTab == 0
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
                  text: "Todos",
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
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
                                  : Post(widget.state.posts[index]),
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
                ),
                SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          height: 200,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          color: Colors.white,
                          height: 200,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          color: Colors.white,
                          height: 200,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          color: Colors.white,
                          height: 200,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          color: Colors.red,
                          height: 200,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          color: Colors.white,
                          height: 200,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        Container(
                          color: Colors.white,
                          height: 200,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 20),
                        ),
                        SizedBox(
                          height: 90,
                        )
                      ],
                    ),
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
      context.read<PostsBloc>().add(PostsInitialEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  bool get _isTop {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.1);
  }

  Future loadlist() async {
    await Future.delayed(Duration(milliseconds: 1750));
    context.read<PostsBloc>().add(PostsRefreshEvent());
  }

  void scrollToTopTab1() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
