class DailyAttendanceModel {
  bool? status;
  String? message;
  List<DailyAttendanceData>? data;

  DailyAttendanceModel({this.status, this.message, this.data});

  DailyAttendanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DailyAttendanceData>[];
      json['data'].forEach((v) {
        data!.add(new DailyAttendanceData.fromJson(v));
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

class DailyAttendanceData {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? token;
  String? birthdate;
  String? createdAt;
  String? updatedAt;
  String? totalBreakTime;
  String? totalWorkingHours;
  List<Attendances>? attendances;

  DailyAttendanceData(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.token,
        this.birthdate,
        this.createdAt,
        this.updatedAt,
        this.totalBreakTime,
        this.totalWorkingHours,
        this.attendances});

  DailyAttendanceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    token = json['token'];
    birthdate = json['birthdate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalBreakTime = json['totalBreakTime'];
    totalWorkingHours = json['totalWorkingHours'];
    if (json['attendances'] != null) {
      attendances = <Attendances>[];
      json['attendances'].forEach((v) {
        attendances!.add(new Attendances.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['token'] = this.token;
    data['birthdate'] = this.birthdate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['totalBreakTime'] = this.totalBreakTime;
    data['totalWorkingHours'] = this.totalWorkingHours;
    if (this.attendances != null) {
      data['attendances'] = this.attendances!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendances {
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

  Attendances(
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

  Attendances.fromJson(Map<String, dynamic> json) {
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
