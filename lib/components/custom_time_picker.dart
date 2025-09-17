import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final String labelText;

  const CustomTimePicker({
    Key? key,
    required this.selectedTime,
    required this.onTimeSelected,
    required this.labelText,
  }) : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: widget.selectedTime ?? TimeOfDay.now(),
            );
            if (selectedTime != null && selectedTime != widget.selectedTime) {
              widget.onTimeSelected(selectedTime);
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: widget.selectedTime != null
                    ? widget.selectedTime!.format(context)
                    : 'Select time',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
