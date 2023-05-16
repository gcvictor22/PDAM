part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchInitialEvent extends SearchEvent {}

class SearchWriteEvent extends SearchEvent {}

class SearchFollowEvent extends SearchEvent {
  final String userName;

  SearchFollowEvent({required this.userName});

  @override
  List<Object> get props => [userName];
}
