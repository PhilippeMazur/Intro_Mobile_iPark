import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  final Function(DateTime) setState;
  const DateTimePicker({super.key, required this.setState});

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
              textController.text = DateFormat('dd-MM-yyy hh:mm').format(date);

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
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderRadius: BorderRadius.all(Radius.circular(90.0)),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 14,
          color: Color.fromARGB(255, 129, 129, 129),
        ),
        hintText: "datum",
        filled: true,
        fillColor: Color(0xfff2f2f3),
        isDense: false,
        contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        suffixIcon:
            Icon(Icons.calendar_today, color: Color(0xff212435), size: 25),
      ),
    );
  }
}
