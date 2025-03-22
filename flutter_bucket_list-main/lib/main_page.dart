import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'roadmap.dart';
import 'roadmap_dialog.dart';
import 'circle_progress_painter.dart';
import 'roadmap_page.dart';
import 'date_carousel.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<DateTime, List<Roadmap>> roadmaps = {};
  DateTime selectedDate = DateTime.now();
  final CarouselController _carouselController = CarouselController();

  void _addRoadmap(Roadmap roadmap) {
    setState(() {
      final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      if (!roadmaps.containsKey(selectedDay)) {
        roadmaps[selectedDay] = [];
      }
      roadmaps[selectedDay]!.add(roadmap);
    });
  }

  void _deleteRoadmap(int index) {
    setState(() {
      final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      roadmaps[selectedDay]?.removeAt(index);
    });
  }

  void _editRoadmap(int index, Roadmap roadmap) {
    setState(() {
      final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      roadmaps[selectedDay]![index] = roadmap;
    });
  }

  void _updateRoadmaps() {
    setState(() {});
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  Future<void> _openDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    _selectDate(pickedDate!);
    }

  @override
  Widget build(BuildContext context) {
    final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    String selectedDateString = DateFormat('EEEE, MMM dd', 'ru').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список Дел'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _openDatePicker,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.blue[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedDateString,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DateCarousel(
              selectedDate: selectedDate,
              onDateSelected: _selectDate,
              carouselController: _carouselController,
            ),
            Expanded(
              child: roadmaps[selectedDay] == null || roadmaps[selectedDay]!.isEmpty
                  ? const Center(
                      child: Text(
                        'Пока нет планов! Начните с добавления нового плана.',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: roadmaps[selectedDay]!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: ListTile(
                            title: Text(roadmaps[selectedDay]![index].title),
                            subtitle: Text('${roadmaps[selectedDay]![index].tasks.length} задачи, приоритет: ${roadmaps[selectedDay]![index].priority.toRussianString()}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomPaint(
                                  foregroundPainter: CircleProgressPainter(roadmaps[selectedDay]![index].progress),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        '${(roadmaps[selectedDay]![index].progress * 100).round()}%',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (String result) {
                                    if (result == 'edit') {
                                      _editRoadmap(index, roadmaps[selectedDay]![index]);
                                    } else if (result == 'delete') {
                                      _deleteRoadmap(index);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(width: 8),
                                          Text('Редактировать'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(width: 8),
                                          Text('Удалить'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RoadmapPage(roadmap: roadmaps[selectedDay]![index]),
                                ),
                              );
                              _updateRoadmaps();
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'today_button',
            onPressed: () {
              setState(() {
                selectedDate = DateTime.now();
              });
            },
            backgroundColor: Colors.blueAccent,
            child: const Text('Сегодня', style: TextStyle(fontSize: 10)),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'add_button',
            onPressed: () async {
              final roadmap = await showModalBottomSheet<Roadmap>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.blue[100],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.75,
                    minChildSize: 0.5,
                    maxChildSize: 0.9,
                    expand: false,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return const RoadmapDialog();
                    },
                  );
                },
              );
              if (roadmap != null) {
                _addRoadmap(roadmap);
              }
            },
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

extension RoadmapPriorityExtension on RoadmapPriority {
  String toRussianString() {
    switch (this) {
      case RoadmapPriority.low:
        return 'Низкий';
      case RoadmapPriority.medium:
        return 'Средний';
      case RoadmapPriority.high:
        return 'Высокий';
      default:
        return '';
    }
  }
}