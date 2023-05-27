part of 'liked_posts_bloc.dart';

abstract class LikedPostsState extends Equatable {
  const LikedPostsState();

  @override
  List<Object> get props => [];
}

class LikedPostsInitial extends LikedPostsState {}

class LikedPostsSuccess extends LikedPostsState {
  final List<GetPostDto> likedPosts;

  LikedPostsSuccess({required this.likedPosts});

  @override
  List<Object> get props => [];
}

class LikedPostsFailure extends LikedPostsState {
  final String error;

  LikedPostsFailure({required this.error});

  @override
  List<Object> get props => [];
}

class LikedPostsLoading extends LikedPostsState {}
