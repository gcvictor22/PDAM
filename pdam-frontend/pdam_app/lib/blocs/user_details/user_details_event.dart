part of 'user_details_bloc.dart';

abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();

  @override
  List<Object> get props => [];
}

class UserDetailsInitialEvent extends UserDetailsEvent {}

class UserDetailsFollowEvent extends UserDetailsEvent {
  final String userName;

  UserDetailsFollowEvent({required this.userName});

  @override
  List<Object> get props => [];
}

class UserDetailsLikeAPost extends UserDetailsEvent {
  final int id;

  UserDetailsLikeAPost({required this.id});

  @override
  List<Object> get props => [];
}

class UserDetailsScrollPostsEvent extends UserDetailsEvent {}
