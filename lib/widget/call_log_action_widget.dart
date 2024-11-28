import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/provider/call_status_provider.dart';
import 'package:flipcodeattendence/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CallLogActionWidget extends StatefulWidget {
  final void Function()? onTapCancel, onTapWaiting, onTapComplete, onTapPending;

  const CallLogActionWidget(
      {super.key,
      this.onTapCancel,
      this.onTapWaiting,
      this.onTapComplete,
      this.onTapPending});

  @override
  State<CallLogActionWidget> createState() => _CallLogActionWidgetState();
}

class _CallLogActionWidgetState extends State<CallLogActionWidget> {
  late CallStatusEnum callStatus;

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  getStatus() {
    callStatus = context.read<CallStatusProvider>().callStatusEnum;
    print(context.read<LoginProvider>().isUser);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (callStatus != CallStatusEnum.pending && context.read<LoginProvider>().isAdmin) ...[
          ListTile(
            leading: const Icon(Icons.timelapse),
            title: const Text('Move to pending'),
            onTap: widget.onTapPending,
          ),
        ],
        if (callStatus != CallStatusEnum.cancelled) ...[
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text('Cancel call log'),
            onTap: widget.onTapCancel,
          ),
        ],
        if (callStatus != CallStatusEnum.waiting && context.read<LoginProvider>().isAdmin) ...[
          ListTile(
            leading: const Icon(Icons.watch_later_outlined),
            title: const Text('Add to waiting list'),
            onTap: widget.onTapWaiting,
          ),
        ],
        if (callStatus != CallStatusEnum.completed) ...[
          ListTile(
            leading: const Icon(Icons.done_all),
            title: const Text('Mark as completed'),
            onTap: widget.onTapComplete,
          ),
        ],
      ],
    );
  }
}
