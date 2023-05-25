import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../services/event_service.dart';

class BuyPartyBloc extends FormBloc<String, String> {
  final int partyId;
  final EventService _eventService;
  // ignore: unused_field
  late String stripeId;

  BuyPartyBloc(EventService eventService, this.partyId)
      // ignore: unnecessary_null_comparison
      : assert(eventService != null),
        _eventService = eventService {}

  @override
  FutureOr<void> onSubmitting() {
    _eventService.buyParty(partyId).then((value) {
      stripeId = value.paymentId!;
      emitSuccess();
    }).catchError((error) {
      emitFailure();
    });
  }
}
