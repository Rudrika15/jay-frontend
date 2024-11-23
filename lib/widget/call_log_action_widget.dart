import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/provider/call_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CallLogActionWidget extends StatefulWidget {
  final void Function()? onTapCancel, onTapWaiting;
  const CallLogActionWidget({super.key, this.onTapCancel, this.onTapWaiting});

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(callStatus == CallStatusEnum.pending) ...[
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text('Cancel call log'),
            onTap: widget.onTapCancel,
          ),
          ListTile(
            leading: const Icon(Icons.watch_later_outlined),
            title: const Text('Add to waiting list'),
            onTap: widget.onTapWaiting,
          ),
        ],
      ],
    );
  }
}
