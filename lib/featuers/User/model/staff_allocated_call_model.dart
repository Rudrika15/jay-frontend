import '../../../models/call_logs_model.dart';

class StaffAllocatedCallModel {
  bool? status;
  String? message;
  List<StaffCallLogData>? data;

  StaffAllocatedCallModel({this.status, this.message, this.data});

  StaffAllocatedCallModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StaffCallLogData>[];
      json['data'].forEach((v) {
        data!.add(new StaffCallLogData.fromJson(v));
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

class StaffCallLogData {
  int? id;
  int? userId;
  int? callId;
  String? slot;
  String? charge;
  String? date;
  String? createdAt;
  String? updatedAt;
  Call? call;

  StaffCallLogData(
      {this.id,
        this.userId,
        this.callId,
        this.slot,
        this.charge,
        this.date,
        this.createdAt,
        this.updatedAt,
        this.call});

  StaffCallLogData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    callId = json['callId'];
    slot = json['slot'];
    charge = json['charge'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    call = json['call'] != null ? new Call.fromJson(json['call']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['callId'] = this.callId;
    data['slot'] = this.slot;
    data['charge'] = this.charge;
    data['date'] = this.date;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.call != null) {
      data['call'] = this.call!.toJson();
    }
    return data;
  }
}
