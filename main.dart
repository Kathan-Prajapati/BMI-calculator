import 'package:flutter/material.dart';

void main() => runApp(BMICalculatorApp());

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Weight',
                      labelStyle: TextStyle(color: Colors.blue[900]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[700]!),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _weightUnit,
                  items: [
                    DropdownMenuItem(value: 'kg', child: Text('kg')),
                    DropdownMenuItem(value: 'lbs', child: Text('lbs')),
                    DropdownMenuItem(value: 'g', child: Text('g')),
                    DropdownMenuItem(value: 'tons', child: Text('tons')),
                  ],
                  onChanged: (newValue) {
                    setState(() {
                      _weightUnit = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Height',
                      labelStyle: TextStyle(color: Colors.blue[900]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[700]!),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _heightUnit,
                  items: [
                    DropdownMenuItem(value: 'cm', child: Text('cm')),
                    DropdownMenuItem(value: 'inches', child: Text('inches')),
                  ],
                  onChanged: (newValue) {
                    setState(() {
                      _heightUnit = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: Text('Calculate BMI'),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]),
            ),
          ],
        ),
      ),
    );
  }

  bool _isNumeric(String s) {
    for (int i = 0; i < s.length; i++) {
      if (s[i] != '.' && (s[i].codeUnitAt(0) < 48 || s[i].codeUnitAt(0) > 57)) {
        return false;
      }
    }
    return true;
  }

  double _convertWeightToKg(String weightStr) {
    double weight = double.parse(weightStr);
    if (_weightUnit == 'lbs') {
      return weight / 2.205;
    } else if (_weightUnit == 'g') {
      return weight / 1000;
    } else if (_weightUnit == 'tons') {
      return weight * 1000;
    }
    return weight;
  }

  double _convertHeightToCm(String heightStr) {
    double height = double.parse(heightStr);
    if (_heightUnit == 'inches') {
      return height * 2.54;
    }
    return height;
  }

  void _calculateBMI() {
    String weightStr = _weightController.text;
    String heightStr = _heightController.text;

    if (!_isNumeric(weightStr) || !_isNumeric(heightStr)) {
      setState(() {
        _result = "Invalid input";
      });
      return;
    }

    double weight = _convertWeightToKg(weightStr);
    double height = _convertHeightToCm(heightStr);

    if (weight <= 0 || height <= 0) {
      setState(() {
        _result = "Invalid input";
      });
      return;
    }

    double bmi = (weight / ((height / 100) * (height / 100)));
    String bmiResult = bmi.toStringAsFixed(2);

    // Determine BMI Category and Recommendation
    String category;
    String suggestion;

    if (bmi < 18.5) {
      category = "Underweight";
      suggestion = "Consider a balanced diet rich in nutrients and consult a healthcare provider to maintain a healthy weight.";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      category = "Normal weight";
      suggestion = "Great job! Maintain your healthy lifestyle with regular exercise and a balanced diet.";
    } else if (bmi >= 25 && bmi < 29.9) {
      category = "Overweight";
      suggestion = "Incorporate regular physical activity and consider portion control for meals to help reach a healthier BMI.";
    } else {
      category = "Obesity";
      suggestion = "Consult a healthcare provider to develop a personalized plan for reaching a healthier weight.";
    }

    setState(() {
      _result = 'Your BMI is $bmiResult ($category).\n$suggestion';
    });
  }
}

