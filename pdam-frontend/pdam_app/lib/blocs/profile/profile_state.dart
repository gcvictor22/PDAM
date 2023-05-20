part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileSucces extends ProfileState {
  final GetProfileDto profile;
  final List<GetPostDto> posts;

  ProfileSucces({required this.profile, required this.posts});

  @override
  List<Object> get props => [profile, posts];
}

class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure({required this.error});

  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {}
