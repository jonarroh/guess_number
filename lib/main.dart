import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Guess the number'),
    );
  }
}

enum GuessNumberResult {
  correct,
  less,
  greater,
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _initialNumber = 0;
  int _finalNumber = 100;
  int _guessNumber = Random().nextInt(100);
  int _attempts = 10;

  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
  ];

  void _changeAttemps() {
    setState(() {
      if (_attempts > 0) {
        _attempts--;
      }
    });
  }

  void _resetGame() {
    setState(() {
      _initialNumber = 0;
      _finalNumber = 100;
      _guessNumber = 0;
      _attempts = 10;
    });
  }

  void _changeInitialNumber(String value) {
    setState(() {
      _initialNumber = int.parse(value);
    });
  }

  void _changeFinalNumber(String value) {
    setState(() {
      _finalNumber = int.parse(value);
    });
  }

  void _changeGuessNumber(String value) {
    setState(() {
      _guessNumber = int.parse(value);
    });
  }

  GuessNumberResult _guessNumberResult(int number) {

    if (number == _guessNumber) {
      return GuessNumberResult.correct;
    } else if (number < _guessNumber) {
      // Si el número es menor que el número a adivinar
      if (number > _initialNumber) {
        _changeInitialNumber(number.toString());

        // Mostrar un snackbar indicando que el número es mayor al límite inicial
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("El número es mayor a $_initialNumber"),
          ),
        );
      }
      return GuessNumberResult.less;
    } else {
      // Si el número es mayor que el número a adivinar
      if (number < _finalNumber) {
        _changeFinalNumber(number.toString());
        // Mostrar un snackbar indicando que el número es menor al límite final
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("El número es menor a $_finalNumber"),
          ),
        );
      }
      return GuessNumberResult.greater;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextField Width Example'),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              Text(
                "Intentos: $_attempts",
                style: TextStyle(
                  fontSize: 20,
                  color: _attempts > 0 ? colors[_attempts - 1] : Colors.black,
                ),
              ),
              NumberInputField(
                initialNumber: _initialNumber,
                finalNumber: _finalNumber,
                onSubmit: (String v) {
                  if (_attempts == 0) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Perdiste"),
                          content:  Text("Se acabaron los intentos el número era $_guessNumber"),
                          actions: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                _resetGame();
                              },
                              child: const Text("Volver a jugar"),
                            )
                          ],
                        );
                      },
                    );
                    return;
                  }
                  int value = int.parse(v);
                  var result = _guessNumberResult(value);

                  if (result == GuessNumberResult.correct) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Felicidades"),
                          content: const Text("Adivinaste el número"),
                          actions: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                _resetGame();
                              },
                              child: const Text("Volver a jugar"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    _changeAttemps();
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberInputField extends StatelessWidget {
  final int initialNumber;
  final int finalNumber;
  final ValueChanged<String> onSubmit;

  const NumberInputField({
    Key? key,
    required this.initialNumber,
    required this.finalNumber,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        helperText: '$initialNumber',
        counter: Text('$finalNumber'),
      ),
      onSubmitted: onSubmit,
      keyboardType: TextInputType.number,
    );
  }
}