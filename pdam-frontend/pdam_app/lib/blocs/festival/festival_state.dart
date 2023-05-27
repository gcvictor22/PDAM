part of 'festival_bloc.dart';

abstract class FestivalState extends Equatable {
  const FestivalState();

  @override
  List<Object> get props => [];
}

class FestivalInitial extends FestivalState {}

class FestivalSuccess extends FestivalState {
  final GetFestivalDto festival;

  FestivalSuccess({required this.festival});

  @override
  List<Object> get props => [festival];
}

class FestivalFailure extends FestivalState {
  final String error;

  FestivalFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class FestivalLoading extends FestivalState {}
