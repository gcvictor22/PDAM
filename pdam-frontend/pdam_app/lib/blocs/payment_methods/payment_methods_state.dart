part of 'payment_methods_bloc.dart';

abstract class PaymentMethodsState extends Equatable {
  const PaymentMethodsState();

  @override
  List<Object> get props => [];
}

class PaymentMethodsInitial extends PaymentMethodsState {}

class PaymentMethodsSuccess extends PaymentMethodsState {
  final List<GetPaymentMethodDto> list;

  PaymentMethodsSuccess({required this.list});

  @override
  List<Object> get props => [list];
}

class PaymentMethodsFailure extends PaymentMethodsState {
  final String error;

  PaymentMethodsFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class PaymentMethodsLoading extends PaymentMethodsState {}
