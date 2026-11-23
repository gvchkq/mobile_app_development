import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Калькулятор процентов',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _capitalController = TextEditingController();
  final _timeController = TextEditingController();
  final _rateController = TextEditingController();

  bool _agreement = false;

  @override
  void dispose() {
    _capitalController.dispose();
    _timeController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  double? parseNumber(String value) {
    return double.tryParse(value.replaceAll(',', '.'));
  }

  String? validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Заполните поле';
    }

    final number = parseNumber(value);

    if (number == null) {
      return 'Введите корректное число';
    }

    if (number <= 0) {
      return 'Число должно быть больше нуля';
    }

    return null;
  }

  void calculate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreement) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Необходимо дать согласие на обработку данных'),
        ),
      );
      return;
    }

    final capital = parseNumber(_capitalController.text)!;
    final time = parseNumber(_timeController.text)!;
    final rate = parseNumber(_rateController.text)!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          capital: capital,
          time: time,
          rate: rate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Гриценко Ева Анатольевна'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Калькулятор простых процентов',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: _capitalController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Исходный капитал',
                  border: OutlineInputBorder(),
                ),
                validator: validateNumber,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _timeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Срок начисления процентов (лет)',
                  border: OutlineInputBorder(),
                ),
                validator: validateNumber,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _rateController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Годовая процентная ставка (%)',
                  border: OutlineInputBorder(),
                ),
                validator: validateNumber,
              ),

              const SizedBox(height: 10),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Согласие на обработку данных',
                ),
                value: _agreement,
                onChanged: (value) {
                  setState(() {
                    _agreement = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: calculate,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Рассчитать',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final double capital;
  final double time;
  final double rate;

  const ResultScreen({
    super.key,
    required this.capital,
    required this.time,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    final interest = capital * rate * time / 100;
    final total = capital + interest;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат расчёта'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Результаты вычислений',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              'Исходный капитал: ${capital.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 17),
            ),

            const SizedBox(height: 15),

            Text(
              'Срок начисления: ${time.toStringAsFixed(2)} лет',
              style: const TextStyle(fontSize: 17),
            ),

            const SizedBox(height: 15),

            Text(
              'Процентная ставка: ${rate.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 17),
            ),

            const Divider(height: 35),

            Text(
              'Начисленные проценты: ${interest.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              'Итоговая сумма: ${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Вернуться назад',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}