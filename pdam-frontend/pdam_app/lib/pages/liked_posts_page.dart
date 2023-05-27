import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pdam_app/blocs/liked_posts/liked_posts_bloc.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/services/post_service.dart';
import 'package:pdam_app/services/user_service.dart';
import 'package:pdam_app/widgets/EmptyListMessage.dart';
import 'package:pdam_app/widgets/Post.dart';

class LikedPostsPage extends StatelessWidget {
  final String id;
  const LikedPostsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final _userService = getIt<UserService>();
    final _postService = getIt<PostService>();
    return BlocProvider(
      create: (context) => LikedPostsBloc(_userService, _postService, id)
        ..add(LikedPostsInitialEvent()),
      child: LikedPostsPageSF(),
    );
  }
}

class LikedPostsPageSF extends StatefulWidget {
  const LikedPostsPageSF({super.key});

  @override
  State<LikedPostsPageSF> createState() => _LikedPostsPageSFState();
}

class _LikedPostsPageSFState extends State<LikedPostsPageSF> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LikedPostsBloc, LikedPostsState>(
      builder: (context, state) {
        if (state is LikedPostsSuccess) {
          return LikedPostsList(
            state: state,
          );
        } else if (state is LikedPostsFailure) {
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

class LikedPostsList extends StatefulWidget {
  final LikedPostsSuccess state;
  const LikedPostsList({super.key, required this.state});

  @override
  State<LikedPostsList> createState() => _LikedPostsListState();
}

class _LikedPostsListState extends State<LikedPostsList> {
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
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Favoritos",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: widget.state.likedPosts.isNotEmpty
            ? ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                itemCount: widget.state.likedPosts.length,
                itemBuilder: (context, index) {
                  return Post(
                    post: widget.state.likedPosts[index],
                    context: context,
                    num: 4,
                  );
                },
              )
            : Container(
                margin: EdgeInsets.fromLTRB(40, 250, 40, 0),
                child: EmptyListMessage(message: "Aquí no hay ningún post..."),
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
      context.read<LikedPostsBloc>().add(LikedPostsScrollEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 500);
  }
}
