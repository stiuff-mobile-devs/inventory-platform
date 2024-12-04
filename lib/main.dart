import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  final ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue).copyWith(
      brightness: Brightness.light,
    ),
    brightness: Brightness.light,
    useMaterial3: true,
  );

  final ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.deepPurple,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
      brightness: Brightness.dark,
    ),
    brightness: Brightness.dark,
    useMaterial3: true,
  );

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Platform',
      theme: _isDarkTheme ? _darkTheme : _lightTheme,
      home: MyHomePage(onChangeTheme: _toggleTheme, isDarkTheme: _isDarkTheme),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final VoidCallback onChangeTheme;
  final bool isDarkTheme;

  const MyHomePage(
      {super.key, required this.onChangeTheme, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: onChangeTheme,
                  icon: Icon(
                    isDarkTheme ? Icons.nightlight_round : Icons.wb_sunny,
                    color: Colors.white,
                    size: 36.0,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      isDarkTheme ? Colors.grey[800] : Colors.blue,
                    ),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ),
              // Body
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to Inventory Platform!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Content goes here.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                color: isDarkTheme ? Colors.grey[800] : Colors.blue,
                child: Text(
                  'Footer content here.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
