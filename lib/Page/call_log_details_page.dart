import 'dart:async';

import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/provider/call_status_provider.dart';
import 'package:flipcodeattendence/provider/login_provider.dart';
import 'package:flipcodeattendence/provider/team_provider.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../featuers/Admin/model/team_model.dart';
import '../provider/call_log_provider.dart';
import '../widget/call_log_action_widget.dart';
import '../widget/custom_elevated_button.dart';
import '../widget/custom_outlined_button.dart';
import '../widget/text_form_field_custom.dart';

class CallLogDetailsPage extends StatefulWidget {
  final String id;

  const CallLogDetailsPage({super.key, required this.id});

  @override
  State<CallLogDetailsPage> createState() => _CallLogDetailsPageState();
}

class _CallLogDetailsPageState extends State<CallLogDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final teamController = TextEditingController();
  final timeSlotController = TextEditingController();
  final chargeController = TextEditingController();
  final extraChargeController = TextEditingController();
  final dateController = TextEditingController();
  final partsController = TextEditingController();
  final paymentMethodController = TextEditingController();
  List<Members> selectedMembers = [];
  List<dynamic> selectedParts = [];
  late final isAdmin, isUser, isClient;
  late final CallLogProvider provider;
  late final CallStatusEnum callStatus;
  late double totalCharge;
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CallLogProvider>(context, listen: false);
    isAdmin = context.read<LoginProvider>().isAdmin;
    isUser = context.read<LoginProvider>().isUser;
    isClient = context.read<LoginProvider>().isClient;
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    callStatus = context.read<CallStatusProvider>().callStatusEnum;
    (callStatus == CallStatusEnum.allocated)
        ? provider.getAllocatedCallLogDetails(context: context, id: widget.id)
        : null;
    totalCharge = countTotal();
  }

  @override
  void dispose() {
    teamController.dispose();
    timeSlotController.dispose();
    chargeController.dispose();
    extraChargeController.dispose();
    dateController.dispose();
    partsController.dispose();
    paymentMethodController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  resetValues() {
    setState(() {
      teamController.clear();
      timeSlotController.clear();
      chargeController.clear();
      partsController.clear();
      selectedMembers.clear();
      selectedParts.clear();
      extraChargeController.clear();
      paymentMethodController.clear();
    });
  }

  double countTotal() {
    double initialCharge = 0.0;
    double extraCharge = 0.0;
    double totalCharge = 0.0;
    final callCharge = provider.staffCallLogData?.charge;
    if (callCharge != null) initialCharge = double.parse(callCharge);
    if (extraChargeController.text.trim().isNotEmpty)
      extraCharge = double.parse(extraChargeController.text.trim());
    totalCharge = (initialCharge + extraCharge).toPrecision(2);
    return totalCharge;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(CupertinoIcons.clear)),
        actions: [
          if (!isUser) ...[
            IconButton(
                onPressed: () async {
                  await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return CallLogActionWidget(
                          onTapWaiting: null,
                          onTapCancel: null,
                        );
                      });
                },
                icon: const Icon(Icons.more_vert))
          ]
        ],
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
                              provider.staffCallLogData?.call?.user?.name
                                      ?.capitalizeFirst ??
                                  '',
                              style: textTheme.titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12.0),
                          Row(
                            children: [
                              Icon(Icons.call),
                              const SizedBox(width: 6.0),
                              Text(
                                  '${provider.staffCallLogData?.call?.user?.phone}',
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
                                      provider.staffCallLogData?.call?.address
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
                                      provider.staffCallLogData?.call
                                              ?.description?.capitalizeFirst ??
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
                                  child: Text(
                                      provider.staffCallLogData?.date ?? '',
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
                                      provider.staffCallLogData?.slot
                                              ?.capitalizeFirst ??
                                          '',
                                      style: textTheme.bodyLarge)),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.currency_rupee),
                              const SizedBox(width: 6.0),
                              Expanded(
                                  child: Text(
                                      provider.staffCallLogData?.charge ?? '',
                                      style: textTheme.bodyLarge)),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                        ],
                        if (callStatus != CallStatusEnum.allocated &&
                            callStatus !=
                                CallStatusEnum.completed &&
                            isAdmin) ...[
                          TextFormFieldWidget(
                            labelText: 'Select time slot',
                            controller: timeSlotController,
                            readOnly: true,
                            suffixIcon: IconButton(
                                onPressed: () => setState(() {
                                      timeSlotController.clear();
                                    }),
                                icon: timeSlotController.text.trim().isEmpty
                                    ? Icon(
                                        Icons.arrow_drop_down_circle_outlined)
                                    : Icon(Icons.close)),
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
                                  if (selectedMembers.isNotEmpty) {
                                    setState(() {
                                      teamController.text =
                                          "${selectedMembers[0].user!.name}, ${selectedMembers[1].user!.name}";
                                    });
                                  }
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
                                lastDate: DateTime(2025),
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
                        if (isUser) ...[
                          const SizedBox(height: 16.0),
                          TextFormFieldWidget(
                            labelText: 'Select parts',
                            controller: partsController,
                            readOnly: true,
                            suffixIcon: (partsController.text.trim().isEmpty)
                                ? const Icon(
                                    Icons.arrow_drop_down_circle_outlined)
                                : IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () => setState(
                                        () => partsController.clear())),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please select parts';
                              } else {
                                return null;
                              }
                            },
                            onTap: () async {
                              await showModalBottomSheet(
                                      context: context,
                                      builder: (context) => PartsBottomSheet())
                                  .then((value) {
                                if (value != null) {
                                  this.selectedParts = value;
                                  if (selectedParts.isNotEmpty) {
                                    setState(() {
                                      partsController.text =
                                          "${selectedParts[0]['name']}";
                                    });
                                  }
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormFieldWidget(
                            labelText: 'Select payment method',
                            controller: paymentMethodController,
                            readOnly: true,
                            suffixIcon: (paymentMethodController.text
                                    .trim()
                                    .isEmpty)
                                ? Icon(Icons.arrow_drop_down_circle_outlined)
                                : IconButton(
                                    onPressed: () => setState(() {
                                          paymentMethodController.clear();
                                          extraChargeController.clear();
                                          totalCharge = countTotal();
                                        }),
                                    icon: Icon(Icons.close)),
                            validator: (value) {
                              return (value == null || value.trim().isEmpty)
                                  ? 'Please select payment method'
                                  : null;
                            },
                            onTap: () async {
                              final PaymentMethod? selectedPaymentMethod =
                                  await showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          PaymentMethodBottomSheet());
                              if (selectedPaymentMethod != null) {
                                paymentMethodController.text =
                                    selectedPaymentMethod.name.capitalizeFirst!;
                                extraChargeController.clear();
                                totalCharge = countTotal();
                                setState(() {});
                              }
                            },
                          ),
                          const SizedBox(height: 16.0),
                          if (paymentMethodController.text
                                  .trim()
                                  .toLowerCase() ==
                              PaymentMethod.cash.name.toLowerCase()) ...[
                            TextFormFieldWidget(
                              labelText: 'Enter extra charge',
                              controller: extraChargeController,
                              suffixIcon: Icon(Icons.currency_rupee),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) async {
                                if (debounce?.isActive ?? false)
                                  debounce?.cancel();
                                Timer(
                                    Duration(milliseconds: 1000),
                                    () => setState(
                                        () => totalCharge = countTotal()));
                              },
                            ),
                            const SizedBox(height: 16.0),
                          ],
                          if (paymentMethodController.text
                                  .trim()
                                  .toLowerCase() ==
                              PaymentMethod.QR.name.toLowerCase()) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isDismissible: false,
                                          builder: (context) => Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.qr_code_2,
                                                    size: 300,
                                                  ),
                                                  const SizedBox(height: 12.0),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('QR 1',
                                                          style: textTheme
                                                              .titleLarge!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12.0),
                                                ],
                                              ));
                                    },
                                    label: Text('QR 1'),
                                    icon: Icon(Icons.qr_code_2),
                                    style: OutlinedButton.styleFrom(
                                        fixedSize: const Size.fromHeight(56.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0))),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    label: Text('QR 2'),
                                    icon: Icon(Icons.qr_code_2),
                                    style: OutlinedButton.styleFrom(
                                        fixedSize: const Size.fromHeight(56.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0))),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                          ]
                        ],
                      ],
                    ),
                  ),
          );
        }),
      ),
      bottomNavigationBar: (callStatus !=
                  CallStatusEnum.allocated &&
          callStatus !=
                  CallStatusEnum.completed &&
              isAdmin)
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
          : (isUser)
              ? Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text('Total : ₹$totalCharge',
                              style: textTheme.titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold))),
                      const SizedBox(width: 12.0),
                      Expanded(
                          child: CustomElevatedButton(
                              buttonText: 'Complete call', onPressed: () {}))
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
                          Text(TimeSlot.values[index].name.capitalizeFirst!,
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
                                backgroundColor: AppColors.aPrimary,
                                deleteIconColor: AppColors.onPrimaryLight,
                                visualDensity: VisualDensity.compact,
                                label: Text(members[index].user!.name ?? '',
                                    style: TextStyle(
                                        color: AppColors.onPrimaryLight)),
                                onPressed: () {},
                                onDeleted: () {
                                  setState(() {
                                    members.removeAt(index);
                                  });
                                });
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
                                                if (members.length != 2) {
                                                  members.add(member!);
                                                }
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
                                onPressed: (members.isNotEmpty)
                                    ? () {
                                        setState(() {
                                          members.clear();
                                        });
                                      }
                                    : null),
                            const SizedBox(width: 16.0),
                            CustomElevatedButton(
                                buttonText: 'Ok',
                                onPressed:
                                    (members.isNotEmpty && members.length > 1)
                                        ? () {
                                            Navigator.pop(context, members);
                                          }
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

class PartsBottomSheet extends StatefulWidget {
  const PartsBottomSheet({super.key});

  @override
  State<PartsBottomSheet> createState() => _PartsBottomSheetState();
}

class _PartsBottomSheetState extends State<PartsBottomSheet> {
  List<dynamic> parts = [];

  @override
  void initState() {
    Provider.of<CallLogProvider>(context, listen: false).getParts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer<CallLogProvider>(builder: (context, provider, _) {
      return provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (provider.parts.isEmpty)
              ? const Center(child: Text('No parts found'))
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
                          Text('Select parts',
                              style: textTheme.titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: List.generate(parts.length, (index) {
                            return InputChip(
                                backgroundColor: AppColors.aPrimary,
                                deleteIconColor: AppColors.onPrimaryLight,
                                visualDensity: VisualDensity.compact,
                                label: Text(parts[index]['name'] ?? '',
                                    style: TextStyle(
                                        color: AppColors.onPrimaryLight)),
                                onPressed: () {},
                                onDeleted: () {
                                  setState(() {
                                    parts.removeAt(index);
                                  });
                                });
                          }),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: provider.parts.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final partItem = provider.parts[index];
                              return CheckboxListTile(
                                value: parts.any((element) =>
                                        element['id'] == partItem['id'])
                                    ? true
                                    : false,
                                onChanged: (value) {
                                  setState(() {
                                    if (parts.any((element) =>
                                        element['id'] == partItem['id'])) {
                                      parts.remove(partItem);
                                    } else {
                                      parts.add(partItem);
                                    }
                                  });
                                },
                                title: Text(partItem['name'] ?? ''),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
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
                                onPressed: (parts.isNotEmpty)
                                    ? () => setState(() => parts.clear())
                                    : null),
                            const SizedBox(width: 16.0),
                            CustomElevatedButton(
                                buttonText: 'Ok',
                                onPressed: (parts.isNotEmpty)
                                    ? () {
                                        Navigator.pop(context, parts);
                                      }
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

class PaymentMethodBottomSheet extends StatefulWidget {
  const PaymentMethodBottomSheet({super.key});

  @override
  State<PaymentMethodBottomSheet> createState() => _PaymentMethodBottomSheet();
}

class _PaymentMethodBottomSheet extends State<PaymentMethodBottomSheet> {
  PaymentMethod? selectedPaymentMethod;

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
              Text('Select payment method',
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
              itemCount: PaymentMethod.values.length,
              itemBuilder: (context, index) => InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = PaymentMethod.values[index];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: AppColors.aPrimary),
                          color: selectedPaymentMethod ==
                                  PaymentMethod.values[index]
                              ? AppColors.aPrimary
                              : AppColors.onPrimaryLight),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaymentMethod.values[index] == PaymentMethod.cash
                              ? Icon(Icons.currency_rupee,
                                  color: (selectedPaymentMethod ==
                                          PaymentMethod.cash)
                                      ? AppColors.onPrimaryLight
                                      : AppColors.aPrimary)
                              : Icon(Icons.qr_code,
                                  color: (selectedPaymentMethod ==
                                          PaymentMethod.QR)
                                      ? AppColors.onPrimaryLight
                                      : AppColors.aPrimary),
                          const SizedBox(width: 12.0),
                          Text(
                              PaymentMethod.values[index].name.capitalizeFirst!,
                              style: TextStyle(
                                  color: selectedPaymentMethod ==
                                          PaymentMethod.values[index]
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
                  onPressed: (selectedPaymentMethod != null)
                      ? () {
                          setState(() {
                            selectedPaymentMethod = null;
                          });
                        }
                      : null),
              const SizedBox(width: 16.0),
              CustomElevatedButton(
                  buttonText: 'Ok',
                  onPressed: (selectedPaymentMethod != null)
                      ? () {
                          Navigator.pop(context, selectedPaymentMethod);
                        }
                      : null),
            ],
          ),
        ],
      ),
    );
  }
}
