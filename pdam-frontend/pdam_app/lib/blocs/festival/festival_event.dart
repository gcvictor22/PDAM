part of 'festival_bloc.dart';

abstract class FestivalEvent extends Equatable {
  const FestivalEvent();

  @override
  List<Object> get props => [];
}

class FestivalInitialEvent extends FestivalEvent {}

class FestivalBuyEvent extends FestivalEvent {
  final BuildContext context;

  FestivalBuyEvent({required this.context});
}
