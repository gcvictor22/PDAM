import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdam_app/blocs/profile/profile_bloc.dart';
import 'package:pdam_app/pages/edit_profile_page.dart';
import 'package:pdam_app/widgets/Post.dart';

import '../models/post/GetPostDto.dart';
import '../models/user/GetProfile.dart';
import '../rest/rest_client.dart';

class UserProfile extends StatefulWidget {
  final GetProfileDto profile;
  final List<GetPostDto> posts;
  final BuildContext context;
  const UserProfile(
      {super.key,
      required this.profile,
      required this.posts,
      required this.context});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late bool followedByUser;
  late int numberOfFollowers;
  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
    numberOfFollowers = widget.profile.followers!;
    followedByUser = widget.profile.followedByUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 70, 20, 10),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 125,
                height: 125,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  ApiConstants.baseUrl + "/post/file/${widget.profile.imgPath}",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.profile.userName!.length < 15
                            ? widget.profile.userName!
                            : widget.profile.userName!.substring(0, 12) + "...",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      widget.profile.verified!
                          ? Icon(
                              Icons.verified,
                              color: Colors.blue,
                            )
                          : Text(""),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        children: [
                          Text("Seguidores"),
                          Text("${numberOfFollowers}")
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text("Siguiendo"),
                          Text("${widget.profile.follows}")
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text("Posts"),
                          Text(
                              "${widget.profile.publishedPosts!.totalElements}")
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  !widget.profile.loggedUser!
                      ? GestureDetector(
                          onTap: () => setState(() {
                            if (!followedByUser) {
                              follow(widget.profile.userName!);
                              numberOfFollowers += 1;
                              followedByUser = !followedByUser;
                            } else {
                              showCupertinoDialog(
                                context: context,
                                builder: createDialog,
                                barrierDismissible: true,
                              );
                            }
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                              color: followedByUser
                                  ? Colors.white
                                  : Color.fromRGBO(173, 29, 254, 1),
                              border: Border.all(
                                color: Color.fromRGBO(173, 29, 254, 1),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            width: 180,
                            child: Center(
                              child: Text(
                                "${!followedByUser ? "Seguir" : "Siguiendo"}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: !followedByUser
                                      ? Colors.white
                                      : Color.fromRGBO(173, 29, 254, 1),
                                ),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return SettingsPage(
                                  fullName: widget.profile.fullName!,
                                  userName: widget.profile.userName!,
                                  phoneNumber: widget.profile.phoneNumber!,
                                  email: widget.profile.email!,
                                  contextSuper: widget.context,
                                  imgPath: widget.profile.imgPath!,
                                );
                              },
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            width: 180,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "Ajustes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Nombre: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(widget.profile.fullName!),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Usuario desde: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(widget.profile.createdAt!),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey)),
                ),
                padding: EdgeInsets.fromLTRB(30, 5, 5, 5),
                child: Row(
                  children: [
                    Text(
                      "Favoritos",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 17,
                    )
                  ],
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: widget.posts.length,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
            itemBuilder: (context, index) {
              return Post(num: 2, post: widget.posts[index], context: context);
            },
          ),
        )
      ],
    );
  }

  Widget createDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Alerta",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
          "¿Estás seguro que quires dejar de seguir a ${widget.profile.userName}?"),
      actions: [
        CupertinoDialogAction(
          child: Text("Cancelar"),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text("Dejar de seguir"),
          onPressed: () {
            Navigator.pop(context);
            follow(widget.profile.userName!);
            setState(() {
              followedByUser = !followedByUser;
              numberOfFollowers -= 1;
            });
          },
          isDestructiveAction: true,
        ),
      ],
    );
  }

  Future follow(String userName) async {
    widget.context
        .read<ProfileBloc>()
        .add(ProfileFollowEvent(userName: userName));
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProfileBloc>().add(ProfileScrollPostsEvent());
    }
  }

  Future<dynamic> refresh() async {
    context.read<ProfileBloc>().add(ProfileInitialEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 500);
  }
}
