class EmployeeReportModel {
  bool? status;
  String? message;
  List<Data>? data;

  EmployeeReportModel({this.status, this.message, this.data});

  EmployeeReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? totalHours;
  int? attendanceCount;
  int? taskCount;
  num? leaveCount;
  List<Leaves>? leaves;

  Data(
      {this.id,
        this.name,
        this.totalHours,
        this.attendanceCount,
        this.taskCount,
        this.leaveCount,
        this.leaves});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    totalHours = json['total_hours'];
    attendanceCount = json['attendance_count'];
    taskCount = json['task_count'];
    leaveCount = json['leave_count'];
    if (json['leaves'] != null) {
      leaves = <Leaves>[];
      json['leaves'].forEach((v) {
        leaves!.add(new Leaves.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['total_hours'] = this.totalHours;
    data['attendance_count'] = this.attendanceCount;
    data['task_count'] = this.taskCount;
    data['leave_count'] = this.leaveCount;
    if (this.leaves != null) {
      data['leaves'] = this.leaves!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leaves {
  int? id;
  String? startDate;
  String? endDate;
  String? reason;
  String? status;
  String? leaveType;
  num? leaveDuration;

  Leaves(
      {this.id,
        this.startDate,
        this.endDate,
        this.reason,
        this.status,
        this.leaveType,
        this.leaveDuration});

  Leaves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    reason = json['reason'];
    status = json['status'];
    leaveType = json['leaveType'];
    leaveDuration = json['leave_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['leaveType'] = this.leaveType;
    data['leave_duration'] = this.leaveDuration;
    return data;
  }
}
