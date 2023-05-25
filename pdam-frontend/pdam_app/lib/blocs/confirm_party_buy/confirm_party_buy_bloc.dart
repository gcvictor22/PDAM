import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pdam_app/services/event_service.dart';

class ConfirmPartyBuyBloc extends FormBloc<String, String> {
  final EventService _eventService;
  final String stripeId;

  ConfirmPartyBuyBloc(EventService eventService, this.stripeId)
      // ignore: unnecessary_null_comparison
      : assert(eventService != null),
        _eventService = eventService {}

  Future<dynamic> confirmBuy() async {
    emitSubmitting();
    try {
      await _eventService.confirmPartyBuy(stripeId).then((value) {
        emitSuccess();
      });
    } catch (e) {
      emitFailure();
    }
  }

  Future<dynamic> cancelBuy() async {
    emitSubmitting();
    try {
      await _eventService.cancelPartyBuy(stripeId).then((value) {
        emitSuccess();
      });
    } catch (e) {
      emitFailure();
    }
  }

  @override
  FutureOr<void> onSubmitting() {
    // TODO: implement onSubmitting
    throw UnimplementedError();
  }
}
