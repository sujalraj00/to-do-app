import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_app/core/constants/constants.dart';
import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/home/repository/task_local_repository.dart';
import 'package:task_app/model/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskRemoteRepository {
  final taskLocalRepository = TaskLocalRepository();
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
      // store the data in the same sql db table

      try {
        final taskModel = TaskModel(
            id: const Uuid().v4(),
            color: hexToRgb(hexColor),
            uid: uid,
            title: title,
            description: description,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            dueAt: dueAt,
            isSynced: 0);
        await taskLocalRepository.insertTask(taskModel);
        return taskModel;
      } catch (e) {
        rethrow;
      }
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

      await taskLocalRepository.insertTasks(tasksList);

      return tasksList;
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();
      if (tasks.isNotEmpty) {
        return tasks;
      }
      rethrow;
    }
  }
}
