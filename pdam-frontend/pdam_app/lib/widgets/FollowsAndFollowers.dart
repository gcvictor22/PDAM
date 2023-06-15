import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdam_app/blocs/follow_followers/follows_followers_bloc_bloc.dart';
import 'package:pdam_app/models/user/GetProfile.dart';
import 'package:pdam_app/pages/user_details_page.dart';
import 'package:pdam_app/rest/rest_client.dart';

class FollowsAndFollowers extends StatefulWidget {
  final UserWhoPost user;
  const FollowsAndFollowers({super.key, required this.user});

  @override
  State<FollowsAndFollowers> createState() => _FollowsAndFollowersState();
}

class _FollowsAndFollowersState extends State<FollowsAndFollowers> {
  late bool followed = widget.user.followedByUser!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserDetailsPage(userName: widget.user.userName!),
          )),
      child: Container(
        margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Color.fromRGBO(173, 29, 254, 1))),
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
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
                    ApiConstants.baseUrl + "/post/file/${widget.user.imgPath}",
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  widget.user.userName!.length > 7
                      ? widget.user.userName!.substring(0, 5) + "..."
                      : widget.user.userName!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                widget.user.verified!
                    ? Icon(
                        Icons.verified,
                        color: Colors.blue,
                      )
                    : SizedBox(),
              ],
            ),
            !widget.user.loggedUser!
                ? GestureDetector(
                    onTap: () {
                      if (!followed) {
                        follow(widget.user.userName!);
                        setState(() {
                          followed = !followed;
                        });
                      } else {
                        showCupertinoDialog(
                          context: context,
                          builder: createDialog,
                          barrierDismissible: true,
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.zero,
                      width: 75,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: followed
                            ? Colors.white
                            : Color.fromRGBO(173, 29, 254, 1),
                        border: Border.all(
                          color: Color.fromRGBO(173, 29, 254, 1),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(75)),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            followed
                                ? Icons.person_remove
                                : Icons.person_add_alt_sharp,
                            color: !followed
                                ? Colors.white
                                : Color.fromRGBO(173, 29, 254, 1),
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Future follow(String userName) async {
    context
        .read<FollowsFollowersBloc>()
        .add(FollowsFollowersFollowEvent(userName: userName));
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
          "¿Estas seguro que quires dejar de seguir a ${widget.user.userName}?"),
      actions: [
        CupertinoDialogAction(
          child: Text("Cancelar"),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text("Dejar de seguir"),
          onPressed: () {
            Navigator.pop(context);
            follow(widget.user.userName!);
            setState(() {
              followed = !followed;
            });
          },
          isDestructiveAction: true,
        ),
      ],
    );
  }
}
