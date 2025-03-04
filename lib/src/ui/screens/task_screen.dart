import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasker/src/data/models/subtask.dart';
import 'package:tasker/src/data/models/task.dart';
import 'package:tasker/src/data/providers/task_provider.dart';

import '../../data/models/priority_level.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  TaskScreenState createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  final TextEditingController _searchController = TextEditingController();
  PriorityLevel? _selectedPriorityFilter;
  bool? _selectedCompletionFilter;

  @override
  void initState() {
    super.initState();
    _showErrorMsgIfNecessary(
      context,
      Provider.of<TaskProvider>(context, listen: false),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      body: Column(
        // Added Column here
        children: [
          _buildHeader(context, taskProvider), // Inserted _buildHeader here
          Expanded(
            // Wrapped Consumer with Expanded
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                if (taskProvider.tasks.isEmpty) {
                  return const Center(
                    child: Text('No tasks yet. Add a new task!'),
                  );
                }
                return ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    return _buildTaskTile(context, taskProvider, task);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context, taskProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskTile(
    BuildContext context,
    TaskProvider taskProvider,
    Task task,
  ) {
    return ExpansionTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (bool? newValue) {
          taskProvider.toggleTaskCompletion(task);
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration:
              task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle:
          task.dueDate != null ? Text('Due: ${task.formattedDueDate}') : null,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          _showDeleteConfirmationDialog(context, taskProvider, task);
        },
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description.isNotEmpty)
                Text('Description: ${task.description}'),
              Text('Priority: ${task.priorityLevel.name.toUpperCase()}'),
              const SizedBox(height: 8),
              const Text(
                'Subtasks:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (task.subtasks.isEmpty) const Text('  No subtasks added.'),
              ...task.subtasks.map(
                (subtask) => Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: subtask.isCompleted,
                        onChanged: (bool? newValue) {
                          setState(() {
                            subtask.isCompleted =
                                newValue ??
                                false; // Update the subtask's local state
                          });
                          taskProvider.updateTask(task);
                          // Update the parent Task in Hive
                          _showErrorMsgIfNecessary(context, taskProvider);
                        },
                      ),
                      Text(
                        subtask.name,
                        style: TextStyle(
                          decoration:
                              subtask.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showEditTaskDialog(context, taskProvider, task);
                    },
                    child: const Text('Edit Task'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _showAddSubtaskDialog(context, taskProvider, task);
                    },
                    child: const Text('Add Subtask'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddTaskDialog(
    BuildContext context,
    TaskProvider taskProvider, {
    Task? taskToEdit,
  }) {
    final titleController = TextEditingController(
      text: taskToEdit?.title ?? '',
    );
    final descriptionController = TextEditingController(
      text: taskToEdit?.description ?? '',
    );
    DateTime? selectedDueDate = taskToEdit?.dueDate;
    PriorityLevel selectedPriority =
        taskToEdit?.priorityLevel ?? PriorityLevel.low;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(taskToEdit == null ? 'Add New Task' : 'Edit Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      decoration: const InputDecoration(hintText: 'Task title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Description (optional)',
                      ),
                      maxLines: 3,
                    ),
                    ListTile(
                      title: Text(
                        selectedDueDate == null
                            ? 'Set Due Date'
                            : 'Due Date: ${DateFormat('yyyy-MM-dd').format(selectedDueDate!)}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDueDate ?? DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2026),
                        );
                        if (pickedDate != null &&
                            pickedDate != selectedDueDate) {
                          setState(() {
                            selectedDueDate = pickedDate;
                          });
                        }
                      },
                    ),
                    DropdownButtonFormField<PriorityLevel>(
                      value: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Priority Level',
                      ),
                      items:
                          PriorityLevel.values.map((PriorityLevel priority) {
                            return DropdownMenuItem<PriorityLevel>(
                              value: priority,
                              child: Text(priority.name.toUpperCase()),
                            );
                          }).toList(),
                      onChanged: (PriorityLevel? newValue) {
                        setState(() {
                          selectedPriority = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(taskToEdit == null ? 'Add' : 'Save'),
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      if (taskToEdit == null) {
                        // Adding a new task
                        final task = Task(
                          title: titleController.text,
                          description: descriptionController.text,
                          dueDate: selectedDueDate,
                          priorityLevel: selectedPriority,
                        );
                        taskProvider.addTask(task);
                        _showErrorMsgIfNecessary(context, taskProvider);
                      } else {
                        // Editing an existing task - UPDATE EXISTING OBJECT
                        taskToEdit.title = titleController.text;
                        taskToEdit.description = descriptionController.text;
                        taskToEdit.dueDate = selectedDueDate;
                        taskToEdit.priorityLevel = selectedPriority;
                        taskProvider.updateTask(taskToEdit);
                        _showErrorMsgIfNecessary(context, taskProvider);
                      }
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTaskDialog(
    BuildContext context,
    TaskProvider taskProvider,
    Task task,
  ) {
    _showAddTaskDialog(context, taskProvider, taskToEdit: task);
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    TaskProvider taskProvider,
    Task task,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                taskProvider.deleteTask(task);
                _showErrorMsgIfNecessary(context, taskProvider);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context, TaskProvider taskProvider) {
    _searchController.text =
        taskProvider.searchQuery; // Initialize with current search query
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Tasks'),
          content: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter search term'),
            onChanged: (value) {
              taskProvider.setSearchQuery(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Clear'),
              onPressed: () {
                _searchController.clear();
                taskProvider.setSearchQuery('');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context, TaskProvider taskProvider) {
    _selectedPriorityFilter = taskProvider.filterPriority;
    _selectedCompletionFilter = taskProvider.filterCompletionStatus;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Filter Tasks'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<PriorityLevel?>(
                    value: _selectedPriorityFilter,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: [
                      const DropdownMenuItem<PriorityLevel?>(
                        value: null,
                        child: Text('All Priorities'),
                      ),
                      ...PriorityLevel.values.map((PriorityLevel priority) {
                        return DropdownMenuItem<PriorityLevel?>(
                          value: priority,
                          child: Text(priority.name.toUpperCase()),
                        );
                      }),
                    ],
                    onChanged: (PriorityLevel? newValue) {
                      setState(() {
                        _selectedPriorityFilter = newValue;
                      });
                    },
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text('Completion Status:'),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          ChoiceChip(
                            label: const Text('All'),
                            selected: _selectedCompletionFilter == null,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedCompletionFilter = null;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Pending'),
                            selected: _selectedCompletionFilter == false,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedCompletionFilter = false;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Done'),
                            selected: _selectedCompletionFilter == true,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedCompletionFilter = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Clear Filters'),
                  onPressed: () {
                    taskProvider.setFilterPriority(null);
                    taskProvider.setFilterCompletionStatus(null);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Apply Filters'),
                  onPressed: () {
                    taskProvider.setFilterPriority(_selectedPriorityFilter);
                    taskProvider.setFilterCompletionStatus(
                      _selectedCompletionFilter,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, TaskProvider taskProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10.0,
      ), // Added padding for header
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Tasks',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _showSearchDialog(context, taskProvider);
                },
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  _showFilterDialog(context, taskProvider);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddSubtaskDialog(
    BuildContext context,
    TaskProvider taskProvider,
    Task task,
  ) {
    final subtaskController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Subtask'),
          content: TextField(
            controller: subtaskController,
            decoration: const InputDecoration(hintText: 'Subtask name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (subtaskController.text.isNotEmpty) {
                  setState(() {
                    // Dart lists are immutable by default, so we create a new mutable list from the existing subtasks
                    List<Subtask> mutableSubtasks = List.from(task.subtasks);
                    mutableSubtasks.add(Subtask(name: subtaskController.text));
                    task.subtasks =
                        mutableSubtasks; // Assign the new mutable list back to task.subtasks

                    taskProvider.updateTask(task); // Save task with new subtask
                    _showErrorMsgIfNecessary(context, taskProvider);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorMsgIfNecessary(
    BuildContext context,
    TaskProvider taskProvider,
  ) {
    final errorMessage = taskProvider.errorMessage;
    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      taskProvider.setErrorMessage(null); // Clear error message
    }
  }
}
