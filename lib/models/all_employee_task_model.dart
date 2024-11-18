class AllEmployeeTaskModel {
  bool? status;
  String? message;
  List<Data>? data;

  AllEmployeeTaskModel({this.status, this.message, this.data});

  AllEmployeeTaskModel.fromJson(Map<String, dynamic> json) {
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
  String? phone;
  String? email;
  String? token;
  String? birthdate;
  String? createdAt;
  String? updatedAt;
  Task? task;

  Data(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.token,
        this.birthdate,
        this.createdAt,
        this.updatedAt,
        this.task});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    token = json['token'];
    birthdate = json['birthdate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    task = json['task'] != null ? new Task.fromJson(json['task']) : null;
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
    if (this.task != null) {
      data['task'] = this.task!.toJson();
    }
    return data;
  }
}

class Task {
  int? id;
  int? userId;
  String? task;
  String? createdAt;
  String? updatedAt;

  Task({this.id, this.userId, this.task, this.createdAt, this.updatedAt});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    task = json['task'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['task'] = this.task;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
