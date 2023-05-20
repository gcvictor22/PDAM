part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileInitialEvent extends ProfileEvent {}

class ProfileFollowEvent extends ProfileEvent {
  final String userName;

  ProfileFollowEvent({required this.userName});

  @override
  List<Object> get props => [];
}

class ProfileLikeAPost extends ProfileEvent {
  final int id;

  ProfileLikeAPost({required this.id});

  @override
  List<Object> get props => [];
}

class ProfileScrollPostsEvent extends ProfileEvent {}
