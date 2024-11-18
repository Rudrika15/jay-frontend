class LeaveListModel {
  String? message;
  List<LeaveData>? data;

  LeaveListModel({this.message, this.data});

  LeaveListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <LeaveData>[];
      json['data'].forEach((v) {
        data!.add(new LeaveData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveData {
  int? id;
  int? userId;
  String? leaveType;
  String? startDate;
  String? endDate;
  String? reason;
  String? status;
  String? createdAt;
  String? updatedAt;

  LeaveData(
      {this.id,
      this.userId,
      this.leaveType,
      this.startDate,
      this.endDate,
      this.reason,
      this.status,
      this.createdAt,
      this.updatedAt});

  LeaveData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    leaveType = json['leaveType'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    reason = json['reason'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['leaveType'] = this.leaveType;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
