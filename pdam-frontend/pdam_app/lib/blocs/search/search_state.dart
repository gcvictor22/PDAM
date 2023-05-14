part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchSuccess extends SearchState {
  final dynamic users;
  final dynamic events;

  const SearchSuccess({required this.users, required this.events});

  @override
  List<Object> get props => [users, events];
}

class SearchFailure extends SearchState {}

class SearchLoading extends SearchState {}
