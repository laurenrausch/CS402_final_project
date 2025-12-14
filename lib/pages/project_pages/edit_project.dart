import 'package:final_project/models/project_model.dart';
import 'package:flutter/material.dart';

class EditProject extends StatefulWidget {
  const EditProject({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final TextEditingController _todoController = TextEditingController();
  late List<String> _todoItems;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _descriptionController = TextEditingController(text: widget.project.description);
    _todoItems = List.from(widget.project.todoItems);
  }

  void _addTodoItem() {
    if (_todoController.text.trim().isEmpty) return;

    setState(() {
      _todoItems.add(_todoController.text.trim());
    });

    _todoController.clear();
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  void _saveAndReturn() {
    final updated = widget.project.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      todoItems: List.from(_todoItems),
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Project Title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _titleController, decoration: const InputDecoration(border: OutlineInputBorder())),
          const SizedBox(height: 16),

          const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _descriptionController, maxLines: 4, decoration: const InputDecoration(border: OutlineInputBorder())),
          const SizedBox(height: 16),

          const Text('Todo Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: _todoController, decoration: const InputDecoration(hintText: 'Add todo', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _addTodoItem, child: const Icon(Icons.add)),
          ]),
          const SizedBox(height: 12),

          if (_todoItems.isNotEmpty)
            ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: _todoItems.length, itemBuilder: (context, index) {
              return ListTile(title: Text(_todoItems[index]), trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _removeTodoItem(index)));
            })
          else
            Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text('No todo items', style: TextStyle(color: Colors.grey[600]))),

          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _saveAndReturn, child: const Text('Save'))),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _todoController.dispose();
    super.dispose();
  }
}
