import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/history_cubit.dart';
import 'cubit/history_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit()..loadHistory(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('История расчётов'),
          centerTitle: true,
        ),
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.errorMessage != null) {
              return Center(
                child: Text(state.errorMessage!),
              );
            }

            if (state.calculations.isEmpty) {
              return const Center(
                child: Text('История расчётов пуста'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.calculations.length,
              itemBuilder: (context, index) {
                final item = state.calculations[index];

                final date = DateTime.parse(item['date'])
                    .toLocal();

                final formattedDate =
                    '${date.day.toString().padLeft(2, '0')}.'
                    '${date.month.toString().padLeft(2, '0')}.'
                    '${date.year} '
                    '${date.hour.toString().padLeft(2, '0')}:'
                    '${date.minute.toString().padLeft(2, '0')}';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      'Итоговая сумма: '
                      '${(item['total'] as num).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Капитал: ${item['capital']}'),
                          Text('Срок: ${item['time']} лет'),
                          Text('Ставка: ${item['rate']}%'),
                          Text(
                            'Начисленные проценты: '
                            '${(item['interest'] as num).toStringAsFixed(2)}',
                          ),
                          Text('Дата: $formattedDate'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}