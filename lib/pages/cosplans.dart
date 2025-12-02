import 'package:flutter/material.dart';

class CosPlans extends StatefulWidget {
  const CosPlans({super.key});

  @override
  State<CosPlans> createState() => _CosPlansState();
}

class _CosPlansState extends State<CosPlans> {
  final List<Map<String, dynamic>> _plans = [];  
  final TextEditingController _controller = TextEditingController();

  void _addItem() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _plans.add({
        "title": _controller.text.trim(),
        "checked": false,
      });
    });

    _controller.clear();
    Navigator.pop(context); // close the dialog
  }

  void _deleteItem(int index) {
    setState(() {
      _plans.removeAt(index);
    });
  }

  void _toggleCheck(int index, bool? value) {
    setState(() {
      _plans[index]["checked"] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosplays To Do:'),
      ),

      body: _plans.isEmpty
          ? const Center(
              child: Text(
                "No cosplans yet.\nTap + to add one!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final item = _plans[index];
                return Dismissible(
                  key: Key(item["title"] + index.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _deleteItem(index),
                  child: CheckboxListTile(
                    title: Text(item["title"]),
                    value: item["checked"],
                    onChanged: (value) => _toggleCheck(index, value),
                    secondary: const Icon(Icons.chevron_right_outlined),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add CosPlan"),
              content: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Add A Cosplan",
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
        tooltip: 'Add New CosPlan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
