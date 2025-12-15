import 'dart:math';
import 'package:final_project/models/project_model.dart';
import 'package:flutter/material.dart';

class NewProject extends StatefulWidget {
  const NewProject({super.key});

  @override
  State<NewProject> createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _todoController = TextEditingController();
  final List<String> _todoItems = [];

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

  void _createProject() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a project title')),
      );
      return;
    }

    final project = Project(
      id: Random().nextInt(100000).toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      todoItems: List.from(_todoItems),
    );

    Navigator.pop(context, project);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: const Text('Create A New Project', style: TextStyle(fontSize: 24)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            color: Colors.amber,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Project Title', style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter project title', 
                border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            const Text('Project Description', 
            style: TextStyle(fontSize: 16, 
            fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter project description', 
                border: OutlineInputBorder()),
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            const Text('Todo Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(hintText: 'Enter a todo item', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTodoItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.add, size: 17, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_todoItems.isNotEmpty)
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), 
                borderRadius: BorderRadius.circular(4)),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _todoItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_todoItems[index]),
                      trailing: IconButton(icon: const Icon(Icons.clear_rounded, 
                      color: Colors.red), onPressed: () => _removeTodoItem(index)),
                    );
                  },
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text('No todo items yet', style: TextStyle(color: Colors.grey[600]))),
              ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                child: const Text('Create Project'),
              ),
            ),
          ],
        ),
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
