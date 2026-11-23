import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState>{
  MainScreenCubit():super(const MainScreenState());

  void calculate({
    required double capital,
    required double time,
    required double rate,
  }) {
    if (capital <= 0 || time <= 0 || rate <= 0) {
      emit(const MainScreenState(
        errorMessage: 'Введите корректные значения',
      ));
      return;
    }

    final interest = capital * rate * time / 100;
    final total = capital + interest;

    emit(MainScreenState(
      interest: interest,
      total: total,
      isCalculated: true,
    ));
  }

  void reset() {
    emit(const MainScreenState());
  }
}