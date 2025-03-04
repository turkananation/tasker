import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasker/src/data/models/priority_level.dart';
import 'package:tasker/src/data/models/subtask.dart';
import 'package:tasker/src/data/models/task.dart';

class TaskProvider extends ChangeNotifier {
  late Box<Task> taskBox;
  List<Task> _tasks = [];
  String _searchQuery = '';
  PriorityLevel? _filterPriority;
  bool? _filterCompletionStatus;

  TaskProvider() {
    initialize();
  }

  Future<void> initialize() async {
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(SubtaskAdapter());
    Hive.registerAdapter(PriorityLevelAdapter()); // Register the enum adapter
    taskBox = await Hive.openBox<Task>('tasks');
    await loadTasks();
  }

  Future<void> loadTasks() async {
    _tasks = taskBox.values.toList();
    applyFiltersAndSearch();
  }

  List<Task> get tasks => _filteredTasks;
  List<Task> _filteredTasks = [];

  String get searchQuery => _searchQuery;
  PriorityLevel? get filterPriority => _filterPriority;
  bool? get filterCompletionStatus => _filterCompletionStatus;

  Future<void> addTask(Task task) async {
    await taskBox.add(task);
    await loadTasks();
  }

  Future<void> updateTask(Task updatedTask) async {
    await updatedTask.save();
    await loadTasks();
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
    await loadTasks();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    task.toggleCompleted();
    await loadTasks();
  }

  Future<void> setSearchQuery(String query) async {
    _searchQuery = query;
    await applyFiltersAndSearch();
  }

  Future<void> setFilterPriority(PriorityLevel? priority) async {
    _filterPriority = priority;
    await applyFiltersAndSearch();
  }

  Future<void> setFilterCompletionStatus(bool? status) async {
    _filterCompletionStatus = status;
    await applyFiltersAndSearch();
  }

  Future<void> applyFiltersAndSearch() async {
    _filteredTasks =
        _tasks.where((task) {
          final matchesSearch =
              _searchQuery.isEmpty ||
              task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              task.description.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
          final matchesPriority =
              _filterPriority == null || task.priorityLevel == _filterPriority;
          final matchesCompletion =
              _filterCompletionStatus == null ||
              task.isCompleted == _filterCompletionStatus;
          return matchesSearch && matchesPriority && matchesCompletion;
        }).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    taskBox.close();
    super.dispose();
  }
}
