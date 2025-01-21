import 'package:flipcodeattendence/helper/method_helper.dart';
import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/models/notification_response_model.dart';
import 'package:flipcodeattendence/provider/notification_provider.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:view_more/view_more.dart';

class NotificationPage extends StatefulWidget {
  final bool isAdmin;

  const NotificationPage({super.key, required this.isAdmin});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    Provider.of<NotificationProvider>(context, listen: false)
        .getNotification(context);
    super.initState();
  }

  Future<void> deleteNotification(String id) async {
    Provider.of<NotificationProvider>(context, listen: false)
        .deleteNotification(context, id: id)
        .then((value) {
      if (value == true) {
        Provider.of<NotificationProvider>(context, listen: false)
            .getNotification(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.notification),
        titleSpacing: 0.0,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationValue, child) => notificationValue
                .isLoading
            ? Center(child: CircularProgressIndicator())
            : notificationValue.notificationResponseModel?.notificationList
                        ?.isNotEmpty ??
                    false
                ? ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      NotificationData? notificationData = notificationValue
                          .notificationResponseModel?.notificationList?[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Dismissible(
                          key: ValueKey<NotificationData?>(notificationData),
                          direction: DismissDirection.endToStart,
                          dismissThresholds: const {
                            DismissDirection.endToStart: 0.8
                          },
                          background: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            color: AppColors.red,
                            alignment: AlignmentDirectional.centerEnd,
                            child: const Icon(CupertinoIcons.trash,
                                color: AppColors.onPrimaryLight),
                          ),
                          onDismissed: (direction) async{
                            deleteNotification(notificationData?.id.toString() ?? '');
                          },
                          child: CustomNotificationCard(
                            title: notificationData?.title,
                            detail: notificationData?.detail,
                            date: notificationData?.createdAt,
                          ),
                        ),
                      );
                    },
                    itemCount: notificationValue.notificationResponseModel
                            ?.notificationList?.length ??
                        0,
                  )
                : Center(
                    child: Text(StringHelper.noNotificationFound),
                  ),
      ),
    );
  }
}

class CustomNotificationCard extends StatelessWidget {
  final String? title;
  final String? detail;
  final String? date;

  const CustomNotificationCard({
    super.key,
    this.title,
    this.detail,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title ?? '',
            style:
                Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 20),
          ),
          subtitle: ViewMore(
            detail ?? '',
            trimLines: 4,
            textAlign: TextAlign.justify,
            trimMode: Trimer.line,
            trimCollapsedText: StringHelper.viewMore,
            trimExpandedText: StringHelper.viewLess,
            lessStyle: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: AppColors.aPrimary),
            moreStyle: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: AppColors.aPrimary),
          ),
          // trailing: Text(
          //   MethodHelper.formateUtcDate(value: date, formate: 'dd MMM') ?? '',
          //   style: TextStyle(
          //     color: AppColors.grey,
          //   ),
          // ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                MethodHelper.formateUtcDate(value: date, formate: 'dd MMM') ??
                    '',
                style: TextStyle(
                  color: AppColors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
