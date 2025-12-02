import 'package:flutter/material.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key, required String projectName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Page'),
      ),
      body: const Center(
        child: Text('This is the Project Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Update Project Detail"),
              content: const SizedBox.shrink(), // empty popup
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          );
        },
        tooltip: 'Update Project Detail',
        child: const Icon(Icons.edit),
      ),
    );
  }
}