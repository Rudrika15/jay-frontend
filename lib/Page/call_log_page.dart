import 'package:flipcodeattendence/Page/call_log_details_page.dart';
import 'package:flipcodeattendence/Page/create_call_page.dart';
import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/helper/user_role_helper.dart';
import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/call_log_provider.dart';
import '../provider/login_provider.dart';
import '../theme/app_colors.dart';
import '../widget/text_form_field_custom.dart';

class CallLogPage extends StatefulWidget {
  const CallLogPage({super.key});

  @override
  State<CallLogPage> createState() => _CallLogPageState();
}

class _CallLogPageState extends State<CallLogPage> with NavigatorMixin {
  String? userRole;
  bool isUser = false;
  TimePeriod _selectedChip = TimePeriod.values.first;
  CallStatusEnum _selectedCallType = CallStatusEnum.values.first;
  final dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<LoginProvider>(context, listen: false)
        .getUserRole()
        .then((value) {
      userRole = value;
      setState(() {
        isUser = isNormalUser(userRole);
      });
    });
    Provider.of<CallLogProvider>(context, listen: false)
        .getCallLogs(context: context);
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    ActionChip(
                      padding: EdgeInsets.zero,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedChip.name),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      onPressed: () async {
                        await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: false,
                            builder: (context) {
                              return RangeRadioListTileWidget(
                                  initialValue: _selectedChip);
                            }).then((value) {
                          setState(() {
                            if (value != null) {
                              _selectedChip = value;
                            }
                          });
                        });
                      },
                    ),
                    ActionChip(
                      padding: EdgeInsets.zero,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedCallType.name),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      onPressed: () async {
                        await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: false,
                            builder: (context) {
                              return CallTypeRadioListTileWidget(
                                  initialValue: _selectedCallType);
                            }).then((value) {
                          setState(() {
                            if (value != null) {
                              _selectedCallType = value;
                              Provider.of<CallLogProvider>(context,
                                      listen: false)
                                  .getCallLogs(
                                      context: context,
                                      status: _selectedCallType);
                            }
                          });
                        });
                      },
                    ),
                    InputChip(
                      padding: EdgeInsets.zero,
                      deleteIcon: Icon(
                          dateController.text.isEmpty
                              ? Icons.calendar_month
                              : Icons.close,
                          size: 18),
                      label: Text(dateController.text.isNotEmpty
                          ? dateController.text
                          : 'Date'),
                      onPressed: () async {
                        final initialDate = dateController.text.isEmpty
                            ? DateTime.now()
                            : DateFormat('dd-MM-yyyy')
                                .parse(dateController.text);
                        final pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2025),
                          initialDate: initialDate,
                          currentDate: DateTime.now(),
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                        );
                        if (pickedDate != null) {
                          setState(() {
                            dateController.text =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                          });
                        }
                      },
                      onDeleted: () {
                        setState(() {
                          dateController.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              Expanded(
                child:
                    Consumer<CallLogProvider>(builder: (context, provider, _) {
                  return provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : (provider.callLogsModel?.data?.isEmpty ?? false)
                          ? const Center(child: Text('No call logs found'))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  provider.callLogsModel?.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                final callLog =
                                    provider.callLogsModel?.data?[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                CallLogDetailsPage(
                                                    id: callLog!.id
                                                        .toString())))
                                        .then((value) {
                                          if(value == true) {
                                            Provider.of<CallLogProvider>(context, listen: false)
                                                .getCallLogs(context: context);
                                          }
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 16.0),
                                    padding: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                            color: AppColors.aPrimary)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(callLog?.user?.name ?? '',
                                            style: textTheme.titleLarge!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          children: [
                                            Icon(Icons.call),
                                            const SizedBox(width: 6.0),
                                            Text(callLog?.user?.phone ?? '',
                                                style: textTheme.bodyLarge),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.location_on_outlined),
                                            const SizedBox(width: 6.0),
                                            Expanded(
                                                child: Text(
                                                    callLog?.address ?? 'N/A',
                                                    style:
                                                        textTheme.bodyLarge)),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.message_outlined),
                                            const SizedBox(width: 6.0),
                                            Expanded(
                                                child: Text(
                                                    callLog?.description ?? '',
                                                    style:
                                                        textTheme.bodyLarge)),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.date_range),
                                            const SizedBox(width: 6.0),
                                            Expanded(
                                                child: Text(callLog?.date ?? '',
                                                    style:
                                                        textTheme.bodyLarge)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                }),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      floatingActionButton: (!isUser)
          ? FloatingActionButton(
              onPressed: () {
                push(context, CreateCallPage());
              },
              child: const Icon(Icons.add),
            )
          : const SizedBox.shrink(),
    );
  }
}

class RangeRadioListTileWidget extends StatefulWidget {
  final TimePeriod initialValue;

  const RangeRadioListTileWidget({super.key, required this.initialValue});

  @override
  State<RangeRadioListTileWidget> createState() =>
      _RangeRadioListTileWidgetState();
}

class _RangeRadioListTileWidgetState extends State<RangeRadioListTileWidget> {
  late TimePeriod _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Range',
                  style: textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close)),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: TimePeriod.values.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                value: TimePeriod.values[index],
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = TimePeriod.values[index];
                  });
                },
                title: Text(TimePeriod.values[index].name),
              );
            }),
        const SizedBox(height: 12.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomElevatedButton(
                  buttonText: 'Apply',
                  onPressed: () {
                    Navigator.pop(context, _selectedValue);
                  })
            ],
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}

class CallTypeRadioListTileWidget extends StatefulWidget {
  final CallStatusEnum? initialValue;

  const CallTypeRadioListTileWidget({super.key, required this.initialValue});

  @override
  State<CallTypeRadioListTileWidget> createState() =>
      _CallTypeRadioListTileWidget();
}

class _CallTypeRadioListTileWidget extends State<CallTypeRadioListTileWidget> {
  CallStatusEnum? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Call Type',
                  style: textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close)),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: CallStatusEnum.values.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                value: CallStatusEnum.values[index],
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = CallStatusEnum.values[index];
                  });
                },
                title: Text(CallStatusEnum.values[index].name),
              );
            }),
        const SizedBox(height: 12.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomElevatedButton(
                  buttonText: 'Apply',
                  onPressed: () {
                    Navigator.pop(context, _selectedValue);
                  })
            ],
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
