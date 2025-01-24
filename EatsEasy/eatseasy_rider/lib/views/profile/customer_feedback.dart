import 'package:flutter/material.dart';



import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../constants/constants.dart';
import '../../models/driver_response.dart';

class CustomerFeedback extends StatefulWidget {
  const CustomerFeedback({super.key, required this.driverController});

  final Driver? driverController;
  @override
  _CustomerFeedbackState createState() => _CustomerFeedbackState();
}

class _CustomerFeedbackState extends State<CustomerFeedback> {

  // You can define any state variables here, like user ratings or feedback
  double excellentRating = 0.7;
  double goodRating = 0.2;
  double averageRating = 0.1;
  double poorRating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*title: Text('Customer Feedback'),*/
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Overall Rating',
              style: TextStyle(fontSize: 34),
            ),
            SizedBox(height: 5),
            Text(
              widget.driverController!.rating.toString(),
              style: TextStyle(fontSize: 67, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
          RatingBarIndicator(
            rating: double.tryParse(widget.driverController!.rating.toString()) ?? 0.0,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 55.0,
            direction: Axis.horizontal,
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 5),
                //Text('Based on 20 reviews'),
              ],
            ),/*
            SizedBox(height: 20),
            RatingBar(
              label: 'Excellent',
              value: excellentRating,
              color: Colors.green,
              onChanged: (value) {
                setState(() {
                  excellentRating = value;
                });
              },
            ),
            RatingBar(
              label: 'Good',
              value: goodRating,
              color: Colors.lightGreen,
              onChanged: (value) {
                setState(() {
                  goodRating = value;
                });
              },
            ),
            RatingBar(
              label: 'Average',
              value: averageRating,
              color: Colors.orange,
              onChanged: (value) {
                setState(() {
                  averageRating = value;
                });
              },
            ),
            RatingBar(
              label: 'Poor',
              value: poorRating,
              color: Colors.red,
              onChanged: (value) {
                setState(() {
                  poorRating = value;
                });
              },
            ),
            SizedBox(height: 20),*/
          ],
        ),
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;

  RatingBar({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label),
          SizedBox(width: 10),
          Expanded(
            child: Slider(
              value: value,
              min: 0,
              max: 1,
              onChanged: onChanged,
              activeColor: color,
              inactiveColor: color.withOpacity(0.3),
            ),
          ),
          Text(value.toStringAsFixed(2)),
        ],
      ),
    );
  }
}

