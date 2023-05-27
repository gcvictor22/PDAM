import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdam_app/services/user_service.dart';

import '../../models/payment_method.dart';

part 'payment_methods_event.dart';
part 'payment_methods_state.dart';

class PaymentMethodsBloc
    extends Bloc<PaymentMethodsEvent, PaymentMethodsState> {
  final UserService _userService;

  PaymentMethodsBloc(UserService userService)
      // ignore: unnecessary_null_comparison
      : assert(userService != null),
        _userService = userService,
        super(PaymentMethodsInitial()) {
    on<PaymentMethodsInitialEvent>((event, emit) async {
      await _onInitialState(event, emit);
    });

    on<PaymentMethodsUptadeEvente>(
      (event, emit) async {
        await _updateActiveCard(event.id);
        await _onInitialState(event, emit);
      },
    );
  }

  Future<void> _onInitialState(
      PaymentMethodsEvent event, Emitter<PaymentMethodsState> emit) async {
    try {
      PaymentMethodResponse response = await _fetchUserPaymentMethods();
      emit(PaymentMethodsSuccess(list: response.content!));
    } catch (_) {
      emit(PaymentMethodsFailure(error: _.toString()));
    }
  }

  Future<dynamic> _updateActiveCard(int id) async {
    return await _userService.updateActiveMethod(id);
  }

  Future<dynamic> _fetchUserPaymentMethods() async {
    return await _userService.getUserPaymentMethods();
  }
}
