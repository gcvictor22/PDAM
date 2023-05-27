import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pdam_app/models/event/GetFestivalDto.dart';
import 'package:pdam_app/widgets/Messages.dart';

import '../../pages/confirm_festival_buy_page.dart';
import '../../services/event_service.dart';

part 'festival_event.dart';
part 'festival_state.dart';

class FestivalBloc extends Bloc<FestivalEvent, FestivalState> {
  final int id;
  final EventService _eventService;
  FestivalBloc(EventService eventService, this.id)
      // ignore: unnecessary_null_comparison
      : assert(eventService != null),
        _eventService = eventService,
        super(FestivalInitial()) {
    on<FestivalInitialEvent>(
      (event, emit) async {
        try {
          GetFestivalDto festivalDto = await _eventService.findFestival(id);
          emit(FestivalSuccess(festival: festivalDto));
        } catch (e) {
          emit(FestivalFailure(error: e.toString()));
        }
      },
    );
    on<FestivalBuyEvent>(
      (event, emit) async {
        try {
          GetFestivalDto festivalDto = await _eventService.buyFestival(id);
          Navigator.push(
            event.context,
            MaterialPageRoute(
              builder: (_) {
                return ConfirmFestivalBuyPage(
                  stripeId: festivalDto.stripeId!,
                );
              },
            ),
          );
        } catch (e) {
          showError(event.context,
              "Comprueba tus metodos de pago, o que todavía queden entradas disponibles");
        }
      },
    );
  }
}
