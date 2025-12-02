import 'package:flutter/material.dart';


class Cosplays extends StatefulWidget {
  const Cosplays({super.key});

  @override
  State<Cosplays> createState() => _CosplaysState();
}
class _CosplaysState extends State<Cosplays> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosplays'),
      ),
      body: const Center(
        child: Text('This is the Cosplays page'),
      ),
     floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add A Photo"),
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
        tooltip: 'Add New Photo',
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}