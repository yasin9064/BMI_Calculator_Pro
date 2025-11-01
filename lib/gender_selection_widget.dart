import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatelessWidget {
  final int gender;
  final Function(int) onGenderSelected;

  const GenderSelectionWidget({
    super.key,
    required this.gender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () => onGenderSelected(0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: gender == 0 ? Colors.deepPurple : Colors.grey[800],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/male_logo.png',
                    height: 80.0,
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Male', style: TextStyle(fontSize: 18.0)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: GestureDetector(
            onTap: () => onGenderSelected(1),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: gender == 1 ? Colors.pink : Colors.grey[800],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/female_logo.png',
                    height: 80.0,
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Female', style: TextStyle(fontSize: 18.0)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
