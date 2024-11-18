import 'package:flipcodeattendence/helper/method_helper.dart';
import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/models/notification_response_model.dart';
import 'package:flipcodeattendence/provider/notification_provider.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.notification),
        titleSpacing: 0.0,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationValue, child) =>
            notificationValue.isLoading
                ? Center(child: CircularProgressIndicator())
                : notificationValue.notificationResponseModel?.notificationList
                            ?.isNotEmpty ??
                        false
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          NotificationData? notificationData = notificationValue
                              .notificationResponseModel
                              ?.notificationList?[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: CustomNotificationCard(
                              title: notificationData?.title,
                              detail: notificationData?.detail,
                              date: notificationData?.createdAt,
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
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          // leading: Icon(Icons.notifications_none_rounded),
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
            Text(
              MethodHelper.formateUtcDate(value: date, formate: 'dd MMM') ?? '',
              style: TextStyle(
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        Divider(
          color: AppColors.grey.withOpacity(0.4),
        )
      ],
    );
  }
}
