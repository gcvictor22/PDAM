part of 'follows_followers_bloc_bloc.dart';

abstract class FollowsFollowersEvent extends Equatable {
  const FollowsFollowersEvent();

  @override
  List<Object> get props => [];
}

class FollowsFollowersInitialEvent extends FollowsFollowersEvent {}

class FollowsFollowersFollowEvent extends FollowsFollowersEvent {
  final String userName;

  FollowsFollowersFollowEvent({required this.userName});

  List<Object> get props => [userName];
}

class FollowsFollowersScrollFollowersEvent extends FollowsFollowersEvent {}

class FollowsFollowersScrollFollowsEvent extends FollowsFollowersEvent {}
