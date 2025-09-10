import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_sizes.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDelete() async {
    if (_isDeleting) return; // Prevent multiple deletions
    
    setState(() {
      _isDeleting = true;
    });
    
    // Start the reverse animation
    await _animationController.reverse();
    
    // Call the delete callback after animation completes
    if (mounted) {
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: EdgeInsets.only(bottom: AppSizes.listItemSpacing),
              decoration: BoxDecoration(
                color: widget.task.isCompleted 
                    ? AppColors.lightGray 
                    : AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.radius15),
                border: Border.all(
                  color: widget.task.isCompleted 
                      ? AppColors.borderLight 
                      : AppColors.primaryBlueWithOpacity(0.2),
                  width: AppSizes.inputBorderWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: AppSizes.shadowBlurRadius,
                    offset: const Offset(AppSizes.shadowOffsetX, AppSizes.shadowOffsetY),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing16,
                    vertical: AppSizes.spacing8,
                  ),
                  leading: AnimatedContainer(
                    duration: const Duration(milliseconds: AppSizes.animationDurationMedium),
                    width: AppSizes.checkboxSize,
                    height: AppSizes.checkboxSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.task.isCompleted
                          ? AppColors.successGreen
                          : Colors.transparent,
                      border: Border.all(
                        color: widget.task.isCompleted
                            ? AppColors.successGreen
                            : AppColors.primaryBlue,
                        width: AppSizes.checkboxBorderWidth,
                      ),
                    ),
                    child: widget.task.isCompleted
                        ? const Icon(
                            Icons.check,
                            color: AppColors.white,
                            size: AppSizes.icon16,
                          )
                        : null,
                  ),
                  title: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: AppSizes.animationDurationMedium),
                    style: widget.task.isCompleted
                        ? AppTextStyles.taskTitleCompleted
                        : AppTextStyles.taskTitle,
                    child: Text(widget.task.title),
                  ),
                  trailing: AnimatedOpacity(
                    duration: const Duration(milliseconds: AppSizes.animationDurationFast),
                    opacity: _isDeleting ? 0.0 : 1.0,
                    child: IconButton(
                      onPressed: _handleDelete,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.errorRed,
                        size: AppSizes.icon20,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: AppSizes.buttonHeightSmall,
                        minHeight: AppSizes.buttonHeightSmall,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  onTap: widget.onToggle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
