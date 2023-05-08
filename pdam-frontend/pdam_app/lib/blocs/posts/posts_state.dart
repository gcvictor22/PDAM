part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsInitial extends PostsState {}

class PostsSucces extends PostsState {
  final dynamic posts;
  final dynamic followedPosts;

  PostsSucces({required this.posts, required this.followedPosts});

  @override
  List<Object> get props => [posts, followedPosts];
}

class PostsLoading extends PostsState {}

class PostsFailure extends PostsState {
  final String error;

  PostsFailure({required this.error});

  @override
  List<Object> get props => [error];
}
