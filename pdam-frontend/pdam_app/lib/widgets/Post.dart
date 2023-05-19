import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:pdam_app/blocs/bloc/profile_bloc.dart';
import 'package:pdam_app/rest/rest.dart';

import '../blocs/posts/posts_bloc.dart';
import '../models/post/GetPostDto.dart';

class Post extends StatefulWidget {
  final GetPostDto post;
  final BuildContext context;
  final int num;

  Post(
      {super.key,
      required this.post,
      required this.context,
      required this.num});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15, top: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        border: Border.all(
          color: Color.fromRGBO(173, 29, 254, 1),
        ),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: TextButton(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStatePropertyAll(Colors.transparent),
        ),
        onPressed: () => print(widget.post.id),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => print(widget.post.userWhoPost.userName),
              style: ButtonStyle(
                padding: MaterialStatePropertyAll(
                  EdgeInsets.only(top: 5, bottom: 5),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  Color.fromARGB(255, 233, 233, 233),
                ),
                shadowColor: MaterialStatePropertyAll(
                  Color.fromRGBO(173, 29, 254, 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      ApiConstants.baseUrl +
                          "/user/userImg/${widget.post.userWhoPost.userName}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    widget.post.userWhoPost.userName.length < 15
                        ? widget.post.userWhoPost.userName
                        : widget.post.userWhoPost.userName.substring(0, 12) +
                            "...",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  widget.post.userWhoPost.verified
                      ? Icon(
                          Icons.verified,
                          color: Colors.blue,
                        )
                      : Text(""),
                ],
              ),
            ),
            SizedBox(
              height: widget.post.affair!.isEmpty ? 0 : 20,
            ),
            Container(
              child: Text(
                widget.post.affair != null ? widget.post.affair! : "",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              width: double.infinity,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                widget.post.content,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              width: double.infinity,
            ),
            SizedBox(
              height: 20,
            ),
            widget.post.imgPath.length > 0 && widget.post.imgPath[0] != "VACIO"
                ? widget.post.imgPath.length > 1
                    ? Container(
                        height: (9 * 175) / 16,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.post.imgPath.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 170,
                              height: (9 * 170) / 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(ApiConstants.baseUrl +
                                        "/post/file/${widget.post.imgPath[index]}")),
                              ),
                              margin: EdgeInsets.only(
                                  right: widget.post.imgPath.length - 1 != index
                                      ? 10
                                      : 0),
                              child: widget.post.imgPath.length > 2 &&
                                      index == 1 &&
                                      isScrolled == false
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () =>
                                            _scrollController.animateTo(
                                                _scrollController
                                                    .position.maxScrollExtent,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.easeInOut),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          margin: EdgeInsets.only(
                                            right: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                          child: Icon(Icons.arrow_forward),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 225,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(ApiConstants.baseUrl +
                                "/post/file/${widget.post.imgPath[0]}"),
                          ),
                        ),
                      )
                : SizedBox(),
            SizedBox(
              height: widget.post.imgPath.length > 0 &&
                      widget.post.imgPath[0] != "VACIO"
                  ? 10
                  : 0,
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LikeButton(
                    onTap: (isLiked) {
                      switch (widget.num) {
                        // ignore: constant_pattern_never_matches_value_type
                        case 1:
                          return like(widget.post, isLiked);
                        default:
                          return like2(widget.post, isLiked);
                      }
                    },
                    likeCount: widget.post.usersWhoLiked,
                    isLiked: widget.post.likedByUser,
                    likeBuilder: (isLiked) {
                      var color = isLiked
                          ? const Color.fromARGB(255, 255, 17, 0)
                          : Colors.black;
                      return Icon(
                        Icons.favorite,
                        color: color,
                      );
                    },
                    countBuilder: (likeCount, isLiked, text) {
                      return Text(
                        "${text}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      );
                    },
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.message,
                          size: 25,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.post.comments}",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${widget.post.postDate.split(" ")[0]}\n${widget.post.postDate.split(" ")[1]}",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> like(GetPostDto post, bool bool) async {
    widget.context.read<PostsBloc>().add(LikeAPost(post.id));
    return !bool;
  }

  Future<bool> like2(GetPostDto post, bool bool) async {
    widget.context.read<ProfileBloc>().add(ProfileLikeAPost(id: post.id));
    return !bool;
  }

  bool get isScrolled {
    if (!_scrollController.hasClients) return false;
    final currentScroll = _scrollController.offset;
    return currentScroll >= 1;
  }

  _onScroll() {
    setState(() {});
  }
}
