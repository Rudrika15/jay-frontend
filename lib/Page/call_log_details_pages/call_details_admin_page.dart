import 'dart:convert';

import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/provider/call_status_provider.dart';
import 'package:flipcodeattendence/provider/team_provider.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../featuers/Admin/model/team_model.dart';
import '../../provider/call_log_provider.dart';
import '../../widget/custom_elevated_button.dart';
import '../../widget/custom_outlined_button.dart';
import '../../widget/text_form_field_custom.dart';

class CallDetailsAdminPage extends StatefulWidget {
  final String id;

  const CallDetailsAdminPage({super.key, required this.id});

  @override
  State<CallDetailsAdminPage> createState() => _CallDetailsAdminPageState();
}

class _CallDetailsAdminPageState extends State<CallDetailsAdminPage> {
  final _formKey = GlobalKey<FormState>();
  final teamController = TextEditingController();
  final timeSlotController = TextEditingController();
  final chargeController = TextEditingController();
  final dateController = TextEditingController();
  List<Members> selectedMembers = [];
  late final CallLogProvider provider;
  late final CallStatusEnum callStatus;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CallLogProvider>(context, listen: false);
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    callStatus = context.read<CallStatusProvider>().callStatusEnum;
    (callStatus == CallStatusEnum.allocated ||
            callStatus == CallStatusEnum.completed)
        ? provider.getCallLogDetail(context: context, id: widget.id)
        : null;
  }

  @override
  void dispose() {
    teamController.dispose();
    timeSlotController.dispose();
    chargeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  resetValues() {
    setState(() {
      teamController.clear();
      timeSlotController.clear();
      chargeController.clear();
      selectedMembers.clear();
    });
  }

  String? getPartsName(dynamic partsList) {
    var parts = jsonDecode(partsList);
    var partsString = StringBuffer();
    if (parts == null || parts.isEmpty) {
      return null;
    } else {
      for (int i = 0; i < parts.length; i++) {
        partsString.write(parts[i]);
        if (i != (parts.length - 1)) {
          partsString.write(", ");
        }
      }
      return partsString.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(CupertinoIcons.clear)),
        // actions: [
        //   if(context.read<LoginProvider>().isAdmin)...[
        //     IconButton(
        //         onPressed: () async {
        //           await showModalBottomSheet(
        //               context: context,
        //               builder: (context) {
        //                 return CallLogActionWidget(
        //                   onTapWaiting: null,
        //                   onTapCancel: null,
        //                 );
        //               });
        //         },
        //         icon: const Icon(Icons.more_vert))
        //   ],
        // ],
      ),
      body: SingleChildScrollView(
        child: Consumer<CallLogProvider>(builder: (context, provider, _) {
          return Form(
            key: _formKey,
            child: (provider.isLoading)
                ? const LinearProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (callStatus == CallStatusEnum.allocated ||
                            callStatus == CallStatusEnum.completed) ...[
                          Text(
                              provider.callLog?.call?.user?.name
                                      ?.capitalizeFirst ??
                                  '',
                              style: textTheme.titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12.0),
                          Row(
                            children: [
                              Icon(Icons.call),
                              const SizedBox(width: 6.0),
                              Text('${provider.callLog?.call?.user?.phone}',
                                  style: textTheme.bodyLarge),
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
                                      provider.callLog?.call?.address
                                              ?.capitalizeFirst ??
                                          'N/A',
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
                                      provider.callLog?.call?.description
                                              ?.capitalizeFirst ??
                                          '',
                                      style: textTheme.bodyLarge)),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.date_range),
                              const SizedBox(width: 6.0),
                              Expanded(
                                  child: Text(provider.callLog?.date ?? '',
                                      style: textTheme.bodyLarge)),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.watch_later_outlined),
                              const SizedBox(width: 6.0),
                              Expanded(
                                  child: Text(
                                      provider.callLog?.slot?.capitalizeFirst ??
                                          '',
                                      style: textTheme.bodyLarge)),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          if (provider.callLog?.call?.totalCharge == null) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.currency_rupee),
                                const SizedBox(width: 6.0),
                                Expanded(
                                    child: Text(provider.callLog?.charge ?? '',
                                        style: textTheme.bodyLarge)),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                          ] else ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.currency_rupee),
                                const SizedBox(width: 6.0),
                                Expanded(
                                    child: Text(
                                        provider.callLog?.call?.totalCharge
                                                .toString() ??
                                            '',
                                        style: textTheme.bodyLarge)),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                          ],
                          if (callStatus == CallStatusEnum.completed) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Payment method :',
                                    style: textTheme.bodyLarge),
                                const SizedBox(width: 6.0),
                                Expanded(
                                    child: Text(
                                        provider.callLog?.call?.paymentMethod ??
                                            '',
                                        style: textTheme.bodyLarge)),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Payment status :',
                                    style: textTheme.bodyLarge),
                                const SizedBox(width: 6.0),
                                Expanded(
                                    child: Text(
                                        ((provider.callLog?.call?.paymentMethod
                                                        ?.trim()
                                                        .toLowerCase() ??
                                                    '') ==
                                                'debit')
                                            ? 'Unsettled'
                                            : 'Settled',
                                        style: textTheme.bodyLarge)),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            if (provider.callLog?.call?.partName != null) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Parts :', style: textTheme.bodyLarge),
                                  const SizedBox(width: 6.0),
                                  Expanded(
                                      child: Text(
                                          getPartsName(provider
                                                  .callLog?.call?.partName) ??
                                              '',
                                          style: textTheme.bodyLarge)),
                                ],
                              ),
                            ]
                          ]
                        ],
                        if (callStatus != CallStatusEnum.allocated &&
                            callStatus != CallStatusEnum.completed) ...[
                          TextFormFieldWidget(
                            labelText: 'Select time slot',
                            controller: timeSlotController,
                            readOnly: true,
                            suffixIcon: timeSlotController.text.trim().isEmpty
                                ? const Icon(
                                    Icons.arrow_drop_down_circle_outlined)
                                : IconButton(
                                    onPressed: () => setState(() {
                                          timeSlotController.clear();
                                        }),
                                    icon: Icon(Icons.close)),
                            validator: (value) {
                              return (value == null || value.trim().isEmpty)
                                  ? 'Please select time slot'
                                  : null;
                            },
                            onTap: () async {
                              final TimeSlot? timeSlot =
                                  await showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          TimeSlotBottomSheet());
                              if (timeSlot != null) {
                                timeSlotController.text =
                                    timeSlot.name.capitalizeFirst!;
                                setState(() {});
                              }
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormFieldWidget(
                            labelText: 'Select members',
                            controller: teamController,
                            readOnly: true,
                            suffixIcon: (teamController.text.trim().isEmpty)
                                ? const Icon(
                                    Icons.arrow_drop_down_circle_outlined)
                                : IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        teamController.clear();
                                      });
                                    }),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please select team';
                              } else {
                                return null;
                              }
                            },
                            onTap: () async {
                              await showModalBottomSheet(
                                      context: context,
                                      builder: (context) => TeamBottomSheet())
                                  .then((value) {
                                if (value != null) {
                                  this.selectedMembers = value;
                                  final stringBuffer = StringBuffer();
                                  for (var member in selectedMembers) {
                                    stringBuffer.write(member.user!.name);
                                    if (selectedMembers.length > 1)
                                      stringBuffer.write(",");
                                  }
                                  setState(() {
                                    teamController.text =
                                        stringBuffer.toString();
                                  });
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormFieldWidget(
                            labelText: 'Enter charge',
                            controller: chargeController,
                            suffixIcon: Icon(Icons.currency_rupee),
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
                              final initialDate = dateController.text.isEmpty
                                  ? DateTime.now()
                                  : DateFormat('dd-MM-yyyy')
                                      .parse(dateController.text);
                              final pickedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)),
                                initialDate: initialDate,
                                currentDate: DateTime.now(),
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                              );
                              if (pickedDate != null) {
                                dateController.text =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
          );
        }),
      ),
      bottomNavigationBar: (callStatus != CallStatusEnum.allocated &&
              callStatus != CallStatusEnum.completed)
          ? Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                      child: CustomElevatedButton(
                          buttonText: 'Allocate',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Provider.of<CallLogProvider>(context,
                                      listen: false)
                                  .assignTask(
                                      context: context,
                                      timeSlot: timeSlotController.text,
                                      members: selectedMembers,
                                      charge: chargeController.text,
                                      date: dateController.text,
                                      callId: widget.id)
                                  .then((value) {
                                if (value) {
                                  resetValues();
                                  Navigator.pop(context, true);
                                }
                              });
                            }
                          }))
                ],
              ),
            )
          : const SizedBox.shrink(),
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
              itemCount: TimeSlot.values.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 2.5),
              itemBuilder: (context, index) => InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () => setState(
                        () => selectedTimeSlot = TimeSlot.values[index]),
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: AppColors.aPrimary),
                          color: selectedTimeSlot == TimeSlot.values[index]
                              ? AppColors.aPrimary
                              : AppColors.onPrimaryLight),
                      child: Text(TimeSlot.values[index].name.capitalizeFirst!,
                          style: TextStyle(
                              color: selectedTimeSlot == TimeSlot.values[index]
                                  ? AppColors.onPrimaryLight
                                  : AppColors.aPrimary)),
                    ),
                  )),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomOutlinedButton(
                  buttonText: 'Clear',
                  onPressed: (selectedTimeSlot != null)
                      ? () => setState(() => selectedTimeSlot = null)
                      : null),
              const SizedBox(width: 16.0),
              CustomElevatedButton(
                  buttonText: 'Ok',
                  onPressed: (selectedTimeSlot != null)
                      ? () => Navigator.pop(context, selectedTimeSlot)
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
  List<Members> members = [];

  @override
  void initState() {
    Provider.of<TeamProvider>(context, listen: false).getTeams(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer<TeamProvider>(builder: (context, provider, _) {
      return provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (provider.teamModel?.data?.isEmpty ?? true)
              ? const Center(child: Text('No data found'))
              : Container(
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
                          children: List.generate(members.length, (index) {
                            return InputChip(
                                shape: StadiumBorder(),
                                avatar: Icon(Icons.person,
                                    color: AppColors.onPrimaryLight),
                                side: BorderSide(color: Colors.transparent),
                                backgroundColor: AppColors.aPrimary,
                                deleteIconColor: AppColors.onPrimaryLight,
                                visualDensity: VisualDensity.compact,
                                label: Text(members[index].user!.name ?? '',
                                    style: TextStyle(
                                        color: AppColors.onPrimaryLight)),
                                onPressed: () {},
                                onDeleted: () =>
                                    setState(() => members.removeAt(index)));
                          }),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: provider.teamModel?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final team = provider.teamModel?.data?[index];
                              return ExpansionTile(
                                title: Text(team?.name ?? ''),
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: provider.teamModel
                                              ?.data?[index].members?.length ??
                                          0,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, innerIndex) {
                                        final member = provider.teamModel
                                            ?.data?[index].members?[innerIndex];
                                        return CheckboxListTile(
                                          value: members.any((element) =>
                                                  element.userId ==
                                                  member!.userId)
                                              ? true
                                              : false,
                                          onChanged: (value) {
                                            setState(() {
                                              if (members.any((element) =>
                                                  element.userId ==
                                                  member!.userId)) {
                                                members.remove(member!);
                                              } else {
                                                members.add(member!);
                                              }
                                              // if (selectedId
                                              //     .contains(member?.userId)) {
                                              //   selectedId.remove(member?.userId);
                                              // } else {
                                              //   if (selectedId.length !=
                                              //       2) {
                                              //     selectedId.add(member?.userId ?? '');
                                              //   }
                                              // }
                                            });
                                          },
                                          title: Text(member?.user?.name ?? ''),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
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
                                onPressed: members.isNotEmpty
                                    ? () => setState(() => members.clear())
                                    : null),
                            const SizedBox(width: 16.0),
                            CustomElevatedButton(
                                buttonText: 'Ok',
                                onPressed: members.isNotEmpty
                                    ? () => Navigator.pop(context, members)
                                    : null),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
    });
  }
}
