part of 'liked_posts_bloc.dart';

abstract class LikedPostsEvent extends Equatable {
  const LikedPostsEvent();

  @override
  List<Object> get props => [];
}

class LikedPostsInitialEvent extends LikedPostsEvent {}

class LikedPostsScrollEvent extends LikedPostsEvent {}

class LikedPostsLikeEvent extends LikedPostsEvent {
  final int id;

  LikedPostsLikeEvent({required this.id});

  @override
  List<Object> get props => [id];
}
