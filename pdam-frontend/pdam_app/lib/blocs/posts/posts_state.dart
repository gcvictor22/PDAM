part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsInitial extends PostsState {}

class PostsSucces extends PostsState {
  final List<GetPostDto> posts;

  PostsSucces({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PostsLoading extends PostsState {}

class PostsFailure extends PostsState {
  final String error;

  PostsFailure({required this.error});

  @override
  List<Object> get props => [error];
}
