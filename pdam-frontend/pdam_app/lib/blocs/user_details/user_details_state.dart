part of 'user_details_bloc.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object> get props => [];
}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsSucces extends UserDetailsState {
  final GetProfileDto profile;
  final List<GetPostDto> posts;

  UserDetailsSucces({required this.profile, required this.posts});

  @override
  List<Object> get props => [profile, posts];
}

class UserDetailsFailure extends UserDetailsState {
  final String error;

  UserDetailsFailure({required this.error});

  @override
  List<Object> get props => [];
}

class ProfileLoading extends UserDetailsState {}
