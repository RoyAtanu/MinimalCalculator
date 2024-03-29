import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimalist Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MinimalCalculator(),
    );
  }
}

class MinimalCalculator extends StatefulWidget {
  const MinimalCalculator({super.key});

  @override
  State<MinimalCalculator> createState() => _MinimalCalculatorState();
}

class _MinimalCalculatorState extends State<MinimalCalculator> {
  double result = 0.0;
  String history = "";
  Operator lastOperator = Operator.none;
  ButtonAction lastAction = ButtonAction.none;
  double currentNumber = 0.0;

  void _calculate(double number, Operator operator) {
    setState(() {
      if (operator == Operator.plus) {
        result = result + number;
      }
      if (operator == Operator.minus) {
        result = result - number;
      }
      if (operator == Operator.multiply) {
        result = result * number;
      }
      if (operator == Operator.divide) {
        result = result / number;
      }
      if (operator == Operator.none) {
        result = number;
      }
    });
  }

  void _handleClick(String buttonText) {
    setState(() {
      if (double.tryParse(buttonText) != null) {
        double entry = double.parse(buttonText);
        history += buttonText;
        if (lastAction == ButtonAction.number) {
          currentNumber = (currentNumber * 10) + entry;
        } else {
          lastAction = ButtonAction.number;
          currentNumber = entry;
        }
      } else {
        switch (buttonText) {
          case "/":
            _calculate(currentNumber, lastOperator);
            history += buttonText;
            lastOperator = Operator.divide;
            break;
          case "*":
            _calculate(currentNumber, lastOperator);
            history += buttonText;
            lastOperator = Operator.multiply;
            break;
          case "-":
            _calculate(currentNumber, lastOperator);
            history += buttonText;
            lastOperator = Operator.minus;
            break;
          case "+":
            _calculate(currentNumber, lastOperator);
            history += buttonText;
            lastOperator = Operator.plus;
            break;
          case "C":
            result = 0.0;
            history = "";
            lastOperator = Operator.none;
            break;
          case "=":
            _calculate(currentNumber, lastOperator);
            history = "";
            lastOperator = Operator.none;
        }
        currentNumber = 0.0;
        lastAction = ButtonAction.operator;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonArray = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButtonArray("1"),
            _buildButtonArray("2"),
            _buildButtonArray("3"),
            _buildButtonArray("/")
          ],
        ),
        const Padding(padding: EdgeInsets.all(10.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButtonArray("4"),
            _buildButtonArray("5"),
            _buildButtonArray("6"),
            _buildButtonArray("*")
          ],
        ),
        const Padding(padding: EdgeInsets.all(10.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButtonArray("7"),
            _buildButtonArray("8"),
            _buildButtonArray("9"),
            _buildButtonArray("-")
          ],
        ),
        const Padding(padding: EdgeInsets.all(10.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButtonArray("C"),
            _buildButtonArray("0"),
            _buildButtonArray(""),
            _buildButtonArray("+")
          ],
        ),
        const Padding(padding: EdgeInsets.all(10.0)),
        SizedBox(
          width: 340,
          child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.white, width: 2.0))),
              ),
              onPressed: () => _handleClick("="),
              child: const Text("=",
                  style: TextStyle(color: Colors.white, fontSize: 60))),
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: const [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.green[800]!,
              Colors.indigo[700]!,
              Colors.purple[600]!,
              Colors.orange[400]!,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(padding: EdgeInsets.all(5.0)),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        child: Text(history,
                            style: const TextStyle(
                                fontSize: 35, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            textAlign: TextAlign.right))
                  ],
                ),
                const Padding(padding: EdgeInsets.all(5.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        child: Text(sanitiseResult(result),
                            style: const TextStyle(
                                fontSize: 80, color: Colors.white),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            textAlign: TextAlign.right))
                  ],
                )
              ],
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            buttonArray,
          ],
        ),
      ),
    );
  }

  Column _buildButtonArray(String buttonText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(color: Colors.white, width: 2.0))),
            ),
            onPressed: () => _handleClick(buttonText),
            child: Text(buttonText,
                style: const TextStyle(color: Colors.white, fontSize: 40)))
      ],
    );
  }
}

enum Operator { plus, minus, multiply, divide, equals, negate, decimal, none }

enum ButtonAction { operator, number, none }

String sanitiseResult(double result) {
  if (result % 1 == 0) {
    return result.toStringAsFixed(0);
  } else {
    return result.toStringAsFixed(3);
  }
}
