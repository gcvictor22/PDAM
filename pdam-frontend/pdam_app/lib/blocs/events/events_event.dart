part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class EventsInitialEvent extends EventsEvent {}

class ScrollDiscothequesEvent extends EventsEvent {}

class ScrollFestivalEvent extends EventsEvent {}

class ScrollEventsEvent extends EventsEvent {}

class RefreshDiscothequesEvent extends EventsEvent {}

class RefreshFestivalsEvent extends EventsEvent {}

class RefreshEventsEvent extends EventsEvent {}
