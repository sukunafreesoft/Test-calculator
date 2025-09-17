import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual calculation card widget for displaying calculation history items
class CalculationCardWidget extends StatelessWidget {
  final Map<String, dynamic> calculation;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool isMultiSelectMode;
  final ValueChanged<bool>? onSelectionChanged;

  const CalculationCardWidget({
    super.key,
    required this.calculation,
    this.onTap,
    this.onEdit,
    this.onDuplicate,
    this.onShare,
    this.onDelete,
    this.isSelected = false,
    this.isMultiSelectMode = false,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final profit = (calculation['profit'] as double?) ?? 0.0;
    final profitPercentage =
        (calculation['profitPercentage'] as double?) ?? 0.0;
    final isProfit = profit > 0;
    final isBreakEven = profit == 0;

    final profitColor = isBreakEven
        ? AppTheme.warningOrange
        : isProfit
            ? AppTheme.successGreen
            : AppTheme.errorRed;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(calculation['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                onEdit?.call();
              },
              backgroundColor: AppTheme.accentBlue,
              foregroundColor: AppTheme.textPrimary,
              icon: Icons.edit,
              label: 'Изменить',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                onDuplicate?.call();
              },
              backgroundColor: AppTheme.successGreen,
              foregroundColor: AppTheme.textPrimary,
              icon: Icons.copy,
              label: 'Копировать',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                onShare?.call();
              },
              backgroundColor: AppTheme.warningOrange,
              foregroundColor: AppTheme.textPrimary,
              icon: Icons.share,
              label: 'Поделиться',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.mediumImpact();
                onDelete?.call();
              },
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.textPrimary,
              icon: Icons.delete,
              label: 'Удалить',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            if (isMultiSelectMode) {
              onSelectionChanged?.call(!isSelected);
            } else {
              onTap?.call();
            }
          },
          onLongPress: () {
            HapticFeedback.mediumImpact();
            if (!isMultiSelectMode) {
              onSelectionChanged?.call(true);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with type icon and selection checkbox
                  Row(
                    children: [
                      // Calculation type icon
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: profitColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: _getCalculationTypeIcon(),
                          color: profitColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 3.w),

                      // Calculation type and date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              calculation['type'] as String? ??
                                  'Расчет прибыли',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              _formatDate(calculation['date'] as DateTime?),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // Selection checkbox in multi-select mode
                      if (isMultiSelectMode)
                        Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) => onSelectionChanged?.call(value ?? false),
                          activeColor: colorScheme.primary,
                        ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Calculation values row
                  Row(
                    children: [
                      // Cost price
                      Expanded(
                        child: _buildValueColumn(
                          context,
                          'Себестоимость',
                          '${(calculation['costPrice'] as double?)?.toStringAsFixed(0) ?? '0'} ₽',
                          colorScheme.onSurfaceVariant,
                        ),
                      ),

                      // Selling price
                      Expanded(
                        child: _buildValueColumn(
                          context,
                          'Цена продажи',
                          '${(calculation['sellingPrice'] as double?)?.toStringAsFixed(0) ?? '0'} ₽',
                          colorScheme.onSurface,
                        ),
                      ),

                      // Profit
                      Expanded(
                        child: _buildValueColumn(
                          context,
                          'Прибыль',
                          '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(0)} ₽',
                          profitColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Profit percentage badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: profitColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: isProfit
                                  ? 'trending_up'
                                  : isBreakEven
                                      ? 'trending_flat'
                                      : 'trending_down',
                              color: profitColor,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${profitPercentage >= 0 ? '+' : ''}${profitPercentage.toStringAsFixed(1)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: profitColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // Quick action buttons
                      if (!isMultiSelectMode)
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                onShare?.call();
                              },
                              icon: CustomIconWidget(
                                iconName: 'share',
                                color: colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 8.w,
                                minHeight: 4.h,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                onEdit?.call();
                              },
                              icon: CustomIconWidget(
                                iconName: 'edit',
                                color: colorScheme.primary,
                                size: 20,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 8.w,
                                minHeight: 4.h,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a value column with label and value
  Widget _buildValueColumn(
      BuildContext context, String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Gets the appropriate icon for calculation type
  String _getCalculationTypeIcon() {
    final type = calculation['type'] as String? ?? '';
    switch (type.toLowerCase()) {
      case 'маржа':
        return 'percent';
      case 'наценка':
        return 'add_circle_outline';
      case 'точка безубыточности':
        return 'balance';
      default:
        return 'calculate';
    }
  }

  /// Formats date to Russian format
  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Вчера ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      final weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
      return '${weekdays[date.weekday - 1]} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
  }
}