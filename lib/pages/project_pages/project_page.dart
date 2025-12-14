import 'dart:io';

import 'package:final_project/models/project_model.dart';
import 'package:final_project/pages/project_pages/edit_project.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _project = widget.project;
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
              onPressed: () {
                Navigator.pop(context);
                _removePhoto(index);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Future<void> _editProject() async {
    final updated = await Navigator.push<Project?>(
      context,
      MaterialPageRoute(builder: (_) => EditProject(project: _project)),
    );

    if (updated != null) {
      setState(() => _project = updated);
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
        backgroundColor: Colors.amber,
        title: Text(_project.title),
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: _editProject)],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_project.description.isEmpty ? 'No description' : _project.description),
            ]),
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Todo Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_project.todoItems.isEmpty)
                Text('No todo items', style: TextStyle(color: Colors.grey[600]))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _project.todoItems.length,
                  itemBuilder: (context, index) => ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(_project.todoItems[index])),
                )
            ]),
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Photos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (_project.photoPaths.isEmpty)
                Center(child: Text('No photos yet. Tap + to add one.', style: TextStyle(color: Colors.grey[600])))
              else
                GridView.count(
                  crossAxisCount: 2,
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
      floatingActionButton: FloatingActionButton(onPressed: _addPhoto, tooltip: 'Add Photo', child: const Icon(Icons.camera_alt_outlined)),
      ),
    );
  }
}