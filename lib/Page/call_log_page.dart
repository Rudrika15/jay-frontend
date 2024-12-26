import 'package:flipcodeattendence/Page/create_call_page.dart';
import 'package:flipcodeattendence/helper/api_helper.dart';
import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/models/call_logs_model.dart';
import 'package:flipcodeattendence/provider/call_status_provider.dart';
import 'package:flipcodeattendence/widget/call_log_action_widget.dart';
import 'package:flipcodeattendence/widget/common_widgets.dart';
import 'package:flipcodeattendence/widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../featuers/User/model/staff_allocated_call_model.dart';
import '../featuers/Client/model/client_call_log_model.dart' as ClientModel;
import '../provider/call_log_provider.dart';
import '../provider/login_provider.dart';
import '../theme/app_colors.dart';
import 'call_log_details_pages/call_details_admin_page.dart';
import 'call_log_details_pages/call_details_user_page.dart';

class CallLogPage extends StatefulWidget {
  const CallLogPage({super.key});

  @override
  State<CallLogPage> createState() => _CallLogPageState();
}

class _CallLogPageState extends State<CallLogPage> with NavigatorMixin {
  bool _isFabVisible = true;
  late ScrollController _scrollController;
  final dateController = TextEditingController();
  late final isAdmin, isUser, isClient;
  late final CallLogProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CallLogProvider>(context, listen: false);
    isAdmin = context.read<LoginProvider>().isAdmin;
    isUser = context.read<LoginProvider>().isUser;
    isClient = context.read<LoginProvider>().isClient;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    getCallLogs();
  }

  @override
  void dispose() {
    dateController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isFabVisible) setState(() => _isFabVisible = false);
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isFabVisible) setState(() => _isFabVisible = true);
    }
  }

  Future<void> getCallLogs() async {
    isAdmin
        ? provider.getCallLogs(
            context: context,
            status: context.read<CallStatusProvider>().callStatusEnum)
        : isUser
            ? provider.getStaffCallLogs(
                context: context, date: dateController.text)
            : provider.getClientsCallLogs(context,
                date: dateController.text,
                status: context.read<CallStatusProvider>().callStatusEnum);
  }

  Future<void> changeStatus(
      {required String id, required CallStatusEnum status}) async {
    provider
        .changeStatus(id: id, context: context, status: status)
        .then((value) {
      if (value) getCallLogs();
    });
  }

  void showSnackBar(BuildContext context, String message) {
    CommonWidgets.customSnackBar(context: context, title: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    InputChip(
                        tooltip: 'Date',
                        padding: EdgeInsets.zero,
                        shape: StadiumBorder(),
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
                              : DateFormat('yyyy-MM-dd')
                                  .parse(dateController.text);
                          final pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2025),
                            initialDate: initialDate,
                            currentDate: DateTime.now(),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          );
                          if (pickedDate != null)
                            setState(() {
                              dateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              getCallLogs();
                            });
                        },
                        onDeleted: () {
                          if (dateController.text.trim().isNotEmpty) {
                            setState(() {
                              dateController.clear();
                              getCallLogs();
                            });
                          }
                        }),
                    if (!isUser) ...[
                      ActionChip(
                        shape: StadiumBorder(),
                        tooltip: 'Status',
                        padding: EdgeInsets.zero,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(context
                                .watch<CallStatusProvider>()
                                .callStatusEnum
                                .name
                                .capitalizeFirst!),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                        onPressed: () async {
                          await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return CallTypeRadioListTileWidget();
                              }).then((value) {
                            if (value == true) getCallLogs();
                          });
                        },
                      )
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              Expanded(
                child:
                    Consumer<CallLogProvider>(builder: (context, provider, _) {
                  return RefreshIndicator(
                    onRefresh: () => getCallLogs(),
                    child: Column(
                      children: [
                        if (provider.isLoading) ...[
                          Expanded(
                              child: const Center(
                                  child: CircularProgressIndicator()))
                        ] else ...[
                          if (isUser) ...[
                            if (provider.allocatedStaffCallLogList.isEmpty) ...[
                              Expanded(
                                  child: const Center(
                                      child: Text('No call logs found')))
                            ] else ...[
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  itemCount:
                                      provider.allocatedStaffCallLogList.length,
                                  itemBuilder: (context, index) {
                                    final callLog = provider
                                        .allocatedStaffCallLogList[index];
                                    return InkWell(
                                      onTap: () {
                                        final value = Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    CallDetailsUserPage(
                                                        id: callLog.call!.id
                                                            .toString())))
                                            .then((value) {
                                          if (value == true) {
                                            getCallLogs();
                                            showSnackBar(context,
                                                'Call log completed successfully');
                                          }
                                          ;
                                        });
                                      },
                                      child: StaffCallLogDetails(
                                          callLog: callLog,
                                          onTapComplete: () {
                                            pop(context);
                                            changeStatus(
                                                id: callLog.id.toString(),
                                                status:
                                                    CallStatusEnum.completed);
                                          },
                                          onPressImageChip: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => Dialog(
                                                      child: Container(
                                                        height: 300,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    "${ApiHelper.imageBaseUrl + callLog.call!.photo!}"),
                                                                fit: BoxFit
                                                                    .cover)),
                                                      ),
                                                    ));
                                          }),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(color: AppColors.grey),
                                ),
                              )
                            ]
                          ] else if (isAdmin) ...[
                            if (provider.callLogsModel?.data?.isEmpty ??
                                false) ...[
                              Expanded(
                                  child: const Center(
                                      child: Text('No call logs found')))
                            ] else ...[
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  itemCount:
                                      provider.callLogsModel?.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final callLog =
                                        provider.callLogsModel?.data?[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    CallDetailsAdminPage(
                                                        id: callLog!.id
                                                            .toString())))
                                            .then((value) {
                                          if (value == true) getCallLogs();
                                        });
                                      },
                                      child: CallLogDetails(
                                        callLog: callLog,
                                        onTapCancel: () {
                                          pop(context);
                                          changeStatus(
                                              id: callLog?.id.toString() ?? '',
                                              status: CallStatusEnum.cancelled);
                                        },
                                        onTapWaiting: () {
                                          pop(context);
                                          changeStatus(
                                              id: callLog?.id.toString() ?? '',
                                              status: CallStatusEnum.waiting);
                                        },
                                        onTapComplete: () {
                                          pop(context);
                                          changeStatus(
                                              id: callLog?.id.toString() ?? '',
                                              status: CallStatusEnum.completed);
                                        },
                                        onTapPending: () {
                                          pop(context);
                                          changeStatus(
                                              id: callLog?.id.toString() ?? '',
                                              status: CallStatusEnum.pending);
                                        },
                                        onPressImageChip: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                    child: Container(
                                                      height: 300,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  "${ApiHelper.imageBaseUrl + callLog!.photo!}"),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                  ));
                                        },
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(color: AppColors.grey),
                                ),
                              )
                            ]
                          ] else ...[
                            if (provider.clientCallLogModel?.data?.isEmpty ??
                                false) ...[
                              Expanded(
                                  child: const Center(
                                      child: Text('No call logs found')))
                            ] else ...[
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  itemCount: provider
                                          .clientCallLogModel?.data?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    final callLog = provider
                                        .clientCallLogModel?.data?[index];
                                    final bool canTap = (context
                                                .read<CallStatusProvider>()
                                                .callStatusEnum ==
                                            CallStatusEnum.allocated ||
                                        context
                                                .read<CallStatusProvider>()
                                                .callStatusEnum ==
                                            CallStatusEnum.completed);
                                    return InkWell(
                                      onTap: canTap
                                          ? () {
                                              push(
                                                  context,
                                                  CallDetailsAdminPage(
                                                      id: callLog!.id
                                                          .toString()));
                                            }
                                          : null,
                                      child: ClientCallDetails(
                                        callLog: callLog,
                                        onTapCancel: () {
                                          pop(context);
                                          changeStatus(
                                              id: callLog?.id.toString() ?? '',
                                              status: CallStatusEnum.cancelled);
                                        },
                                        onTapComplete: () {
                                          pop(context);
                                          changeStatus(
                                              id: callLog?.id.toString() ?? '',
                                              status: CallStatusEnum.completed);
                                        },
                                        onPressImageChip: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                    child: Container(
                                                      height: 300,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  "${ApiHelper.imageBaseUrl + callLog!.photo!}"),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                  ));
                                        },
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(color: AppColors.grey),
                                ),
                              )
                            ]
                          ]
                        ]
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        // Hide FAB while scrolling up and Show FAB while scrolling down
        // Only staff and admin can create call
        floatingActionButton: isUser
            ? const SizedBox.shrink()
            : AnimatedOpacity(
                opacity: _isFabVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 350),
                child: IgnorePointer(
                  ignoring: !_isFabVisible,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => CreateCallPage()))
                          .then((value) {
                        if (value == true) getCallLogs();
                      });
                    },
                    child: const Icon(Icons.add),
                    tooltip: 'Create call',
                  ),
                ),
              ));
  }
}

