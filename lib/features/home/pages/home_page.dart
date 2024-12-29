import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/auth/cubits/auth_cubit.dart';
import 'package:task_app/features/home/cubit/tasks_cubit.dart';
import 'package:task_app/features/home/pages/add_new_task.dart';
import 'package:task_app/features/home/widgets/date_selector.dart';
import 'package:task_app/features/home/widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<TasksCubit>().getAllTasks(token: user.user.token);
    Connectivity().onConnectivityChanged.listen((data) {
      if (data.contains(ConnectivityResult.wifi)) {
        // GET ALL THE UNSYNCED TASK FROM OUR SQLITE DATABASE
        // TALK TO THE POSTGRES DB TO ADD NEW TASK
        // CHANGE THE TASKS THAT WERE ADDED TO THE DB FROM 0 TO 1
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My task'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(AddNewTaskPage.route());
                },
                icon: const Icon(CupertinoIcons.add))
          ],
        ),
        body: BlocBuilder<TasksCubit, TasksState>(
          builder: (context, state) {
            if (state is TasksLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TasksError) {
              return Center(child: Text(state.error));
            }

            if (state is GetTasksSuccess) {
              final tasks = state.tasks
                  .where((element) =>
                      DateFormat('d').format(element.dueAt) ==
                          DateFormat('d').format(selectedDate) &&
                      selectedDate.month == element.dueAt.month &&
                      selectedDate.year == element.dueAt.year)
                  .toList();

              return Column(
                children: [
                  // date selector
                  DateSelector(
                    selectedDate: selectedDate,
                    onTap: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),

                  Expanded(
                    child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Row(
                            children: [
                              Expanded(
                                child: TaskCard(
                                    color: task.color,
                                    headerText: task.title,
                                    descriptionText: task.description),
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    color: strengthenColor(
                                        const Color.fromRGBO(246, 222, 194, 1),
                                        0.69),
                                    shape: BoxShape.circle),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  DateFormat.jm().format(task.dueAt),
                                  style: TextStyle(fontSize: 17),
                                ),
                              )
                            ],
                          );
                        }),
                  )
                ],
              );
            }

            return const SizedBox();
          },
        ));
  }
}
