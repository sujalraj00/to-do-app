import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/home/repository/task_local_repository.dart';
import 'package:task_app/features/home/repository/task_remote_repository.dart';
import 'package:task_app/model/task_model.dart';
part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();

  Future<void> createNewTask(
      {required String title,
      required String description,
      required Color color,
      required String token,
      required String uid,
      required DateTime dueAt}) async {
    try {
      emit(TasksLoading());
      final taskModel = await taskRemoteRepository.createTask(
          title: title,
          description: description,
          hexColor: rgbToHex(color),
          token: token,
          dueAt: dueAt,
          uid: uid);

      await taskLocalRepository.insertTask(taskModel);

      emit(AddNewTasksSuccess(taskModel));
    } catch (error) {
      print(error.toString());
      emit(TasksError(
          "failed to create task due to some issue ${error.toString()}"));
    }
  }

  Future<void> getAllTasks({
    required String token,
  }) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRemoteRepository.getTasks(
        token: token,
      );

      emit(GetTasksSuccess(tasks));
    } catch (error) {
      print(error.toString());
      emit(TasksError(
          "failed to create task due to some issue ${error.toString()}"));
    }
  }

  Future<void> syncTasks(String token) async {
    // GET ALL THE UNSYNCED TASK FROM OUR SQLITE DATABASE
    final unsyncedTasks = await taskLocalRepository.getUnsyncedTasks();
    if (unsyncedTasks.isEmpty) {
      return;
    }
    print(unsyncedTasks);
    // TALK TO THE POSTGRES DB TO ADD NEW TASK
    final isSynced = await taskRemoteRepository.syncTasks(
        token: token, tasks: unsyncedTasks);
    // CHANGE THE TASKS THAT WERE ADDED TO THE DB FROM 0 TO 1
    if (isSynced) {
      print("sync done");
      for (final task in unsyncedTasks) {
        taskLocalRepository.updateRowValue(task.id, 1);
      }
    }
  }
}
