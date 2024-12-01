import 'package:datathon_wall/layout.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.windows,
  // );

  WindowOptions windowOptions = const WindowOptions(
    // size: Size(500, 600), //1500, 900
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    alwaysOnTop: true,
    // minimumSize: Size(500, 600),
    // maximumSize: Size(1500, 900),
    fullScreen: false,
    title: "Datathon UoM",
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: "Title",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomLayout(),
    );
  }
}
