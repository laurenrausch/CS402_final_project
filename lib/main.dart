import 'dart:io';
import 'package:final_project/pages/cosplans.dart';
import 'package:final_project/pages/cosplays.dart';
import 'package:final_project/pages/projects.dart';
import 'package:final_project/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'services/settings_notifier.dart';
import 'package:google_fonts/google_fonts.dart';

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
  void initState() {
    super.initState();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark');
    setState(() {
      if (isDark == null) {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final light = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 255, 189, 8),
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.roboto(fontSize: 27, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w600),
      ),
    );

    final dark = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 255, 189, 8),
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        titleTextStyle: GoogleFonts.roboto(fontSize: 27, color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.w600),
      ),
    );

    return MaterialApp(
      title: 'Flutter Final Project', 
      theme: light,
      darkTheme: dark,
      themeMode: _themeMode,
      routes: {
        '/': (context) => MyHomePage(
          title: 'Welcome to your Build-Book',
          themeMode: _themeMode,
          onThemeChanged: _setThemeMode,
        ),
        '/cosplays': (context) => const Cosplays(),
        '/cosplans': (context) => const CosPlans(),
        '/current_project': (context) => const CurrentProject(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.themeMode,
    required this.onThemeChanged,
  });
  final String title;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String? _lastCosplayPath;

  @override
  void initState() {
    super.initState();
    _loadLastCosplay();
    settingsVersion.addListener(_loadLastCosplay);
  }

  @override
  void dispose() {
    settingsVersion.removeListener(_loadLastCosplay);
    super.dispose();
  }

  Future<void> _loadLastCosplay() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastCosplayPath = prefs.getString('last_cosplay_photo');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text("Build-Book", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
              // reload theme from prefs after returning from settings
              final prefs = await SharedPreferences.getInstance();
              final isDark = prefs.getBool('isDark');
              setState(() {
                if (isDark == null) {
                  // leave as system
                } else {
                  widget.onThemeChanged(isDark ? ThemeMode.dark : ThemeMode.light);
                }
              });
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text("Let's get started!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  const Text('Let\'s get you started on your next project!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      onPressed: () => setState(() => _selectedIndex = 3),
                      child: const Text('Go to Projects', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(height: 4, width: double.infinity, color: Colors.amber),
                  const SizedBox(height: 12),
                  const Text('Last Cosplay', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _lastCosplayPath == null
                      ? Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Center(child: Text('No cosplay photos yet')),
                        )
                      : SizedBox(
                          width: 500,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(_lastCosplayPath!), fit: BoxFit.cover),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    child: const Text('Want to add another photo?', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      onPressed: () => setState(() => _selectedIndex = 1),
                      child: const Text('Go to Cosplays', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Cosplays(),
          const CosPlans(),
          const CurrentProject(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.amber[500],
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',),
          const BottomNavigationBarItem(
            icon: Icon(Icons.collections_outlined),
            label: 'Cosplays',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.face_retouching_natural),
            label: 'CosPlans',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.content_cut_rounded),
            label: 'Projects',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 202, 91, 1),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
