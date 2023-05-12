import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'main.dart';

class DateTimePicker extends StatefulWidget {
  final Function(DateTime) setState;
  final InputDecoration decoration;
  const DateTimePicker(
      {super.key, required this.setState, required this.decoration});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: textController,
        obscureText: false,
        textAlign: TextAlign.left,
        maxLines: 1,
        readOnly: true,
        onTap: () async {
          await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: DateTime.now(),
            lastDate: DateTime(2100),
          ).then((DateTime? date) async {
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(DateTime.now()),
              );
              if (time != null) {
                DateTime sum = DateTime.fromMillisecondsSinceEpoch(
                    date.millisecondsSinceEpoch +
                        (time.hour * 3600000 + time.minute * 60000));
                logger.d(sum.minute);
                textController.text = DateFormat('dd-MM-y HH:mm').format(sum);

                widget.setState(sum);
              } else {
                widget.setState(date);
              }
            } else {
              widget.setState(DateTime.now());
            }
          });
        },
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 12,
          color: Color(0xff000000),
        ),
        decoration: widget.decoration);
  }
}
