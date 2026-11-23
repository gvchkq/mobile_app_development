import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/main_screen_cubit.dart';
import 'cubit/main_screen_state.dart';
import 'history_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final capitalController = TextEditingController();
  final timeController = TextEditingController();
  final rateController = TextEditingController();

  bool isAgreed = false;

  @override
  void dispose() {
    capitalController.dispose();
    timeController.dispose();
    rateController.dispose();
    super.dispose();
  }

  void calculate() {
    if (!isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Необходимо дать согласие на расчёт'),
        ),
      );
      return;
    }

    final capital = double.tryParse(
      capitalController.text.replaceAll(',', '.'),
    );

    final time = double.tryParse(
      timeController.text.replaceAll(',', '.'),
    );

    final rate = double.tryParse(
      rateController.text.replaceAll(',', '.'),
    );

    if (capital == null || time == null || rate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заполните все поля числами'),
        ),
      );
      return;
    }

    context.read<MainScreenCubit>().calculate(
      capital: capital,
      time: time,
      rate: rate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор процентов'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.history),
          tooltip: 'История расчётов',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryScreen(),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Расчёт простых процентов',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: capitalController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Начальный капитал',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: timeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Срок (годы)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: rateController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Процентная ставка (%)',
                border: OutlineInputBorder(),
              ),
            ),
            CheckboxListTile(
              value: isAgreed,onChanged: (value) {
                setState(() {
                  isAgreed = value ?? false;
                });
              },
              title: const Text('Согласен на выполнение расчёта'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: calculate,
              child: const Text('Рассчитать'),
            ),
            const SizedBox(height: 20),
            BlocBuilder<MainScreenCubit, MainScreenState>(
              builder: (context, state) {
                if (state.errorMessage != null) {
                  return Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  );
                }

                if (state.isCalculated) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Результат расчёта',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Начисленные проценты: '
                            '${state.interest!.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Итоговая сумма: '
                            '${state.total!.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              context.read<MainScreenCubit>().reset();
                            },
                            child: const Text('Сбросить результат'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}