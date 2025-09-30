import 'dart:io';

import 'package:v01/calculator.dart';

void main(List<String> arguments) {
  print('Triggering gitactions');
  print(
    '\n'
    '--------------------------------\n'
    'Calculator: ',
  );
  final calc = Calculator();
  while (true) {
    print(
      '\n'
      'Enter an operation in the following format:\n'
      '(1 + 3, 5 - 2, 5 * 2, 6 / 2)\n'
      'Consider the spacing!\n'
      'or "exit" to quit:',
    );
    String? userInput = stdin.readLineSync();
    if (userInput == null) {
      print('Invalid input. Please try again.');
      continue;
    }
    if (userInput.toLowerCase() == 'exit') {
      print('Exiting calculator. Goodbye!');
      break;
    }
    List<String> parts = userInput.split(' ');
    if (parts.length != 3) {
      print('Invalid input format. Please try again.');
      continue;
    }

    double? a = double.tryParse(parts[0]);
    String operator = parts[1];
    double? b = double.tryParse(parts[2]);
    if (a == null || b == null) {
      print('Invalid numbers. Please try again.');
      continue;
    }
    switch (operator) {
      case '+':
        print(calc.add(a, b));
        break;
      case '-':
        print(calc.subtract(a, b));
        break;
      case '*':
        print(calc.multiply(a, b));
        break;
      case '/':
        try {
          print(calc.divide(a, b));
        } on ArgumentError catch (e) {
          print(e.message);
          break;
        }
        break;
      default:
        print('Invalid operator. Please use +, -, *, or /.');
        continue;
    }
  }
}
