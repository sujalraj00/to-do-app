import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_app/core/constants/constants.dart';
import 'package:task_app/model/task_model.dart';

class TaskRemoteRepository {
  Future<TaskModel> createTask(
      {required String title,
      required String description,
      required String hexColor,
      required String token,
      required String uid,
      required DateTime dueAt}) async {
    try {
      final res = await http.post(Uri.parse("${Constants.backendUri}/tasks"),
          headers: {'Content-Type': 'application/json', 'x-auth-token': token},
          body: jsonEncode({
            "title": title,
            "description": description,
            "hexColor": hexColor,
            "dueAt": dueAt.toIso8601String()
          }));

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      return TaskModel.fromJson(res.body);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<List<TaskModel>> getTasks({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${Constants.backendUri}/tasks"),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }

      final listofTasks = jsonDecode(res.body);
      List<TaskModel> tasksList = [];

      for (var elem in listofTasks) {
        print(elem);
        tasksList.add(TaskModel.fromMap(elem));
      }

      return tasksList;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
