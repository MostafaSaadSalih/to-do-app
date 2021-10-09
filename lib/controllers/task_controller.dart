import 'package:get/get.dart';
import 'package:getx_project/db/db_helper.dart';
import 'package:getx_project/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

/// get data from database
  Future<void> getTasks() async {
    ///tasks here at list of object of json
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks
        .map((elementForEachJson) => Task.fromJson(elementForEachJson))
        .toList());
  }
  /// delete data from database
  void deleteTasks(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }
  /// delete  all tasks data from database
  void deleteAllTasks() async {
    await DBHelper.deleteAllTasks();
    getTasks();
  }

  /// update data from database
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
