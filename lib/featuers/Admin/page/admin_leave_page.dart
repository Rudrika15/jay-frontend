import 'package:flipcodeattendence/helper/string_helper.dart';
import 'package:flipcodeattendence/featuers/Admin/model/leave_requests_model.dart';
import 'package:flipcodeattendence/provider/leave_provider.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flipcodeattendence/widget/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../helper/enum_helper.dart';
import '../../User/page/user_leave_page.dart';
import 'admin_home_page.dart';

class AdminLeavePage extends StatefulWidget {
  const AdminLeavePage({super.key});

  @override
  State<AdminLeavePage> createState() => _AdminLeavePageState();
}

class _AdminLeavePageState extends State<AdminLeavePage> {
  LeaveType _selectedChip = LeaveType.values.first;

  final PagingController<int, LeaveData> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await Provider.of<LeaveProvider>(context, listen: false)
          .getLeaveRequestList(
              page: pageKey.toString(),
              getCurrentDateLeave:
                  _selectedChip == LeaveType.today ? true : false);
      final isLastPage =
          (newItems?.leaveRequestsData?.leaveDataList?.length ?? 0) < 10;
      if (isLastPage) {
        _pagingController
            .appendLastPage(newItems?.leaveRequestsData?.leaveDataList ?? []);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(
            newItems?.leaveRequestsData?.leaveDataList ?? [], nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     StringHelper.leave,
        //   ),
        //   actions: [
        //     NotificationButton(
        //       isAdmin: true,
        //     ),
        //   ],
        // ),
        body: SafeArea(
          child: Consumer<LeaveProvider>(
            builder: (context, leave, child) => RefreshIndicator(
              onRefresh: () async {
                _pagingController.refresh();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                    child: Wrap(
                        spacing: 8,
                        children: List<Widget>.generate(
                            LeaveType.values.length, (index) {
                          return ChoiceChip(
                            label: Text(LeaveType.values[index].name),
                            selected: _selectedChip == LeaveType.values[index],
                            labelStyle: TextStyle(
                                color: _selectedChip ==
                                        LeaveType.values[index]
                                    ? AppColors.backgroundLight
                                    : AppColors.backgroundBlack),
                            onSelected: (value) {
                              setState(() {
                                _selectedChip = LeaveType.values[index];
                              });
                              _pagingController.refresh();
                            },
                          );
                        }).toList()),
                  ),
                  Expanded(
                    child: PagedListView<int, LeaveData>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<LeaveData>(
                        itemBuilder: (context, item, index) => CustomLeaveCard(
                          isAdmin: true,
                          isLoading: item.id == leave.updateId
                              ? leave.isUpdating
                              : false,
                          leaveCreatedAt: item.createdAt,
                          name: item.user?.name,
                          leaveStartDate: item.startDate,
                          leaveEndDate: item.endDate,
                          leaveType: item.leaveType ?? '',
                          leaveReason: item.reason ?? '',
                          leaveStatus: item.status ?? '',
                          phoneNumber: item.user?.phone ?? '',
                          onCancelPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomAlertWidget(
                                    alertText: StringHelper
                                        .cancelLeaveApplicationWarning,
                                    icon: Icons.cancel_rounded,
                                    onActionButtonPressed: () async {
                                      Navigator.of(context).pop();
                                      await leave
                                          .cancelLeave(
                                        context: context,
                                        leaveId: item.id,
                                      )
                                          .then((value) {
                                        if (value) {
                                          _pagingController.refresh();
                                        }
                                      });
                                    },
                                  );
                                });
                          },
                          onApprovePressed: () async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomAlertWidget(
                                    alertText:
                                        StringHelper.approveLeaveConfirmation,
                                    icon: Icons.check_circle,
                                    iconColor: AppColors.green,
                                    onActionButtonPressed: () async {
                                      Navigator.of(context).pop();
                                      await leave
                                          .leaveAction(
                                        context: context,
                                        isApprove: true,
                                        leaveId: item.id,
                                      )
                                          .then((value) {
                                        if (value) {
                                          _pagingController.refresh();
                                        }
                                      });
                                    },
                                  );
                                });
                          },
                          onRejectPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomAlertWidget(
                                    alertText:
                                        StringHelper.rejectLeaveConfirmation,
                                    icon: Icons.cancel_rounded,
                                    iconColor: AppColors.green,
                                    onActionButtonPressed: () async {
                                      Navigator.of(context).pop();
                                      await leave
                                          .leaveAction(
                                        context: context,
                                        isApprove: false,
                                        leaveId: item.id,
                                      )
                                          .then((value) {
                                        if (value) {
                                          _pagingController.refresh();
                                        }
                                      });
                                    },
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