class CallTypeRadioListTileWidget extends StatefulWidget {
  const CallTypeRadioListTileWidget({super.key});

  @override
  State<CallTypeRadioListTileWidget> createState() =>
      _CallTypeRadioListTileWidget();
}

class _CallTypeRadioListTileWidget extends State<CallTypeRadioListTileWidget> {
  late CallStatusEnum _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = context.read<CallStatusProvider>().callStatusEnum;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text('Call Type',
              style:
                  textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
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
                title: Text(CallStatusEnum.values[index].name.capitalizeFirst!),
              );
            }),
        const SizedBox(height: 12.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer<CallStatusProvider>(builder: (context, provider, _) {
                return CustomElevatedButton(
                    buttonText: 'Apply',
                    onPressed: () {
                      provider.changeStatus(_selectedValue);
                      Navigator.pop(context, true);
                    });
              })
            ],
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}

class CallLogDetails extends StatelessWidget {
  final Call? callLog;
  final void Function()? onTapCancel,
      onTapWaiting,
      onTapComplete,
      onTapPending,
      onPressImageChip;

  const CallLogDetails(
      {super.key,
      this.callLog,
      this.onTapCancel,
      this.onTapWaiting,
      this.onTapComplete,
      this.onTapPending,
      this.onPressImageChip});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(callLog?.user?.name?.capitalizeFirst ?? '',
                  style: textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  InputChip(
                      tooltip: 'Status',
                      label: Text(callLog?.status?.capitalizeFirst ?? ''),
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      visualDensity: VisualDensity(vertical: -4),
                      shape: StadiumBorder(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  const SizedBox(width: 6.0),
                  IconButton(
                      tooltip: 'More actions',
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return CallLogActionWidget(
                                onTapWaiting: onTapWaiting,
                                onTapCancel: onTapCancel,
                                onTapComplete: onTapComplete,
                                onTapPending: onTapPending,
                              );
                            });
                      },
                      icon: const Icon(Icons.more_vert))
                ],
              )
            ],
          ),
          const SizedBox(height: 10.0),
          if (callLog?.photo != null) ...[
            ActionChip(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity(vertical: -4),
              tooltip: 'Image',
              onPressed: onPressImageChip,
              label: Text(callLog?.photo ?? 'photo.jpg'),
              avatar: Icon(Icons.image),
            ),
            const SizedBox(height: 10.0),
          ],
          Row(
            children: [
              Icon(Icons.call),
              const SizedBox(width: 6.0),
              Text(callLog?.user?.phone ?? '', style: textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined),
              const SizedBox(width: 6.0),
              Expanded(
                  child: Text(callLog?.address?.capitalizeFirst ?? 'N/A',
                      style: textTheme.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.message_outlined),
              const SizedBox(width: 6.0),
              Expanded(
                  child: Text(callLog?.description?.capitalizeFirst ?? '',
                      style: textTheme.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.date_range),
              const SizedBox(width: 6.0),
              Expanded(
                  child: Text(callLog?.date ?? '', style: textTheme.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10.0),
          if(context.read<CallStatusProvider>().callStatusEnum == CallStatusEnum.completed)...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.payments),
                const SizedBox(width: 6.0),
                Expanded(
                    child: Text(
                        ((callLog?.paymentMethod?.trim().toLowerCase() ?? '') ==
                            'debit')
                            ? 'Unsettled'
                            : 'Settled',
                        style: textTheme.bodyLarge)),
              ],
            ),
          ]
        ],
      ),
    );
  }
}

