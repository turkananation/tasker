import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasker/src/data/models/priority_level.dart';
import 'package:tasker/src/data/models/task.dart';

class TaskProvider extends ChangeNotifier {
  late Box<Task> _taskBox;
  List<Task> _tasks = [];
  String _searchQuery = '';
  PriorityLevel? _filterPriority;
  bool? _filterCompletionStatus;

  TaskProvider() {
    _openBox();
  }

  Future<void> _openBox() async {
    _taskBox = await Hive.openBox<Task>('tasks');
    _loadTasks();
  }

  void _loadTasks() {
    _tasks = _taskBox.values.toList();
    _applyFiltersAndSearch();
  }

  List<Task> get tasks => _filteredTasks;
  List<Task> _filteredTasks = [];

  String get searchQuery => _searchQuery;
  PriorityLevel? get filterPriority => _filterPriority;
  bool? get filterCompletionStatus => _filterCompletionStatus;

  void addTask(Task task) {
    _taskBox.add(task);
    _loadTasks();
  }

  void updateTask(Task updatedTask) {
    updatedTask.save();
    _loadTasks();
  }

  void deleteTask(Task task) {
    task.delete();
    _loadTasks();
  }

  void toggleTaskCompletion(Task task) {
    task.toggleCompleted();
    _loadTasks();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSearch();
  }

  void setFilterPriority(PriorityLevel? priority) {
    _filterPriority = priority;
    _applyFiltersAndSearch();
  }

  void setFilterCompletionStatus(bool? status) {
    _filterCompletionStatus = status;
    _applyFiltersAndSearch();
  }

  void _applyFiltersAndSearch() {
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
}
