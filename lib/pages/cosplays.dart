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

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

void _previewPhoto(int index) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Image.file(File(_photos[index].path)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
        TextButton(
          onPressed: () async {
            final confirmDelete = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Are you sure you want to delete this photo?"),
                content: const Text("This action cannot be undone."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Delete",
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );

            if (confirmDelete == true) {
              Navigator.pop(context); // close the preview dialog
              _removePhoto(index);    // delete the photo
            }
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cosplays')),
      body: _photos.isEmpty
          ? const Center(child: Text('No photos yet'))
          : GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.all(10),
              children: List.generate(_photos.length, (index) {
                return GestureDetector(
                  onTap: () => _previewPhoto(index),
                  child: Image.file(File(_photos[index].path), fit: BoxFit.cover),
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}