import 'package:flipcodeattendence/Page/call_log_details_page.dart';
import 'package:flipcodeattendence/Page/create_call_page.dart';
import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/helper/user_role_helper.dart';
import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/models/call_logs_model.dart';
import 'package:flipcodeattendence/widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  CallStatusEnum _selectedCallType = CallStatusEnum.values.first;
  final dateController = TextEditingController();
  bool _isFabVisible = true;
  late ScrollController _scrollController;

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
    getCallLogs();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
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
      if (_isFabVisible) {
        setState(() {
          _isFabVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isFabVisible) {
        setState(() {
          _isFabVisible = true;
        });
      }
    }
  }

  Future<void> getCallLogs() async {
    Provider.of<CallLogProvider>(context, listen: false)
        .getCallLogs(context: context, status: _selectedCallType);
  }

  Future<void> changeStatus({required String id,required CallStatusEnum status }) async {
      Provider.of<CallLogProvider>(context,
          listen: false)
          .changeStatus(
          id: id,
          context: context,
          status: status).then((value) {
            if(value) {
              getCallLogs();
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8.0,
                children: [
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
                          : DateFormat('dd-MM-yyyy').parse(dateController.text);
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
                          builder: (context) {
                            return CallTypeRadioListTileWidget(
                                initialValue: _selectedCallType);
                          }).then((value) {
                        setState(() {
                          if (value != null) {
                            _selectedCallType = value;
                            getCallLogs();
                          }
                        });
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => getCallLogs(),
                  child: Consumer<CallLogProvider>(
                      builder: (context, provider, _) {
                    return provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : (provider.callLogsModel?.data?.isEmpty ?? false)
                            ? const Center(child: Text('No call logs found'))
                            : ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
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
                                        if (value == true) {
                                          Provider.of<CallLogProvider>(context,
                                                  listen: false)
                                              .getCallLogs(context: context);
                                        }
                                      });
                                    },
                                    child: CallLogDetails(
                                      callLog: callLog,
                                      onTapCancel: () {
                                        changeStatus(id: callLog?.id.toString() ?? '', status: CallStatusEnum.cancelled);
                                      },
                                      onTapWaiting: () {
                                        Provider.of<CallLogProvider>(context,
                                            listen: false)
                                            .changeStatus(
                                            id: callLog?.id.toString() ?? '',
                                            context: context,
                                            status: CallStatusEnum.waiting);
                                      },
                                    ),
                                  );
                                });
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: (!isUser)
          ? AnimatedOpacity(
              opacity: _isFabVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 350),
              child: IgnorePointer(
                ignoring: !_isFabVisible,
                child: FloatingActionButton(
                  onPressed: () {
                    push(context, CreateCallPage());
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            )
          : const SizedBox.shrink(),
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

class CallLogDetails extends StatelessWidget {
  final CallLog? callLog;
  final void Function()? onTapCancel, onTapWaiting;

  const CallLogDetails(
      {super.key, this.callLog, this.onTapCancel, this.onTapWaiting});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.aPrimary)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(callLog?.user?.name ?? '',
                  style: textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Chip(
                      label: Text(callLog?.status ?? ''),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity(vertical: -4),
                      shape: StadiumBorder(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  const SizedBox(width: 6.0),
                  PopupMenuButton(
                    padding: EdgeInsets.zero,
                    style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity:
                          VisualDensity(vertical: -4, horizontal: -4),
                    ),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Icons.cancel),
                                const SizedBox(width: 8.0),
                                const Text('Cancel'),
                              ],
                            ),
                            onTap: onTapCancel),
                        PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Icons.timelapse),
                                const SizedBox(width: 8.0),
                                const Text('Add to waiting list'),
                              ],
                            ),
                            onTap: onTapWaiting),
                      ];
                    },
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 10.0),
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
                  child: Text(callLog?.address ?? 'N/A',
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
                  child: Text(callLog?.description ?? '',
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
        ],
      ),
    );
  }
}
