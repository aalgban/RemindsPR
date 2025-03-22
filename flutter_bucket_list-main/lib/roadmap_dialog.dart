import 'package:flutter/material.dart';
import 'roadmap.dart';

class RoadmapDialog extends StatefulWidget {
  final Roadmap? roadmap;

  const RoadmapDialog({super.key, this.roadmap});

  @override
  // ignore: library_private_types_in_public_api
  _RoadmapDialogState createState() => _RoadmapDialogState();
}

class _RoadmapDialogState extends State<RoadmapDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  RoadmapPriority _priority = RoadmapPriority.medium;

  @override
  void initState() {
    super.initState();
    if (widget.roadmap != null) {
      _titleController.text = widget.roadmap!.title;
      _descriptionController.text = widget.roadmap!.description;
      _priority = widget.roadmap!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      backgroundColor: Colors.blue[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      title: Text(
        widget.roadmap == null ? 'Добавить План' : 'Редактировать План',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.title, color: Colors.blueAccent),
                  labelText: 'Название',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                style: const TextStyle(color: Colors.blueAccent),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.description, color: Colors.blueAccent),
                  labelText: 'Описание',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                style: const TextStyle(color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Приоритет:', style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
                const SizedBox(width: 10),
                DropdownButton<RoadmapPriority>(
                  value: _priority,
                  dropdownColor: Colors.blue[100],
                  items: const [
                    DropdownMenuItem(
                      value: RoadmapPriority.low,
                      child: Text('Низкий', style: TextStyle(color: Colors.blueAccent)),
                    ),
                    DropdownMenuItem(
                      value: RoadmapPriority.medium,
                      child: Text('Средний', style: TextStyle(color: Colors.blueAccent)),
                    ),
                    DropdownMenuItem(
                      value: RoadmapPriority.high,
                      child: Text('Высокий', style: TextStyle(color: Colors.blueAccent)),
                    ),
                  ],
                  onChanged: (RoadmapPriority? priority) {
                    setState(() {
                      _priority = priority!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Отмена', style: TextStyle(color: Colors.blueAccent)),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = _titleController.text;
                  final description = _descriptionController.text;
                  if (title.isNotEmpty) {
                    final roadmap = Roadmap(
                      title: title,
                      description: description,
                      priority: _priority,
                    );
                    Navigator.of(context).pop(roadmap);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}