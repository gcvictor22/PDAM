part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class PostsInitialEvent extends PostsEvent {}

class PostsScrollEvent extends PostsEvent {}

class PostsRefreshEvent extends PostsEvent {}

class FollowedPostsScrollEvent extends PostsEvent {}

class FollowedPostsRefreshEvent extends PostsEvent {}

class LikeAPost extends PostsEvent {
  final int postId;

  LikeAPost(this.postId);
}
