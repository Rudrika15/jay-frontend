class TodayModel {
  String? message;
  List<Attendance>? attendance;
  String? workingHours;
  String? breakTime;

  TodayModel({this.message, this.attendance});

  TodayModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['attendance'] != null) {
      attendance = <Attendance>[];
      json['attendance'].forEach((v) {
        attendance!.add(new Attendance.fromJson(v));
      });
    }
    workingHours = json['working_hours'];
    breakTime = json['break_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.map((v) => v.toJson()).toList();
    }
    data['working_hours'] = this.workingHours;
    data['break_time'] = this.breakTime;
    return data;
  }
}

class Attendance {
  int? id;
  int? userId;
  String? date;
  String? checkin;
  String? checkout;
  String? onBreak;
  String? offBreak;
  String? totalHours;
  String? createdAt;
  String? updatedAt;

  Attendance(
      {this.id,
        this.userId,
        this.date,
        this.checkin,
        this.checkout,
        this.onBreak,
        this.offBreak,
        this.totalHours,
        this.createdAt,
        this.updatedAt});

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    checkin = json['checkin'];
    checkout = json['checkout'];
    onBreak = json['on_break'];
    offBreak = json['off_break'];
    totalHours = json['total_hours'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['date'] = this.date;
    data['checkin'] = this.checkin;
    data['checkout'] = this.checkout;
    data['on_break'] = this.onBreak;
    data['off_break'] = this.offBreak;
    data['total_hours'] = this.totalHours;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}