import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Cosplays extends StatefulWidget {
  const Cosplays({super.key});

  @override
  State<Cosplays> createState() => _CosplaysState();
}

class _CosplaysState extends State<Cosplays> {
  final List<XFile> _photos = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _photos.add(image);
      });
    }
  }

  void _showAddPhotoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add A Photo"),
        content: const Text("Take a new cosplay photo using your camera."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _takePhoto(); // Launch camera
            },
            child: const Text("Open Camera"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cosplays')),

      // Show grid if photos exist
      body: _photos.isEmpty
          ? const Center(child: Text('No photos yet'))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // two per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return Image.file(File(_photos[index].path), fit: BoxFit.cover);
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPhotoDialog,
        tooltip: 'Add New Photo',
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}
