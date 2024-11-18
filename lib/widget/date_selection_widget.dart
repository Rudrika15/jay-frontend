import 'package:flipcodeattendence/widget/custom_elevated_button.dart';
import 'package:flipcodeattendence/widget/text_form_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectionWidget extends StatelessWidget {
  final String? startDate;
  final String? endDate;
  final void Function(String startDate, String endDate) onPressed;

  const DateSelectionWidget({
    super.key,
    required this.onPressed,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final startDateController = TextEditingController(
        text: startDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final endDateController = TextEditingController(
        text: endDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()));

    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select date', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 12.0),
          const Text('From'),
          const SizedBox(height: 6.0),
          TextFormFieldWidget(
            controller: startDateController,
            readOnly: true,
            hintText: startDateController.text,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
                initialDate: DateTime.now(),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
              );
              if (pickedDate != null) {
                startDateController.text =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
              }
            },
          ),
          const SizedBox(height: 12.0),
          const Text('To'),
          const SizedBox(height: 6.0),
          TextFormFieldWidget(
            controller: endDateController,
            readOnly: true,
            hintText: endDateController.text,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                firstDate:
                    DateFormat('yyyy-MM-dd').parse(startDateController.text),
                lastDate: DateTime.now(),
                initialDate: DateTime.now(),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
              );
              if (pickedDate != null) {
                endDateController.text =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
              }
            },
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomElevatedButton(
                buttonText: 'Ok',
                onPressed: () =>
                    onPressed(startDateController.text, endDateController.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
