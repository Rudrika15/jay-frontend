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
  late final isAdmin, isUser, isClient;

  @override
  void initState() {
    super.initState();
    isAdmin = context.read<LoginProvider>().isAdmin;
    isUser = context.read<LoginProvider>().isUser;
    isClient = context.read<LoginProvider>().isClient;
    callStatus = context.read<CallStatusProvider>().callStatusEnum;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAdmin) ...[
          AdminActions(
            callStatus: callStatus,
            onTapPending: widget.onTapPending,
            onTapComplete: widget.onTapComplete,
            onTapCancel: widget.onTapCancel,
            onTapWaiting: widget.onTapWaiting,
          ),
        ] else if (isUser) ...[
          UserActions(
              callStatus: callStatus, onTapComplete: widget.onTapComplete),
        ] else ...[
          ClientActions(
              callStatus: callStatus,
              onTapComplete: widget.onTapComplete,
              onTapCancel: widget.onTapCancel)
        ]
      ],
    );
  }
}

class AdminActions extends StatelessWidget {
  final CallStatusEnum callStatus;
  final void Function()? onTapPending, onTapCancel, onTapWaiting, onTapComplete;

  const AdminActions(
      {super.key,
      required this.callStatus,
      this.onTapPending,
      this.onTapCancel,
      this.onTapWaiting,
      this.onTapComplete});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (callStatus != CallStatusEnum.pending) ...[
          ListTileAction(
            leadingIcon: Icons.timelapse,
            title: 'Move to pending',
            onTap: onTapPending,
          )
        ],
        if (callStatus != CallStatusEnum.cancelled) ...[
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text('Cancel call log'),
            onTap: onTapCancel,
          ),
        ],
        if (callStatus != CallStatusEnum.waiting) ...[
          ListTile(
            leading: const Icon(Icons.watch_later_outlined),
            title: const Text('Add to waiting list'),
            onTap: onTapWaiting,
          ),
        ],
        if (callStatus != CallStatusEnum.completed) ...[
          ListTile(
            leading: const Icon(Icons.done_all),
            title: const Text('Mark as completed'),
            onTap: onTapComplete,
          ),
        ],
      ],
    );
  }
}

class UserActions extends StatelessWidget {
  final CallStatusEnum callStatus;
  final void Function()? onTapComplete;

  const UserActions({super.key, required this.callStatus, this.onTapComplete});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (callStatus != CallStatusEnum.completed) ...[
          ListTile(
            leading: const Icon(Icons.done_all),
            title: const Text('Mark as completed'),
            onTap: onTapComplete,
          ),
        ],
      ],
    );
  }
}

class ClientActions extends StatelessWidget {
  final CallStatusEnum callStatus;
  final void Function()? onTapComplete, onTapCancel;

  const ClientActions(
      {super.key,
      required this.callStatus,
      this.onTapComplete,
      this.onTapCancel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (callStatus != CallStatusEnum.cancelled) ...[
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text('Cancel call log'),
            onTap: onTapCancel,
          ),
        ],
        if (callStatus != CallStatusEnum.completed) ...[
          ListTile(
            leading: const Icon(Icons.done_all),
            title: const Text('Mark as completed'),
            onTap: onTapComplete,
          ),
        ],
      ],
    );
  }
}

class ListTileAction extends StatelessWidget {
  final void Function()? onTap;
  final IconData leadingIcon;
  final String title;

  const ListTileAction(
      {super.key, this.onTap, required this.leadingIcon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
