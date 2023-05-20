import 'package:flutter/material.dart';
import 'package:mobius/quiz_progress.dart';
import 'package:mobius/standings.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import './quiz.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setFullScreen(true);
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuizProgressData()),
        ChangeNotifierProvider(create: (context) => StandingsData()),
      ],
      child: const MobiusApp(),
    ),
  );
}

class MobiusApp extends StatefulWidget {
  const MobiusApp({super.key});

  @override
  State<MobiusApp> createState() => _MobiusAppState();
}

class _MobiusAppState extends State<MobiusApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          width: double.infinity,
          color: const Color(0xFF2F2F3F),
          child: const Padding(padding: EdgeInsets.all(8), child: Quiz()),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
