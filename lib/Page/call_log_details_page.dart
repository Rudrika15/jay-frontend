import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flipcodeattendence/widget/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../widget/custom_elevated_button.dart';
import '../widget/custom_outlined_button.dart';
import '../widget/text_form_field_custom.dart';

class CallLogDetailsPage extends StatefulWidget {
  const CallLogDetailsPage({super.key});

  @override
  State<CallLogDetailsPage> createState() => _CallLogDetailsPageState();
}

class _CallLogDetailsPageState extends State<CallLogDetailsPage> {
  final teamController = TextEditingController();
  final timeSlotController = TextEditingController();
  final chargeController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    chargeController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jigar parmar',
                style: textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Icon(Icons.call),
                const SizedBox(width: 6.0),
                Text('+91 1234567890', style: textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_outlined),
                const SizedBox(width: 6.0),
                Expanded(
                    child: Text(
                        'Yoginagar society, Dalmil road, Surendranagar, 363001, Gujarat',
                        style: textTheme.bodyLarge)),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.message_outlined),
                const SizedBox(width: 6.0),
                Expanded(
                    child: Text(
                        'Office speaker is not working. Please fix as soon as possible.',
                        style: textTheme.bodyLarge)),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.date_range),
                const SizedBox(width: 6.0),
                Expanded(child: Text('19-11-2024', style: textTheme.bodyLarge)),
              ],
            ),
            const SizedBox(height: 24.0),
            TextFormFieldWidget(
              labelText: 'Select time slot',
              controller: timeSlotController,
              readOnly: true,
              suffixIcon: const Icon(Icons.arrow_drop_down_circle_outlined),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please select time slot';
                } else {
                  return null;
                }
              },
              onTap: () async {
                final TimeSlot? timeSlot = await showModalBottomSheet(
                    context: context,
                    builder: (context) => TimeSlotBottomSheet());
                if(timeSlot != null) {
                  timeSlotController.text = timeSlot.name;
                }
              },
            ),
            const SizedBox(height: 16.0),
            TextFormFieldWidget(
              labelText: 'Select team',
              controller: teamController,
              readOnly: true,
              suffixIcon: const Icon(Icons.arrow_drop_down_circle_outlined),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please select team';
                } else {
                  return null;
                }
              },
              onTap: () async {
                await showModalBottomSheet(
                    context: context, builder: (context) => TeamBottomSheet());
              },
            ),
            const SizedBox(height: 16.0),
            TextFormFieldWidget(
              labelText: 'Enter charge',
              controller: chargeController,
              suffixIcon: const Icon(Icons.currency_rupee),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter charge';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 16.0),
            TextFormFieldWidget(
              labelText: 'Select date',
              controller: dateController,
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_month),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please select date';
                } else {
                  return null;
                }
              },
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2025),
                  initialDate: DateTime.now(),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                );
                if (pickedDate != null) {
                  dateController.text =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Row(
          children: [
            Expanded(child: CustomOutlinedButton(buttonText: 'Cancel', onPressed: (){})),
            const SizedBox(width: 16.0),
            Expanded(child: CustomElevatedButton(buttonText: 'Submit', onPressed: (){}))

          ],
        ),
      ),
    );
  }
}

class TimeSlotBottomSheet extends StatefulWidget {
  const TimeSlotBottomSheet({super.key});

  @override
  State<TimeSlotBottomSheet> createState() => _TimeSlotBottomSheetState();
}

class _TimeSlotBottomSheetState extends State<TimeSlotBottomSheet> {
  TimeSlot? selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select time slot',
                  style: textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12.0),
          GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 2.5),
              itemCount: TimeSlot.values.length,
              itemBuilder: (context, index) => InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () {
                      setState(() {
                        selectedTimeSlot = TimeSlot.values[index];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: AppColors.aPrimary),
                          color: selectedTimeSlot == TimeSlot.values[index]
                              ? AppColors.aPrimary
                              : AppColors.onPrimaryLight),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TimeSlot.values[index].name,
                              style: TextStyle(
                                  color:
                                      selectedTimeSlot == TimeSlot.values[index]
                                          ? AppColors.onPrimaryLight
                                          : AppColors.aPrimary)),
                        ],
                      ),
                    ),
                  )),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomOutlinedButton(
                  buttonText: 'Clear',
                  onPressed: (selectedTimeSlot != null)
                      ? () {
                          setState(() {
                            selectedTimeSlot = null;
                          });
                        }
                      : null),
              const SizedBox(width: 16.0),
              CustomElevatedButton(
                  buttonText: 'Ok',
                  onPressed: (selectedTimeSlot != null)
                      ? () {
                          Navigator.pop(context, selectedTimeSlot);
                        }
                      : null),
            ],
          ),
        ],
      ),
    );
  }
}

class TeamBottomSheet extends StatefulWidget {
  const TeamBottomSheet({super.key});

  @override
  State<TeamBottomSheet> createState() => _TeamBottomSheetState();
}

class _TeamBottomSheetState extends State<TeamBottomSheet> {
  List<int> selectedIndices = [];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select team members',
                  style: textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              children: List.generate(selectedIndices.length, (index) {
                return InputChip(
                    backgroundColor: AppColors.aPrimary,
                    deleteIconColor: AppColors.onPrimaryLight,
                    visualDensity: VisualDensity.compact,
                    label: Text('User ${index + 1}',
                        style: TextStyle(color: AppColors.onPrimaryLight)),
                    onPressed: () {},
                    onDeleted: () {
                      setState(() {
                        selectedIndices.remove(index);
                      });
                    });
              }),
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text('Team ${index + 1}'),
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              value: (selectedIndices.contains(index)
                                  ? true
                                  : false),
                              onChanged: (value) {
                                setState(() {
                                  if (selectedIndices.contains(index)) {
                                    selectedIndices.remove(index);
                                  } else {
                                    if(selectedIndices.length != 2) {
                                      selectedIndices.add(index);
                                    }
                                  }
                                });
                              },
                              title: Text('User ${index + 1}'),
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          }),
                    ],
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomOutlinedButton(
                    buttonText: 'Clear all',
                    onPressed: (selectedIndices.isNotEmpty)
                        ? () {
                            setState(() {
                              selectedIndices.clear();
                            });
                          }
                        : null),
                const SizedBox(width: 16.0),
                CustomElevatedButton(
                    buttonText: 'Ok',
                    onPressed: (selectedIndices.isNotEmpty &&
                            selectedIndices.length > 1)
                        ? () {}
                        : null),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
