import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'gender_selection_widget.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator Pro',
      theme: ThemeData(
        brightness: Brightness.dark, // Using a dark theme
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  // Controllers for Metric units
  final _heightMetersController = TextEditingController();
  final _weightKgController = TextEditingController();

  // Controllers for Imperial units
  final _heightFeetController = TextEditingController();
  final _heightInchesController = TextEditingController();
  final _weightLbsController = TextEditingController();

  final _ageController = TextEditingController();

  double? _bmi;
  String _message = 'Please enter your details';
  Color _resultCardColor = Colors.transparent;
  int _gender = 0; // 0 for male, 1 for female
  bool _isMetric = true;

  void _calculateBmi() {
    final int? age = int.tryParse(_ageController.text);
    double? bmiValue;

    if (_isMetric) {
      final double? height = double.tryParse(_heightMetersController.text);
      final double? weight = double.tryParse(_weightKgController.text);
      if (height == null ||
          height <= 0 ||
          weight == null ||
          weight <= 0 ||
          age == null ||
          age <= 0) {
        _showInvalidInputDialog();
        return;
      }
      bmiValue = weight / (height * height);
    } else {
      final double? feet = double.tryParse(_heightFeetController.text);
      final double? inches = double.tryParse(_heightInchesController.text);
      final double? weight = double.tryParse(_weightLbsController.text);
      if (feet == null ||
          feet < 0 ||
          inches == null ||
          inches < 0 ||
          weight == null ||
          weight <= 0 ||
          age == null ||
          age <= 0) {
        _showInvalidInputDialog();
        return;
      }
      final double totalInches = (feet * 12) + inches;
      if (totalInches <= 0) {
        _showInvalidInputDialog();
        return;
      }
      bmiValue = (weight / (totalInches * totalInches)) * 703;
    }

    setState(() {
      _bmi = bmiValue;
      if (_bmi! < 18.5) {
        _message = 'You are underweight';
        _resultCardColor = Colors.blue.shade300;
      } else if (_bmi! < 25) {
        _message = 'You have a normal weight';
        _resultCardColor = Colors.green.shade400;
      } else if (_bmi! < 30) {
        _message = 'You are overweight';
        _resultCardColor = Colors.orange.shade400;
      } else {
        _message = 'You are obese';
        _resultCardColor = Colors.red.shade400;
      }
    });
  }

  void _showInvalidInputDialog() {
    setState(() {
      _message = 'Please enter valid details';
      _bmi = null;
    });
  }

  void _clearFields() {
    _heightMetersController.clear();
    _weightKgController.clear();
    _heightFeetController.clear();
    _heightInchesController.clear();
    _weightLbsController.clear();
    _ageController.clear();
    setState(() {
      _bmi = null;
      _message = 'Please enter your details';
      _gender = 0;
    });
  }

  @override
  void dispose() {
    _heightMetersController.dispose();
    _weightKgController.dispose();
    _heightFeetController.dispose();
    _heightInchesController.dispose();
    _weightLbsController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text('BMI Calculator Pro'),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  CupertinoSlidingSegmentedControl<bool>(
                    groupValue: _isMetric,
                    backgroundColor: Colors.black.withOpacity(0.2),
                    thumbColor: Colors.teal,
                    padding: const EdgeInsets.all(4),
                    onValueChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          _isMetric = value;
                          _clearFields();
                        });
                      }
                    },
                    children: const {
                      true: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          'Metric',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      false: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          'Imperial',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    },
                  ),
                  const SizedBox(height: 16.0),
                  GenderSelectionWidget(
                    gender: _gender,
                    onGenderSelected: (gender) {
                      setState(() {
                        _gender = gender;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  _InputCard(
                    isMetric: _isMetric,
                    heightMetersController: _heightMetersController,
                    weightKgController: _weightKgController,
                    heightFeetController: _heightFeetController,
                    heightInchesController: _heightInchesController,
                    weightLbsController: _weightLbsController,
                    ageController: _ageController,
                  ),
                  const SizedBox(height: 16.0),
                  _ActionButtons(
                    onCalculate: _calculateBmi,
                    onClear: _clearFields,
                  ),
                  const SizedBox(height: 16.0),
                  if (_bmi != null)
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: _resultCardColor, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Your BMI is ${_bmi!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              _message,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: _resultCardColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final bool isMetric;
  final TextEditingController heightMetersController;
  final TextEditingController weightKgController;
  final TextEditingController heightFeetController;
  final TextEditingController heightInchesController;
  final TextEditingController weightLbsController;
  final TextEditingController ageController;

  const _InputCard({
    required this.isMetric,
    required this.heightMetersController,
    required this.weightKgController,
    required this.heightFeetController,
    required this.heightInchesController,
    required this.weightLbsController,
    required this.ageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (isMetric) ...[
          _buildTextField(
            controller: heightMetersController,
            labelText: 'Height (m)',
            icon: FontAwesomeIcons.rulerVertical,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            controller: weightKgController,
            labelText: 'Weight (kg)',
            icon: FontAwesomeIcons.weightScale,
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: heightFeetController,
                  labelText: 'Height (ft)',
                  icon: FontAwesomeIcons.rulerVertical,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: heightInchesController,
                  labelText: '(in)',
                  icon: null, // No icon for the smaller field
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            controller: weightLbsController,
            labelText: 'Weight (lbs)',
            icon: FontAwesomeIcons.weightScale,
          ),
        ],
        const SizedBox(height: 16.0),
        _buildTextField(
          controller: ageController,
          labelText: 'Age',
          icon: FontAwesomeIcons.cakeCandles,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData? icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: icon != null
            ? Icon(icon, color: Colors.white70, size: 20)
            : null,
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onCalculate;
  final VoidCallback onClear;

  const _ActionButtons({required this.onCalculate, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Clear', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: onCalculate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text('Calculate', style: TextStyle(fontSize: 18.0)),
          ),
        ),
      ],
    );
  }
}
