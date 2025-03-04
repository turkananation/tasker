import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasker/src/data/models/priority_level.dart';
import 'package:tasker/src/data/models/subtask.dart';
import 'package:tasker/src/data/models/task.dart';

class TaskProvider extends ChangeNotifier {
  late Box<Task> taskBox;
  List<Task> _tasks = [];
  String _searchQuery = '';
  String? _errorMessage;
  PriorityLevel? _filterPriority;
  bool? _filterCompletionStatus;

  TaskProvider({Box<Task>? taskBox}) {
    // Optional taskBox parameter
    if (taskBox != null) {
      this.taskBox = taskBox; // Use injected box if provided
      loadTasks(); // Load tasks immediately if box is injected
    } else {
      initialize(); // Otherwise, initialize Hive and open box as before
    }
  }

  Future<void> initialize() async {
    try {
      Hive.registerAdapter(TaskAdapter());
      Hive.registerAdapter(SubtaskAdapter());
      Hive.registerAdapter(PriorityLevelAdapter()); // Register the enum adapter
    } catch (e) {
      setErrorMessage('Error registering Hive adapters: $e');
      rethrow; // Re-throw the error to indicate initialization failure
    }

    try {
      taskBox = await Hive.openBox<Task>('tasks');
      await loadTasks();
    } catch (e) {
      setErrorMessage(
        'Error opening Hive box or loading tasks during initialization: $e',
      );
      rethrow; // Re-throw the error to indicate initialization failure
    }
  }

  Future<void> loadTasks() async {
    try {
      _tasks = taskBox.values.toList();
      applyFiltersAndSearch();
    } catch (e) {
      setErrorMessage('Error loading tasks from Hive box: $e');
      _tasks = [];
      applyFiltersAndSearch(); // Apply filters to empty list
    }
  }

  List<Task> get tasks => _filteredTasks;
  List<Task> _filteredTasks = [];

  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;
  PriorityLevel? get filterPriority => _filterPriority;
  bool? get filterCompletionStatus => _filterCompletionStatus;

  Future<void> addTask(Task task) async {
    try {
      await taskBox.add(task);
      await loadTasks();
    } catch (e) {
      setErrorMessage('Error adding task to Hive box: $e');
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    try {
      await updatedTask.save();
      await loadTasks();
    } catch (e) {
      setErrorMessage('Error updating task: $e');
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      await task.delete();
      await loadTasks();
    } catch (e) {
      setErrorMessage('Error deleting task: $e');
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    try {
      task.toggleCompleted();
      await loadTasks();
    } catch (e) {
      setErrorMessage('Error toggling task completion: $e');
    }
  }

  Future<void> setSearchQuery(String query) async {
    _searchQuery = query;
    await applyFiltersAndSearch();
  }

  Future<void> setErrorMessage(String? message) async {
    _errorMessage = message;
    notifyListeners();
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
    try {
      _filteredTasks =
          _tasks.where((task) {
            final matchesSearch =
                _searchQuery.isEmpty ||
                task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                task.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
            final matchesPriority =
                _filterPriority == null ||
                task.priorityLevel == _filterPriority;
            final matchesCompletion =
                _filterCompletionStatus == null ||
                task.isCompleted == _filterCompletionStatus;
            return matchesSearch && matchesPriority && matchesCompletion;
          }).toList();
      notifyListeners();
    } catch (e) {
      setErrorMessage('Error applying filters and search: $e');
      _filteredTasks = []; // Ensure filtered tasks is empty in case of error
      notifyListeners();
    }
  }

  @override
  void dispose() {
    try {
      taskBox.close();
    } catch (e) {
      setErrorMessage('Error closing Hive box during dispose: $e');
    }
    super.dispose();
  }
}
