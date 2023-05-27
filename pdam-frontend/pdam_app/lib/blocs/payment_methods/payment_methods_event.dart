part of 'payment_methods_bloc.dart';

abstract class PaymentMethodsEvent extends Equatable {
  const PaymentMethodsEvent();

  @override
  List<Object> get props => [];
}

class PaymentMethodsInitialEvent extends PaymentMethodsEvent {}

class PaymentMethodsUptadeEvente extends PaymentMethodsEvent {
  final int id;

  PaymentMethodsUptadeEvente({required this.id});

  @override
  List<Object> get props => [];
}
