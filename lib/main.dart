import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover/screens/chat_screen.dart';

import 'notifier/rover_notifier.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => RoverNotifier()),
        ],
        child: const MaterialApp(
          title: 'Rover map simulation with command lines',
          home: ChatScreen(),
        ),
      ),
    );
  }
}
