import 'dart:convert';

import 'package:flipcodeattendence/helper/api_helper.dart';
import 'package:flipcodeattendence/models/all_employee_task_model.dart';
import 'package:flipcodeattendence/models/employee_tasks_model.dart';
import 'package:flipcodeattendence/service/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../helper/method_helper.dart';
import '../helper/string_helper.dart';

class TaskService {
  Future<bool> submitTask({required BuildContext context, required String taskText}) async {
    final token = await SharedPreferencesService.getUserToken();
    final api = ApiHelper.submitTask;
    final headers = {
      'Authorization': 'Bearer $token',
    };
    final body = {
      'task' : taskText
    };

    try {
      final response = await http.post(Uri.parse(api), headers: headers, body: body);
      if(response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
        return true;
      } else {
        print(response.statusCode);
        print(response.body);
        return false;
      }
    }catch(e) {
      print(e.toString());
      return false;
    }
  }

  Future<EmployeeTasksModel?> getTask({required BuildContext context}) async {
    final token = await SharedPreferencesService.getUserToken();
    final api = ApiHelper.getTask;
    final headers = {
      'Authorization': 'Bearer $token',
      "Content-Type" : 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(api), headers: headers);
      if(response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
        return EmployeeTasksModel.fromJson(jsonDecode(response.body));
      } else {
        print(response.statusCode);
        print(response.body);
        return null;
      }
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> deleteTask({required BuildContext context, required String id}) async {
    final token = await SharedPreferencesService.getUserToken();
    final api = ApiHelper.deleteTask;
    final headers = {
      'Authorization': 'Bearer $token',
      "Content-Type" : 'application/json'
    };
    final body = {
      "id" : id
    };

    try {
      final response = await http.delete(Uri.parse(api), headers: headers, body: jsonEncode(body));
      if(response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
        final body = jsonDecode(response.body);
        if(body['status'] == false) {
          MethodHelper.showSnackBar(message: body['message'], isSuccess: false);
          return false;
        } else {
          MethodHelper.showSnackBar(message: StringHelper.taskDeleteSuccess);
          return true;
        }
      } else {
        print(response.statusCode);
        print(response.body);
        final body = jsonDecode(response.body);
        MethodHelper.showSnackBar(message: body['message'], isSuccess: false);
        return false;
      }
    }catch(e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateTask({required BuildContext context, required String id, required String updatedTaskText}) async {
    final token = await SharedPreferencesService.getUserToken();
    final api = ApiHelper.updateTask;
    final headers = {
      'Authorization': 'Bearer $token',
      "Content-Type" : 'application/json'
    };
    final body = {
      "id" : int.parse(id),
      "task" : updatedTaskText
    };

    try {
      final response = await http.post(Uri.parse(api), headers: headers, body: jsonEncode(body));
      if(response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        if(body['status'] == false) {
          MethodHelper.showSnackBar(message: body['message'], isSuccess: false);
          return false;
        } else {
          MethodHelper.showSnackBar(message: StringHelper.taskUpdateSuccess);
          return true;
        }
      } else {
        print(response.statusCode);
        print(response.body);
        final body = jsonDecode(response.body);
        MethodHelper.showSnackBar(message: body['message']);
        return false;
      }
    }catch(e) {
      print(e.toString());
      MethodHelper.showSnackBar(message: StringHelper.taskUpdateFailure, isSuccess: false);
      return false;
    }
  }

  Future<AllEmployeeTaskModel?> getAllEmployeeTask({required BuildContext context, String? name, String? date}) async {
    final token = await SharedPreferencesService.getUserToken();
    final api = ApiHelper.adminAllTask
        + (date != null ? '?date=$date' : '?date=' )
        + (name != null ? '&name=$name' : '&name=' );
    final headers = {
      'Authorization': 'Bearer $token',
      "Content-Type" : 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(api), headers: headers);
      if(response.statusCode == 200 || response.statusCode == 201) {
        return AllEmployeeTaskModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
}