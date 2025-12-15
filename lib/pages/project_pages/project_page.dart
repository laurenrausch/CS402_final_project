import 'dart:io';

import 'package:final_project/models/project_model.dart';
import 'package:final_project/pages/project_pages/edit_project.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/settings_notifier.dart';
import 'package:image_picker/image_picker.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  late Project _project;
  final ImagePicker _picker = ImagePicker();
  late List<Map<String, dynamic>> _activeTodos;
  late List<Map<String, dynamic>> _completedTodos;
  int _gridCount = 2;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
    _activeTodos = _project.todoItems.map((t) => {"title": t, "checked": false}).toList();
    _completedTodos = [];
    _loadSettings();
    settingsVersion.addListener(_loadSettings);
  }

  @override
  void dispose() {
    settingsVersion.removeListener(_loadSettings);
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _gridCount = prefs.getInt('project_grid') ?? 2;
    });
  }

  Future<void> _addPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      _project = _project.copyWith(photoPaths: [..._project.photoPaths, image.path]);
    });
  }

  void _removePhoto(int index) {
    setState(() {
      final p = List<String>.from(_project.photoPaths);
      p.removeAt(index);
      _project = _project.copyWith(photoPaths: p);
    });
  }

  void _previewPhoto(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Image.file(File(_project.photoPaths[index])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          TextButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Are you sure you want to delete this photo?'),
                  content: const Text('This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );

              if (confirmed == true) {
                Navigator.of(context).pop(); 
                _removePhoto(index);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _syncTodosToProject() {
    final combined = [..._activeTodos.map((e) => e['title'] as String), ..._completedTodos.map((e) => e['title'] as String)];
    setState(() {
      _project = _project.copyWith(todoItems: combined);
    });
  }

  void _moveToCompleted(int index) {
    setState(() {
      final item = _activeTodos.removeAt(index);
      item['checked'] = true;
      _completedTodos.insert(0, item);
      _syncTodosToProject();
    });
  }

  void _moveToActive(int index) {
    setState(() {
      final item = _completedTodos.removeAt(index);
      item['checked'] = false;
      _activeTodos.insert(0, item);
      _syncTodosToProject();
    });
  }

  Future<void> _editProject() async {
    final updated = await Navigator.push<Project?>(
      context,
      MaterialPageRoute(builder: (_) => EditProject(project: _project)),
    );

    if (updated != null) {
      setState(() {
        _project = updated;
        _activeTodos = _project.todoItems.map((t) => {"title": t, "checked": false}).toList();
        _completedTodos = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _project);
        return false;
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(_project.title),
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: _editProject)],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            color: Colors.amber,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
              const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_project.description.isEmpty ? 'No description' : _project.description),
            ]),
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
              const Text('Todo Items:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Builder(builder: (context) {
                final total = _activeTodos.length + _completedTodos.length;
                final completed = _completedTodos.length;
                final progress = total == 0 ? 0.0 : completed / total;
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('You have Completed: $completed / $total', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${(progress * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ]),
                  ),
                  ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[300], color: Colors.amber)),
                ]);
              }),

              const SizedBox(height: 12),

              if (_activeTodos.isEmpty)
                Text('No todo items', style: TextStyle(color: Colors.grey[600]))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _activeTodos.length,
                  itemBuilder: (context, index) {
                    final item = _activeTodos[index];
                    return Dismissible(
                      key: Key(item['title'] + index.toString()),
                      background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 16), child: const Icon(Icons.delete, color: Colors.white)),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: const Text('Delete todo?'), content: const Text('This action cannot be undone.'), actions: [TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red)))]));
                      },
                      onDismissed: (direction) {
                        setState(() {
                          _activeTodos.removeAt(index);
                          _syncTodosToProject();
                        });
                      },
                      child: ListTile(
                        leading: Checkbox(
                          activeColor: const Color.fromARGB(255, 234, 137, 0), 
                          value: item['checked'], 
                          onChanged: (v) => _moveToCompleted(index)),
                        title: Text(item['title']),
                        onTap: null,
                      ),
                    );
                  },
                ),
              const SizedBox(height: 12),

              const Divider(),
              const SizedBox(height: 8),
              const Text('Completed:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_completedTodos.isEmpty)
                Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('No completed items', style: TextStyle(color: Colors.grey[600])))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _completedTodos.length,
                  itemBuilder: (context, index) {
                    final item = _completedTodos[index];
                    return Dismissible(
                      key: Key(item['title'] + 'c' + index.toString()),
                      background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 16), child: const Icon(Icons.delete, color: Colors.white)),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: const Text('Delete completed todo?'), content: const Text('This action cannot be undone.'), actions: [TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red)))]));
                      },
                      onDismissed: (direction) {
                        setState(() {
                          _completedTodos.removeAt(index);
                          _syncTodosToProject();
                        });
                      },
                      child: ListTile(
                        leading: Checkbox(
                          activeColor: Colors.amber, 
                          value: item['checked'], 
                          onChanged: (v) => _moveToActive(index)),
                        title: Text(item['title']),
                        onTap: null,
                      ),
                    );
                  },
                ),
            ]),
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                const Text('Photos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (_project.photoPaths.isEmpty)
                  Center(child: Text('No photos yet.', style: TextStyle(color: Colors.grey[600])))
              else
                GridView.count(
                  crossAxisCount: _gridCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(_project.photoPaths.length, (index) {
                    return GestureDetector(
                      onTap: () => _previewPhoto(index),
                      child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(_project.photoPaths[index]), fit: BoxFit.cover)),
                    );
                  }),
                ),
            ]),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: _addPhoto, 
        tooltip: 'Add Photo', 
        child: const Icon(Icons.add_a_photo_outlined, color: Colors.white),
      ),
      ),
    );
  }
}