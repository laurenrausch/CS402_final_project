import 'package:final_project/models/project_model.dart';
import 'package:final_project/pages/project_pages/new_project.dart';
import 'package:final_project/pages/project_pages/project_page.dart';
import 'package:flutter/material.dart';

class CurrentProject extends StatefulWidget {
  const CurrentProject({super.key});

  @override
  State<CurrentProject> createState() => _CurrentProjectState();
}

class _CurrentProjectState extends State<CurrentProject> {
  final List<Project> _projects = [];

  void _removeProject(int index) {
    setState(() {
      _projects.removeAt(index);
    });
  }

  Future<void> _createNew() async {
    final res = await Navigator.push<Project?>(context, MaterialPageRoute(builder: (_) => const NewProject()));
    if (res != null) {
      setState(() => _projects.add(res));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Cosplay Projects:', style: TextStyle(fontSize: 24)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            color: Colors.amber,
          ),
        ),
      ),
      body: _projects.isEmpty
          ? const Center(child: Text("No projects yet.\nTap + to add one!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: _projects.length,
              itemBuilder: (context, index) {
                final p = _projects[index];
                return Dismissible(
                  key: Key(p.id),
                  background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 16), child: const Icon(Icons.delete, color: Colors.white)),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    final shouldDelete = await showDialog<bool>(context: context, builder: (c) => AlertDialog(title: const Text('Delete project?'), content: const Text('This action cannot be undone.'), actions: [TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red)))]));
                    return shouldDelete == true;
                  },
                  onDismissed: (direction) => _removeProject(index),
                  child: ListTile(
                    title: Text(p.title),
                    subtitle: p.description.isEmpty ? null : Text(p.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () async {
                      final updated = await Navigator.push<Project?>(context, MaterialPageRoute(builder: (_) => ProjectPage(project: p)));
                      if (updated != null) {
                        setState(() => _projects[index] = updated);
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(onPressed: _createNew, tooltip: 'Add New Project', child: const Icon(Icons.add)),
    );
  }
}