class ClientCallDetails extends StatelessWidget {
  final ClientModel.ClientCall? callLog;
  final void Function()? onTapCancel, onTapComplete, onPressImageChip;

  const ClientCallDetails(
      {super.key,
      this.callLog,
      this.onTapCancel,
      this.onTapComplete,
      this.onPressImageChip});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InputChip(
                  tooltip: 'Status',
                  label: Text(callLog?.status?.capitalizeFirst ?? ''),
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  visualDensity: VisualDensity(vertical: -4),
                  shape: StadiumBorder(),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
              const SizedBox(width: 6.0),
              if (context.read<CallStatusProvider>().callStatusEnum !=
                      CallStatusEnum.completed &&
                  context.read<CallStatusProvider>().callStatusEnum !=
                      CallStatusEnum.cancelled) ...[
                IconButton(
                    tooltip: 'More actions',
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return CallLogActionWidget(
                              onTapWaiting: null,
                              onTapCancel: onTapCancel,
                              onTapComplete: onTapComplete,
                              onTapPending: null,
                            );
                          });
                    },
                    icon: const Icon(Icons.more_vert))
              ]
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined),
              const SizedBox(width: 6.0),
              Expanded(
                  child: Text(callLog?.address?.capitalizeFirst ?? 'N/A',
                      style: textTheme.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.message_outlined),
              const SizedBox(width: 6.0),
              Expanded(
                  child: Text(callLog?.description?.capitalizeFirst ?? '',
                      style: textTheme.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.date_range),
              const SizedBox(width: 6.0),
              Expanded(
                  child: Text(callLog?.date ?? '', style: textTheme.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.currency_rupee),
              const SizedBox(width: 6.0),
              Expanded(
                  child: Text(callLog?.assign?.charge ?? '',
                      style: textTheme.bodyLarge)),
            ],
          ),
          if (callLog?.photo == null) ...[
            const SizedBox(height: 10.0),
            ActionChip(
              visualDensity: VisualDensity(vertical: -4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              tooltip: 'Image',
              onPressed: onPressImageChip,
              label: Text(callLog?.photo ?? 'photo.jpg'),
              avatar: Icon(Icons.image),
            ),
          ],
        ],
      ),
    );
  }
}

