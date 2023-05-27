part of 'parties_bloc.dart';

abstract class PartiesEvent extends Equatable {
  const PartiesEvent();

  @override
  List<Object> get props => [];
}

class PartiesInitialEvent extends PartiesEvent {}

class PartiesScrollEvent extends PartiesEvent {}
