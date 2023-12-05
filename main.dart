import 'dart:math';
import 'package:flutter/material.dart';

import 'Controller/sqlite_db.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  TextEditingController nameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String gender = 'Male';
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Your Fullname'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Height in cm'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight in KG'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text(
              'BMI Value: $result',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Gender:'),
                SizedBox(width: 10),
                Radio(
                  value: 'Male',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
                Text('Male'),
                SizedBox(width: 10),
                Radio(
                  value: 'Female',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateBMI();
              },
              child: Text('Calculate BMI and Save'),
            ),
          ],
        )
      )
    );
  }

  void calculateBMI() {
    String name = nameController.text;
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);

    double bmi = weight / pow((height / 100),2);
    String bmiCategory = getBMICategory(bmi);

    setState(() async {

      Map<String, dynamic> bmiData = {
      result = '''
        BMI Calculation for $name:
        Height: $height cm
        Weight: $weight kg
        Gender: $gender
        BMI: $bmi
        BMI Category: $bmiCategory
      ''';
      } as Map<String, dynamic>;

      // Insert BMI data into SQLite database
      int id = await SQLiteDB().insert('bmi', bmiData);
      print('BMI data inserted with ID: $id');

    });
  }

  String getBMICategory(double bmi) {
    if (gender == 'Male') {
      if (bmi < 18.5) {
        return 'Underweight. Careful during strong wind!';
      } else if (bmi >= 18.5 && bmi <= 24.9) {
        return 'That’s ideal! Please maintain';
      } else if (bmi >= 25.0 && bmi <= 29.9) {
        return 'Overweight! Work out please';
      } else {
        return 'Whoa Obese! Dangerous mate!';
      }
    } else if (gender == 'Female') {
      if (bmi < 16) {
        return 'Underweight. Careful during strong wind!';
      } else if (bmi >= 16 && bmi < 22) {
        return 'That’s ideal! Please maintain';
      } else if (bmi >= 22 && bmi < 27) {
        return 'Overweight! Work out please';
      } else {
        return 'Whoa Obese! Dangerous mate!';
      }
    } else {
      return 'Invalid gender';
    }
  }
}




