import 'package:final_project/pages/cosplans.dart';
import 'package:final_project/pages/cosplays.dart';
import 'package:final_project/pages/projects.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) => setState(() => _themeMode = mode);

  @override
  Widget build(BuildContext context) {
    final light = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 254, 146, 4), brightness: Brightness.light),
    );
    final dark = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 254, 146, 4), brightness: Brightness.dark),
    );

    return MaterialApp(
      title: 'Flutter Final Project',
      theme: light,
      darkTheme: dark,
      themeMode: _themeMode,
      routes: {
        '/': (context) => MyHomePage(title: 'Welcome to your Build-Book', themeMode: _themeMode, onThemeChanged: _setThemeMode),
        '/cosplays': (context) => const Cosplays(),
        '/cosplans': (context) => const CosPlans(),
        '/current_project': (context) => const CurrentProject(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.themeMode, required this.onThemeChanged});
  final String title;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text("Build-Book", ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (dialogContext) {
                var selected = widget.themeMode;
                return StatefulBuilder(builder: (c, setState) {
                  return AlertDialog(
                    title: const Text('Settings'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<ThemeMode>(
                          title: const Text('Light'),
                          value: ThemeMode.light,
                          groupValue: selected,
                          onChanged: (m) { setState(() { selected = m!; }); widget.onThemeChanged(selected); },
                        ),
                        RadioListTile<ThemeMode>(
                          title: const Text('Dark'),
                          value: ThemeMode.dark,
                          groupValue: selected,
                          onChanged: (m) { setState(() { selected = m!; }); widget.onThemeChanged(selected); },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                });
              },
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Center(child: Text(widget.title)),
          const Cosplays(),
          const CosPlans(),
          const CurrentProject(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(

         type: BottomNavigationBarType.fixed,
         backgroundColor: const Color.fromARGB(255, 227, 109, 36),
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(

            icon: Icon(Icons.home),
            label: 'Home',

          ),
          const BottomNavigationBarItem(

            icon: Icon(Icons.person),
            label: 'Cosplays',

          ),
          const BottomNavigationBarItem(

            icon: Icon(Icons.list),
            label: 'CosPlans',

          ),
          const BottomNavigationBarItem(

            icon: Icon(Icons.build),
            label: 'Projects',

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 255, 175, 54),
        onTap: (index) {
          setState(() { _selectedIndex = index; });
        },
      ),
    );
  }
}