import 'package:final_project/pages/project_pages/project_page.dart';
import 'package:flutter/material.dart';

class CurrentProject extends StatefulWidget {
  const CurrentProject({super.key});

  @override
  State<CurrentProject> createState() => _CurrentProjectState();
}

class _CurrentProjectState extends State<CurrentProject> {
  final List<String> _plans = [];  
  final TextEditingController _controller = TextEditingController();

  void _addItem() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _plans.add(_controller.text.trim());
    });

    _controller.clear();
    Navigator.pop(context); // close dialog
  }

  void _deleteItem(int index) {
    setState(() {
      _plans.removeAt(index);
    });
  }

  void _editItem(int index, String newValue) {
    setState(() {
      _plans[index] = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosplay Projects'),
      ),

      body: _plans.isEmpty
          ? const Center(
              child: Text(
                "No projects yet.\nTap + to add one!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final item = _plans[index];
                return Dismissible(
                  key: Key(item + index.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Are you sure you want to delete this project?'),
                        content: const Text('This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(c).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(c).pop(true),
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    return shouldDelete == true;
                  },
                  onDismissed: (direction) => _deleteItem(index),

                  child: ListTile(
                    title: Text(item),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectPage(projectName: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add Project"),
              content: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Project Name",
                ),
                autofocus: true,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text("Add"),
                ),
              ],
            ),
          );
        },
        tooltip: 'Add New Project',
        child: const Icon(Icons.add),
      ),
    );
  }
}
