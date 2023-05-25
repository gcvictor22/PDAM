part of 'parties_bloc.dart';

abstract class PartiesState extends Equatable {
  const PartiesState();

  @override
  List<Object> get props => [];
}

class PartiesInitial extends PartiesState {}

class PartiesSuccess extends PartiesState {
  final List<GetPartyDto> parties;

  PartiesSuccess({required this.parties});

  @override
  List<Object> get props => [parties];
}

class PartiesFailure extends PartiesState {
  final String error;

  PartiesFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class PartiesLoading extends PartiesState {}