class StaffCallLogDetails extends StatelessWidget {
  final StaffCallLogData? callLog;
  final void Function()? onTapCancel,
      onTapWaiting,
      onTapComplete,
      onTapPending,
      onPressImageChip;

  const StaffCallLogDetails(
      {super.key,
      this.callLog,
      this.onTapCancel,
      this.onTapWaiting,
      this.onTapComplete,
      this.onTapPending,
      this.onPressImageChip});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(callLog?.call?.user?.name?.capitalizeFirst ?? '',
                  style: textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              InputChip(
                  tooltip: 'Status',
                  label: Text(callLog?.call?.status?.capitalizeFirst ?? ''),
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  visualDensity: VisualDensity(vertical: -4),
                  shape: StadiumBorder(),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)
            ],
          ),
          const SizedBox(height: 10.0),
          if (callLog?.call?.photo != null) ...[
            ActionChip(
                tooltip: 'Image',
                onPressed: onPressImageChip,
                label: Text(callLog?.call?.photo ?? 'photo.jpg'),
                avatar: Icon(Icons.image)),
            const SizedBox(height: 10.0),
          ],
          Row(
            children: [
              Icon(Icons.call),
              const SizedBox(width: 6.0),
              Text(callLog?.call?.user?.phone ?? '',
                  style: textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined),
              const SizedBox(width: 6.0),
              Expanded(
                  child: Text(callLog?.call?.address?.capitalizeFirst ?? 'N/A',
                      style: textTheme.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.message_outlined),
              const SizedBox(width: 6.0),
              Expanded(
                  child: Text(callLog?.call?.description?.capitalizeFirst ?? '',
                      style: textTheme.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.date_range),
              const SizedBox(width: 6.0),
              Expanded(
                  child: Text(callLog?.date ?? '', style: textTheme.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.watch_later_outlined),
              const SizedBox(width: 6.0),
              Expanded(
                  child: Text(callLog?.slot?.capitalizeFirst ?? '',
                      style: textTheme.bodyLarge)),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.currency_rupee),
              const SizedBox(width: 6.0),
              Expanded(
                  child:
                      Text(callLog?.charge ?? '', style: textTheme.bodyLarge)),
            ],
          ),
        ],
      ),
    );
  }
}
