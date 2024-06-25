import 'package:flutter/material.dart';

class DateTimePickerWidget extends StatefulWidget {
  final TextEditingController dateController;
  final DateTime? dateTime;

  DateTimePickerWidget({
    required this.dateController,
    this.dateTime,
  });

  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = widget.dateTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      controller: widget.dateController,
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: _dateTime,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          final pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_dateTime),
          );
          if (pickedTime != null) {
            setState(() {
              _dateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              widget.dateController.text = _dateTime.toString();
            });
          }
        }
      },
      decoration: InputDecoration(
        labelText: 'Select Date and Time',
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(Icons.calendar_today),
        prefixIconColor: Colors.white,
        border: OutlineInputBorder(),
      ),
    );
  }
}
