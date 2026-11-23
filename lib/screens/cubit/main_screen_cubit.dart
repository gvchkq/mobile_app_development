import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen_state.dart';
import '../../database/db_provider.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(const MainScreenState());

  Future<void> saveInputData({
    required double capital,
    required double time,
    required double rate,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('capital', capital);
    await prefs.setDouble('time', time);
    await prefs.setDouble('rate', rate);
  }

  Future<void> saveCalculation({
    required double capital,
    required double time,
    required double rate,
    required double interest,
    required double total,
  }) async {
    await DBProvider.instance.insertCalculation({
      'capital': capital,
      'time': time,
      'rate': rate,
      'interest': interest,
      'total': total,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<void> calculate({
    required double capital,
    required double time,
    required double rate,
  }) async {
    if (capital <= 0 || time <= 0 || rate <= 0) {
      emit(const MainScreenState(
        errorMessage: 'Введите корректные значения',
      ));
      return;
    }

    final interest = capital * rate * time / 100;
    final total = capital + interest;

    try {
      await saveInputData(
        capital: capital,
        time: time,
        rate: rate,
      );

      await saveCalculation(
        capital: capital,
        time: time,
        rate: rate,
        interest: interest,
        total: total,
      );

      emit(MainScreenState(
        interest: interest,
        total: total,
        isCalculated: true,
      ));
    } catch (e) {
      emit(MainScreenState(
        errorMessage: 'Ошибка сохранения данных: $e',
      ));
    }
  }

  void reset() {
    emit(const MainScreenState());
  }
}