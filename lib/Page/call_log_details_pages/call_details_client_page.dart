import 'package:flipcodeattendence/helper/enum_helper.dart';
import 'package:flipcodeattendence/provider/call_status_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../provider/call_log_provider.dart';
import '../../widget/call_log_action_widget.dart';

class CallDetailsClientPage extends StatefulWidget {
  final String id;

  const CallDetailsClientPage({super.key, required this.id});

  @override
  State<CallDetailsClientPage> createState() => _CallDetailsClientPageState();
}

class _CallDetailsClientPageState extends State<CallDetailsClientPage> {
  final _formKey = GlobalKey<FormState>();
  late final CallLogProvider provider;
  late final CallStatusEnum callStatus;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CallLogProvider>(context, listen: false);
    callStatus = context.read<CallStatusProvider>().callStatusEnum;
    (callStatus == CallStatusEnum.allocated)
        ? provider.getAllocatedCallLogDetails(context: context, id: widget.id)
        : null;
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
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}