import 'package:flutter/material.dart';

class CustomRating extends StatelessWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;
  final String labelText;

  const CustomRating({
    super.key,
    required this.initialRating,
    required this.onRatingChanged,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List<Widget>.generate(5, (index) {
            return IconButton(
              icon: Icon(
                Icons.star,
                color: index < initialRating ? Colors.orange : Colors.grey,
              ),
              onPressed: () {
                onRatingChanged(index + 1.0);
              },
            );
          }),
        ),
      ],
    );
  }
}
