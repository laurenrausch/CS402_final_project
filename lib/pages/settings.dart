import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/settings_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDark = false;
  int _cosplaysGrid = 2;
  int _projectGrid = 2;
  int _maxProjects = 10;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('isDark') ?? false;
      _cosplaysGrid = prefs.getInt('cosplays_grid') ?? 2;
      _projectGrid = prefs.getInt('project_grid') ?? 2;
      _maxProjects = prefs.getInt('max_projects') ?? 10;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    settingsVersion.value++;
  }

  Future<void> _saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
    settingsVersion.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Toggle between light and dark themes'),
              value: _isDark,
              onChanged: (v) {
                setState(() => _isDark = v);
                _saveBool('isDark', v);
              },
            ),
            const SizedBox(height: 12),
            const Text('Number of Cosplay Photos per row:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _cosplaysGrid,
              items: List.generate(4, (i) => i + 1).map((v) => DropdownMenuItem(value: v, child: Text(v.toString()))).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _cosplaysGrid = v);
                _saveInt('cosplays_grid', v);
              },
            ),
            const SizedBox(height: 16),
            const Text('Number of Project Photos per row:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _projectGrid,
              items: List.generate(4, (i) => i + 1).map((v) => DropdownMenuItem(value: v, child: Text(v.toString()))).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _projectGrid = v);
                _saveInt('project_grid', v);
              },
            ),
            const SizedBox(height: 16),
            const Text('Maximum number of projects:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _maxProjects,
              items: List.generate(10, (i) => i + 1).map((v) => DropdownMenuItem(value: v, child: Text(v.toString()))).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _maxProjects = v);
                _saveInt('max_projects', v);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  Navigator.pop(context, true);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
