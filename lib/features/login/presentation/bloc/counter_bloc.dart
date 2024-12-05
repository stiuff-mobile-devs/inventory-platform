import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<IncrementCounter>((event, emit) {
      emit(CounterState(state.count + 1));
    });

    on<ResetCounter>((event, emit) {
      emit(const CounterState(0));
    });
  }
}
