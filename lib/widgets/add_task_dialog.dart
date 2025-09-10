import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_sizes.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(String) onAddTask;

  const AddTaskDialog({
    super.key,
    required this.onAddTask,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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
    
    // Auto focus on text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _textController.text.trim();
    if (title.isNotEmpty) {
      widget.onAddTask(title);
      Navigator.of(context).pop();
    }
  }

  void _closeDialog() {
    _animationController.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: AppSizes.paddingAll24,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.dialogBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowMedium,
                      blurRadius: AppSizes.shadowBlurRadiusLarge,
                      offset: const Offset(AppSizes.shadowOffsetX, AppSizes.shadowOffsetYLarge),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: AppSizes.paddingAll12,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlueWithOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSizes.radius12),
                          ),
                          child: const Icon(
                            Icons.add_task_rounded,
                            color: AppColors.primaryBlue,
                            size: AppSizes.icon24,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing16),
                        const Expanded(
                          child: Text(
                            'Add New Task',
                            style: AppTextStyles.dialogTitle,
                          ),
                        ),
                        IconButton(
                          onPressed: _closeDialog,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppSizes.spacing24),
                    
                    // Text Field
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(AppSizes.radius15),
                        border: Border.all(
                          color: AppColors.primaryBlueWithOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Enter task title...',
                          hintStyle: AppTextStyles.dialogHint,
                          border: InputBorder.none,
                          contentPadding: AppSizes.paddingAll16,
                        ),
                        style: AppTextStyles.dialogInput,
                        maxLines: 3,
                        minLines: 1,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addTask(),
                      ),
                    ),
                    
                    const SizedBox(height: AppSizes.spacing24),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: _closeDialog,
                            style: TextButton.styleFrom(
                              padding: AppSizes.paddingVertical16,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSizes.radius12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: AppTextStyles.labelLarge,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _addTask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: AppColors.white,
                              padding: AppSizes.paddingVertical16,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSizes.radius12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Add Task',
                              style: AppTextStyles.buttonLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
