import 'package:flutter/material.dart';

class CosPlans extends StatefulWidget {
  const CosPlans({super.key});

  @override
  State<CosPlans> createState() => _CosPlansState();
}

class _CosPlansState extends State<CosPlans> {
  final List<Map<String, dynamic>> _active = [];
  final List<Map<String, dynamic>> _completed = [];
  final TextEditingController _controller = TextEditingController();

  void _addItem() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _active.add({"title": _controller.text.trim(), "checked": false});
    });

    _controller.clear();
    Navigator.pop(context); 
  }

  void _deleteActive(int index) {
    setState(() {
      _active.removeAt(index);
    });
  }

  void _deleteCompleted(int index) {
    setState(() {
      _completed.removeAt(index);
    });
  }

  void _toggleToCompleted(int index, bool? value) {
    if (value == true) {
      setState(() {
        final item = _active.removeAt(index);
        item["checked"] = true;
        _completed.insert(0, item);
      });
    }
  }

  void _toggleToActive(int index, bool? value) {
    if (value == false) {
      setState(() {
        final item = _completed.removeAt(index);
        item["checked"] = false;
        _active.insert(0, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Your Cos-plans', style: TextStyle(fontSize: 24)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            color: Colors.amber,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: const Text('Cosplays To Do:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // Active list
            if (_active.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('No cosplans yet. Tap + to add one!', style: TextStyle(fontSize: 16)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _active.length,
                itemBuilder: (context, index) {
                  final item = _active[index];
                  return Dismissible(
                    key: Key(item['title'] + index.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Are you sure you want to delete this cosplan?'),
                          content: const Text('This action cannot be undone.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) => _deleteActive(index),
                    child: ListTile(
                      leading: Checkbox(
                        activeColor: Colors.amber,
                        value: item['checked'],
                        onChanged: (value) => _toggleToCompleted(index, value),
                      ),
                      title: Text(item['title']),
                      onTap: null,
                    ),
                  );
                },
              ),

            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: const Text('Cosplays complete:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            if (_completed.isEmpty)
              const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('No completed items yet.', style: TextStyle(color: Colors.grey)))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _completed.length,
                itemBuilder: (context, index) {
                  final item = _completed[index];
                  return Dismissible(
                    key: Key(item['title'] + 'c' + index.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Are you sure you want to delete this cosplan?'),
                          content: const Text('This action cannot be undone.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) => _deleteCompleted(index),
                    child: ListTile(
                      leading: Checkbox(
                        activeColor: const Color.fromARGB(255, 215, 111, 0),
                        value: item['checked'],
                        onChanged: (value) => _toggleToActive(index, value),
                      ),
                      title: Text(item['title']),
                      onTap: null,
                    ),
                  );
                },
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add Cos-Plan"),
              content: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Enter your cos-plan here.",
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
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
