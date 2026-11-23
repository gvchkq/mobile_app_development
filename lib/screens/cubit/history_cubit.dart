import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/db_provider.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(const HistoryState());

  Future<void> loadHistory() async {
    emit(const HistoryState(isLoading: true));

    try {
      final calculations =
          await DBProvider.instance.getAllCalculations();

      emit(HistoryState(
        calculations: calculations,
      ));
    } catch (e) {
      emit(HistoryState(
        errorMessage: 'Ошибка загрузки истории: $e',
      ));
    }
  }
}