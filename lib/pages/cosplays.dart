import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/settings_notifier.dart';
import 'package:image_picker/image_picker.dart';

class Cosplays extends StatefulWidget {
  const Cosplays({super.key});

  @override
  State<Cosplays> createState() => _CosplaysState();
}

class _CosplaysState extends State<Cosplays> {
  final List<XFile> _photos = [];
  final ImagePicker _picker = ImagePicker();
  int _gridCount = 2;

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _photos.add(image);
      });
      // persist last cosplay photo path so home screen can show it
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_cosplay_photo', image.path);
      settingsVersion.value++;
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
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
      _gridCount = prefs.getInt('cosplays_grid') ?? 2;
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
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
      appBar: AppBar(
        title: const Text('Cosplays', style: TextStyle(fontSize: 24)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            color: Colors.amber,
          ),
        ),
      ),
      body: _photos.isEmpty
          ? const Center(child: Text('No photos yet'))
          : GridView.count(
              crossAxisCount: _gridCount,
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
        backgroundColor: Colors.amber,
        onPressed: _takePhoto,
        child: const Icon(Icons.add_a_photo_outlined, color: Colors.white),
      ),
    );
  }
}