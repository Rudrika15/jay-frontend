import 'package:flipcodeattendence/helper/string_helper.dart';

import '/helper/height_width_helper.dart';
import '/provider/attendance_provider.dart';
import '/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceRecordScreen extends StatefulWidget {
  const AttendanceRecordScreen({
    super.key,
  });

  @override
  State<AttendanceRecordScreen> createState() => _AttendanceRecordScreenState();
}

class _AttendanceRecordScreenState extends State<AttendanceRecordScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AttendanceProvider>(context, listen: false)
        .showAttendanceRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.record),
        titleSpacing: 0.0,
      ),
      body: Consumer<AttendanceProvider>(
          builder: (context, attendanceProvider, _) {
        final attendanceRecord = attendanceProvider.attendanceRecord?.user;
        return (attendanceProvider.isLoading)
            ? Center(child: CircularProgressIndicator())
            : (attendanceRecord?.isEmpty == true ||
                    attendanceRecord == null ||
                    attendanceRecord == [])
                ? Center(
                    child: Text(StringHelper.noRecordWarning),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return AttendanceRecordWidget(
                        date: attendanceRecord[index].date,
                        checkIn: attendanceRecord[index].checkin,
                        checkOut: attendanceRecord[index].checkout,
                        onBreak: attendanceRecord[index].onBreak,
                        offBreak: attendanceRecord[index].offBreak,
                        totalHours: attendanceRecord[index].totalHours,
                        totalBreakHours: null,
                      );
                    },
                  );
      }),
    );
  }
}

class AttendanceRecordWidget extends StatefulWidget {
  final String? date,
      checkIn,
      checkOut,
      onBreak,
      offBreak,
      totalHours,
      totalBreakHours;

  const AttendanceRecordWidget({
    super.key,
    this.date,
    this.checkIn,
    this.checkOut,
    this.onBreak,
    this.offBreak,
    this.totalHours,
    this.totalBreakHours,
  });

  @override
  State<AttendanceRecordWidget> createState() => _AttendanceRecordWidgetState();
}

class _AttendanceRecordWidgetState extends State<AttendanceRecordWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context: context),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey.shade400)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(widget.date ?? StringHelper.noRecordWarning,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600)),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Check in'),
                    Divider(height: 1, color: AppColors.grey.withOpacity(0.4)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.call_received),
                        SizedBox(
                          width: 12,
                        ),
                        Text(widget.checkIn?.substring(0, 5) ?? '00:00'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Check out'),
                    Divider(height: 1, color: AppColors.grey.withOpacity(0.4)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.call_made),
                        SizedBox(
                          width: 12,
                        ),
                        Text(widget.checkOut?.substring(0, 5) ?? '00:00'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('On break'),
                    Divider(height: 1, color: AppColors.grey.withOpacity(0.4)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.pause),
                        SizedBox(
                          width: 12,
                        ),
                        Text(widget.onBreak?.substring(0, 5) ?? '00:00'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Off break'),
                    Divider(height: 1, color: AppColors.grey.withOpacity(0.4)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.play_arrow),
                        SizedBox(
                          width: 12,
                        ),
                        Text(widget.offBreak?.substring(0, 5) ?? '00:00'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Hours'),
                    Divider(height: 1, color: AppColors.grey.withOpacity(0.4)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.timelapse),
                        SizedBox(
                          width: 12,
                        ),
                        Text(widget.totalHours?.substring(0, 5) ?? '00:00'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Break Hours'),
                    Divider(height: 1, color: AppColors.grey.withOpacity(0.4)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.fastfood_outlined),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                            widget.totalBreakHours?.substring(0, 5) ?? '00:00'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Check in : '),
          //     Text(widget.checkIn?.substring(0,5) ?? '00:00'),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Check out : '),
          //     Text(widget.checkOut?.substring(0,5) ?? '00:00'),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('On Break : '),
          //     Text(widget.onBreak?.substring(0,5) ?? '00:00'),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Off Break : '),
          //     Text(widget.offBreak?.substring(0,5) ?? '00:00'),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Total hours : '),
          //     Text(widget.totalHours?.substring(0,5) ?? '00:00'),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Break time : '),
          //     Text(widget.totalBreakHours?.substring(0,5) ?? '00:00'),
          //   ],
          // ),
        ],
      ),
    );
  }
}
