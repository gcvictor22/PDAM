import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../models/post/GetPostDto.dart';

Widget Post(GetPostDto post) {
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
    padding: EdgeInsets.all(15),
    child: TextButton(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStatePropertyAll(Colors.transparent),
      ),
      onPressed: () => print(post.id),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => print(post.userWhoPost.userName),
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
                    "http://localhost:8080/user/userImg/${post.userWhoPost.userName}",
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  post.userWhoPost.userName.length < 15
                      ? post.userWhoPost.userName
                      : post.userWhoPost.userName.substring(0, 12) + "...",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  width: 5,
                ),
                post.userWhoPost.verified
                    ? Icon(
                        Icons.verified,
                        color: Colors.blue,
                      )
                    : Text(""),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(
              post.affair,
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
              post.content,
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
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LikeButton(
                  likeCount: post.usersWhoLiked,
                  isLiked: post.likedByUser,
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
                        "${post.comments}",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${post.postDate.split(" ")[0]}\n${post.postDate.split(" ")[1]}",
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
