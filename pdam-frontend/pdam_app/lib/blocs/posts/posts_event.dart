part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class PostsInitialEvent extends PostsEvent {}

class PostsRefreshEvent extends PostsEvent {}
