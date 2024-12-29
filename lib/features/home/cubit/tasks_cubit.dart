import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/home/repository/task_remote_repository.dart';
import 'package:task_app/model/task_model.dart';
part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  final taskRemoteRepository = TaskRemoteRepository();

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
}
