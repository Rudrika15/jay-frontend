import 'package:flipcodeattendence/Page/call_log_details_page.dart';
import 'package:flipcodeattendence/Page/create_call_page.dart';
import 'package:flipcodeattendence/helper/user_role_helper.dart';
import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/call_log_provider.dart';
import '../provider/login_provider.dart';
import '../theme/app_colors.dart';

final List<String> LogTypes = List.unmodifiable(['All', 'Today']);
final List<String> CallType = List.unmodifiable(
    ['Pending', 'Cancelled', 'Allocated', 'Completed', 'Waiting']);

class CallLogPage extends StatefulWidget {
  const CallLogPage({super.key});

  @override
  State<CallLogPage> createState() => _CallLogPageState();
}

class _CallLogPageState extends State<CallLogPage> with NavigatorMixin {
  bool isUser = false;
  String _selectedChip = LogTypes.first;
  String _selectedCallType = CallType.first;
  String? userRole;

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
              Wrap(
                spacing: 8.0,
                children: [
                  ActionChip(
                    padding: EdgeInsets.zero,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_selectedChip),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                    onPressed: () async {
                      await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) => Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RangeRadioListTileWidget(
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedChip = value;
                                          });
                                        },
                                        initialValue: _selectedChip),
                                    const SizedBox(height: 12.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomElevatedButton(
                                              buttonText: 'Ok',
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, _selectedChip);
                                              }),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
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
                        Text(_selectedCallType),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                    onPressed: () async {
                      await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) => Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CallTypeRadioListTileWidget(
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedCallType = value;
                                          });
                                        },
                                        initialValue: _selectedCallType),
                                    const SizedBox(height: 12.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomElevatedButton(
                                              buttonText: 'Ok',
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, _selectedCallType);
                                              }),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).then((value) {
                        setState(() {
                          if (value != null) {
                            _selectedCallType = value;
                          }
                        });
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Expanded(
                child:
                    Consumer<CallLogProvider>(builder: (context, provider, _) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.callLogsModel?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final callLog = provider.callLogsModel?.data?[index];
                        return provider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : (provider.callLogsModel?.data?.isEmpty ?? false)
                                ? const Center(
                                    child: Text('No call logs found'))
                                : GestureDetector(
                                    onTap: () {
                                      push(context, CallLogDetailsPage());
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
                                                      'Yoginagar society, Dalmil road, Surendranagar, 363001, Gujarat',
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
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const RangeRadioListTileWidget(
      {super.key, required this.onChanged, required this.initialValue});

  @override
  State<RangeRadioListTileWidget> createState() =>
      _RangeRadioListTileWidgetState();
}

class _RangeRadioListTileWidgetState extends State<RangeRadioListTileWidget> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text('Range',
                style:
                    textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12.0),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: LogTypes.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  value: LogTypes[index],
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = LogTypes[index];
                      widget.onChanged(_selectedValue!);
                    });
                  },
                  title: Text(LogTypes[index]),
                );
              }),
        ],
      ),
    );
  }
}

class CallTypeRadioListTileWidget extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const CallTypeRadioListTileWidget(
      {super.key, required this.onChanged, required this.initialValue});

  @override
  State<CallTypeRadioListTileWidget> createState() =>
      _CallTypeRadioListTileWidget();
}

class _CallTypeRadioListTileWidget extends State<CallTypeRadioListTileWidget> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text('Call Type',
                style:
                    textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12.0),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: CallType.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  value: CallType[index],
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = CallType[index];
                      widget.onChanged(_selectedValue!);
                    });
                  },
                  title: Text(CallType[index]),
                );
              }),
        ],
      ),
    );
  }
}
