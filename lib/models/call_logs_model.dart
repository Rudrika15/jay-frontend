class CallLogsModel {
  bool? status;
  String? message;
  List<Call>? data;

  CallLogsModel({this.status, this.message, this.data});

  CallLogsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Call>[];
      json['data'].forEach((v) {
        data!.add(new Call.fromJson(v));
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

class Call {
  int? id;
  String? date;
  int? userId;
  String? photo;
  String? description;
  String? address;
  String? partName;
  String? paymentMethod;
  int? totalCharge;
  int? qrId;
  String? status;
  String? createdAt;
  String? updatedAt;
  User? user;

  Call(
      {this.id,
        this.date,
        this.userId,
        this.photo,
        this.description,
        this.address,
        this.partName,
        this.paymentMethod,
        this.totalCharge,
        this.qrId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.user});

  Call.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    userId = json['userId'];
    photo = json['photo'];
    description = json['description'];
    address = json['address'];
    partName = json['part_name'];
    paymentMethod = json['payment_method'];
    totalCharge = json['total_charge'];
    qrId = json['qr_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['userId'] = this.userId;
    data['photo'] = this.photo;
    data['description'] = this.description;
    data['address'] = this.address;
    data['part_name'] = this.partName;
    data['payment_method'] = this.paymentMethod;
    data['total_charge'] = this.totalCharge;
    data['qr_id'] = this.qrId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? phone;
  String? email;
  Null? token;
  String? birthdate;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.token,
        this.birthdate,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    token = json['token'];
    birthdate = json['birthdate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}
