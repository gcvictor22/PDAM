part of 'follows_followers_bloc_bloc.dart';

abstract class FollowsFollowersState extends Equatable {
  const FollowsFollowersState();

  @override
  List<Object> get props => [];
}

class FollowsFollowersBlocInitial extends FollowsFollowersState {}

class FollowsFollowersSuccess extends FollowsFollowersState {
  final List<UserWhoPost> follows;
  final List<UserWhoPost> followers;

  FollowsFollowersSuccess({required this.followers, required this.follows});

  @override
  List<Object> get props => [follows, followers];
}

class FollowsFollowersFailure extends FollowsFollowersState {
  final String error;

  FollowsFollowersFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class FollowsFollowersLoading extends FollowsFollowersState {}
