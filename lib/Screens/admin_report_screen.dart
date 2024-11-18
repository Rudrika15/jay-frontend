import 'package:flipcodeattendence/mixins/navigator_mixin.dart';
import 'package:flipcodeattendence/provider/report_provider.dart';
import 'package:flipcodeattendence/theme/app_colors.dart';
import 'package:flipcodeattendence/widget/date_selection_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/string_helper.dart';

class AdminReportScreen extends StatefulWidget {
  const AdminReportScreen({super.key});

  @override
  State<AdminReportScreen> createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends State<AdminReportScreen>
    with NavigatorMixin {
  String? startDate, endDate;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => Provider.of<ReportProvider>(context, listen: false).clearData());
  }

  Future<void> getEmployeeReport({required String startDate,required String endDate}) async {
    Provider.of<ReportProvider>(context, listen: false).employeeReport(
        context: context,
        startDate: startDate,
        endDate: endDate);
  }

  int countPendingTasks(
      {required String totalAttendance, required String totalTask}) {
    final totalAttendanceCount = double.parse(totalAttendance);
    final totalTaskCount = int.parse(totalTask);
    final totalPendingTask = totalAttendanceCount - totalTaskCount;
    return totalPendingTask.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Text(
          StringHelper.report,
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return DateSelectionWidget(
                        startDate: startDate,
                        endDate: endDate,
                        onPressed: (startDate, endDate) {
                          pop(context);
                          this.startDate = startDate;
                          this.endDate = endDate;
                          getEmployeeReport(startDate: startDate, endDate: endDate);
                        },
                      );
                    });
              },
              icon: const Icon(Icons.filter_alt_rounded))
        ],
      ),
      body: Consumer<ReportProvider>(builder: (context, provider, _) {
        return (provider.isLoading)
            ? const LinearProgressIndicator()
            : ListView.builder(
                itemCount: provider.employeeReportModel?.data?.length ?? 0,
                shrinkWrap: true,
                padding: EdgeInsets.all(12.0),
                itemBuilder: (context, index) {
                  final data = provider.employeeReportModel?.data?[index];
                  return Container(
                    padding: EdgeInsets.all(12.0),
                    margin: EdgeInsets.only(bottom: 12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: AppColors.grey)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Employee name and call icon
                        Text(
                          data?.name ?? '',
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: AppColors.onPrimaryBlack,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          "Total Leave : ${data?.leaveCount}",
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.onPrimaryBlack,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          "Working Hours : ${data?.totalHours}",
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.onPrimaryBlack,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          "No tasks : ${countPendingTasks(
                            totalAttendance:
                                data?.attendanceCount?.toString() ?? '0',
                            totalTask: data?.taskCount?.toString() ?? '0'
                          )}",
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.onPrimaryBlack,
                          ),
                        ),
                      ],
                    ),
                  );
                });
      }),
    );
  }
}
