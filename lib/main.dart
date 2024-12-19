import 'package:flutter/material.dart';
import 'package:task_app/features/auth/cubits/auth_cubit.dart';
import 'package:task_app/features/auth/pages/signup_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthCubit())],
      child: MaterialApp(
        title: 'Task App',
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(27),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 3),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          useMaterial3: true,
        ),
        home: const SignUpPage(),
      ),
    );
  }
}
