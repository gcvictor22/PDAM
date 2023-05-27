import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../services/event_service.dart';

class BuyTicketsBloc extends FormBloc<String, String> {
  final int id;
  final EventService _eventService;
  // ignore: unused_field
  late String stripeId;

  BuyTicketsBloc(EventService eventService, this.id)
      // ignore: unnecessary_null_comparison
      : assert(eventService != null),
        _eventService = eventService {}

  Future<void> buyParty() async {
    emitSubmitting();
    _eventService.buyParty(id).then((value) {
      stripeId = value.paymentId!;
      emitSuccess();
    }).catchError((onError) {
      emitFailure();
    });
  }

  @override
  FutureOr<void> onSubmitting() {}
}
