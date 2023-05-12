part of 'events_bloc.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];
}

class EventsInitial extends EventsState {}

class EventsSuccess extends EventsState {
  final dynamic discotheques;
  final dynamic festivals;
  final dynamic events;

  EventsSuccess(
      {required this.discotheques,
      required this.festivals,
      required this.events});

  @override
  List<Object> get props => [discotheques, festivals, events];
}

class EventsFailure extends EventsState {
  final String error;

  EventsFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class EventsLoading extends EventsState {}
