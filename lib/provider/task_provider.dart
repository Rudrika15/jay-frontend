import 'package:flipcodeattendence/featuers/Admin/model/all_employee_task_model.dart';
import 'package:flipcodeattendence/featuers/Admin/model/employee_tasks_model.dart';
import 'package:flipcodeattendence/service/task_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../helper/method_helper.dart';

class TaskProvider extends ChangeNotifier {
  final service = TaskService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _canAddTask = false;
  bool get canAddTask => _canAddTask;


  EmployeeTasksModel? _employeeTasksModel;
  EmployeeTasksModel? get employeeTasksModel => _employeeTasksModel;

  AllEmployeeTaskModel? _allEmployeeTaskModel;
  AllEmployeeTaskModel? get allEmployeeTaskModel => _allEmployeeTaskModel;


  Future<bool> submitTask({required BuildContext context, required String taskText}) async{
    _isLoading = true;
    notifyListeners();
    bool isSuccess = await service.submitTask(context: context, taskText: taskText);
    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<void> getTasks({required BuildContext context}) async{
    _isLoading = true;
    _employeeTasksModel = await service.getTask(context: context);
    _isLoading = false;
    checkTasks();
    notifyListeners();
  }

  void checkTasks() {
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (_employeeTasksModel == null || _employeeTasksModel?.data?.isEmpty == true) {
      _canAddTask = true;
    } else {
      if(_employeeTasksModel?.data?.any((element) => MethodHelper.yyyyMMddDateFormat(element.createdAt?.trim()) == currentDate.trim()) ?? true) {
        _canAddTask = false;
      } else {
        _canAddTask = true;
      }
    }
    notifyListeners();
  }

  Future<bool> deleteTask({required BuildContext context, required String id}) async{
    _isLoading = true;
    notifyListeners();
    bool isDeleted = await service.deleteTask(context: context, id: id);
    _isLoading = false;
    notifyListeners();
    return isDeleted;
  }

  Future<bool> updateTask({required BuildContext context, required String id, required String updatedTaskText}) async{
    _isLoading = true;
    notifyListeners();
    bool isSuccess = await service.updateTask(context: context, id: id, updatedTaskText: updatedTaskText);
    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<void> getAllEmployeeTask({required BuildContext context, String? name, String? date}) async{
    _isLoading = true;
    if (name?.trim() != null) {
      notifyListeners();
    }
    _allEmployeeTaskModel = await service.getAllEmployeeTask(context: context, name: name?.trim(), date: date);
    _isLoading = false;
    notifyListeners();
  }
}