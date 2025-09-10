import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_dialog.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_sizes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<Task> _tasks = [];
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    ));
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _addTask(String title) {
    if (title.trim().isNotEmpty) {
      setState(() {
        _tasks.add(Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title.trim(),
          createdAt: DateTime.now(),
        ));
      });
      
      // Haptic feedback
      HapticFeedback.lightImpact();
    }
  }

  void _toggleTask(String taskId) {
    setState(() {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex] = _tasks[taskIndex].copyWith(
          isCompleted: !_tasks[taskIndex].isCompleted,
        );
      }
    });
    
    // Haptic feedback
    HapticFeedback.mediumImpact();
  }

  void _deleteTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });
    
    // Haptic feedback
    HapticFeedback.heavyImpact();
    
    // Debug print to check task count
    print('Tasks after deletion: ${_tasks.length}');
    print('Completed tasks: ${_completedTasks}');
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAddTask: _addTask,
      ),
    );
  }

  int get _completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get _totalTasks => _tasks.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: AppSizes.paddingAll20,
                child: Row(
                  children: [
                    Container(
                      padding: AppSizes.paddingAll12,
                      decoration: BoxDecoration(
                        color: AppColors.whiteWithOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppSizes.radius15),
                      ),
                      child: const Icon(
                        Icons.checklist_rounded,
                        color: AppColors.white,
                        size: AppSizes.icon28,
                      ),
                    ),
                    SizedBox(width: AppSizes.spacing15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TaskMaster',
                            style: AppTextStyles.appBarTitle,
                          ),
                          Text(
                            _totalTasks > 0 
                                ? '$_completedTasks of $_totalTasks completed'
                                : 'No tasks yet',
                            style: AppTextStyles.appBarSubtitle.copyWith(
                              color: AppColors.whiteWithOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_totalTasks > 0)
                      Container(
                        padding: AppSizes.paddingAll8,
                        decoration: BoxDecoration(
                          color: AppColors.whiteWithOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppSizes.radius12),
                        ),
                        child: Text(
                          '${(_completedTasks / _totalTasks * 100).round()}%',
                          style: AppTextStyles.taskCounter,
                        ),
                      ),
                  ],
                ),
              ),

              // Progress Bar
              if (_totalTasks > 0)
                Container(
                  margin: AppSizes.marginHorizontal20,
                  height: AppSizes.progressBarHeight,
                  decoration: BoxDecoration(
                    color: AppColors.whiteWithOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSizes.progressBarBorderRadius),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _completedTasks / _totalTasks,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSizes.progressBarBorderRadius),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: AppSizes.spacing20),

              // Tasks List
              Expanded(
                child: Container(
                  margin: AppSizes.marginHorizontal20,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowMedium,
                        blurRadius: AppSizes.shadowBlurRadiusLarge,
                        offset: const Offset(AppSizes.shadowOffsetX, AppSizes.shadowOffsetYLarge),
                      ),
                    ],
                  ),
                  child: _tasks.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          key: ValueKey(_tasks.length), // Force rebuild when task count changes
                          padding: AppSizes.paddingAll20,
                          itemCount: _tasks.length,
                          itemBuilder: (context, index) {
                            final task = _tasks[index];
                            return TaskItem(
                              key: ValueKey(task.id), // Unique key for each task
                              task: task,
                              onToggle: () => _toggleTask(task.id),
                              onDelete: () => _deleteTask(task.id),
                            );
                          },
                        ),
                ),
              ),

              const SizedBox(height: AppSizes.spacing20),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton.extended(
              onPressed: _showAddTaskDialog,
              backgroundColor: AppColors.primaryPink,
              foregroundColor: AppColors.white,
              elevation: AppSizes.fabElevation,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Add Task',
                style: AppTextStyles.buttonLarge,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueWithOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              size: AppSizes.icon80,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: AppSizes.spacing20),
          const Text(
            'No tasks yet!',
            style: AppTextStyles.emptyStateTitle,
          ),
          const SizedBox(height: AppSizes.spacing10),
          const Text(
            'Tap the button below to add your first task',
            style: AppTextStyles.emptyStateSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
