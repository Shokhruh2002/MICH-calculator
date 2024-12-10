import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0'; // Displayed text
  String operand1 = ''; // First operand
  String operand2 = ''; // Second operand
  String operator = ''; // Operator

 void onButtonPressed(String value) {
  setState(() {
    if (value == 'AC') {
      // Reset all values
      display = '0';
      operand1 = '';
      operand2 = '';
      operator = '';
    } else if (value == '←') {
      // Backspace functionality
      if (display.isNotEmpty) {
        display = display.substring(0, display.length - 1);
        if (display.isEmpty) display = '0';
      }
    } else if ('+-*/'.contains(value)) {
      // Operator handling
      if (operand1.isEmpty) {
        operand1 = display;
        operator = value;
        display = '';
      }
    } else if (value == '=') {
      // Calculate result
      if (operand1.isNotEmpty && operator.isNotEmpty) {
        operand2 = display;
        display = calculateResult(operand1, operator, operand2);
        operand1 = '';
        operand2 = '';
        operator = '';
      }
    } else if (value == '.') {
      // Handle decimal point
      if (display.isEmpty || display == '0') {
        // If empty or just 0, start with "0."
        display = '0.';
      } else if (!display.contains('.')) {
        // Append '.' if not already present
        display += value;
      }
    } else {
      // Handle numbers
      if (display == '0') {
        if (value != '0') {
          display = value; // Replace 0 with the pressed number
        }
      } else {
        display += value; // Append number
      }
    }
  });
}

  String calculateResult(String op1, String operator, String op2) {
    double num1 = double.parse(op1);
    double num2 = double.parse(op2);
    double result;

    switch (operator) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '*':
        result = num1 * num2;
        break;
      case '/':
        result = num2 != 0 ? num1 / num2 : double.nan;
        break;
      default:
        result = 0;
    }

    // Remove .0 if result is a whole number
    return result % 1 == 0 ? result.toInt().toString() : result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 300,
          height: 450,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: const Color.fromARGB(255, 188, 238, 10), width: 10),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            children: [
              // Display section
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    display,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Button section
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(12),
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: [
                    // AC button
                    buildButton("AC", Colors.green, Colors.white),
                    buildButton("", Colors.black, Colors.black),
                    buildButton("", Colors.black, Colors.black),
                    buildButton("/", Colors.green, Colors.white),

                    // Numbers and operators
                    buildButton("7", Colors.grey, Colors.white),
                    buildButton("8", Colors.grey, Colors.white),
                    buildButton("9", Colors.grey, Colors.white),
                    buildButton("*", Colors.green, Colors.white),

                    buildButton("4", Colors.grey, Colors.white),
                    buildButton("5", Colors.grey, Colors.white),
                    buildButton("6", Colors.grey, Colors.white),
                    buildButton("-", Colors.green, Colors.white),

                    buildButton("1", Colors.grey, Colors.white),
                    buildButton("2", Colors.grey, Colors.white),
                    buildButton("3", Colors.grey, Colors.white),
                    buildButton("+", Colors.green, Colors.white),

                    // Zero and decimal point
                    buildButton("0", Colors.green, Colors.white),
                    buildButton("←", Colors.green, Colors.white),
                    buildButton(".", Colors.green, Colors.white),
                    buildButton("=", Colors.green, Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String label, Color bgColor, Color textColor) {
    return InkWell(
      onTap: () => onButtonPressed(label),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
