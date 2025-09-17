import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Filter options for calculation history
enum HistoryFilterType {
  all,
  profit,
  loss,
  breakEven,
}

enum HistorySortType {
  dateNewest,
  dateOldest,
  profitHighest,
  profitLowest,
  typeAscending,
  typeDescending,
}

/// Bottom sheet widget for filtering and sorting calculation history
class HistoryFilterSheet extends StatefulWidget {
  final HistoryFilterType currentFilter;
  final HistorySortType currentSort;
  final ValueChanged<HistoryFilterType>? onFilterChanged;
  final ValueChanged<HistorySortType>? onSortChanged;
  final VoidCallback? onClearFilters;

  const HistoryFilterSheet({
    super.key,
    this.currentFilter = HistoryFilterType.all,
    this.currentSort = HistorySortType.dateNewest,
    this.onFilterChanged,
    this.onSortChanged,
    this.onClearFilters,
  });

  @override
  State<HistoryFilterSheet> createState() => _HistoryFilterSheetState();
}

class _HistoryFilterSheetState extends State<HistoryFilterSheet> {
  late HistoryFilterType _selectedFilter;
  late HistorySortType _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.currentFilter;
    _selectedSort = widget.currentSort;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Фильтры и сортировка',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),

          // Filter section
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Фильтр по результату',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ),
                SizedBox(height: 2.h),

                // Filter options
                _buildFilterOption(
                  context,
                  HistoryFilterType.all,
                  'Все расчеты',
                  'show_chart',
                  colorScheme.onSurface,
                ),
                _buildFilterOption(
                  context,
                  HistoryFilterType.profit,
                  'Прибыльные',
                  'trending_up',
                  AppTheme.successGreen,
                ),
                _buildFilterOption(
                  context,
                  HistoryFilterType.loss,
                  'Убыточные',
                  'trending_down',
                  AppTheme.errorRed,
                ),
                _buildFilterOption(
                  context,
                  HistoryFilterType.breakEven,
                  'Безубыточные',
                  'trending_flat',
                  AppTheme.warningOrange,
                ),
              ],
            ),
          ),

          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),

          // Sort section
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Сортировка',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ),
                SizedBox(height: 2.h),

                // Sort options
                _buildSortOption(
                  context,
                  HistorySortType.dateNewest,
                  'Сначала новые',
                  'schedule',
                ),
                _buildSortOption(
                  context,
                  HistorySortType.dateOldest,
                  'Сначала старые',
                  'history',
                ),
                _buildSortOption(
                  context,
                  HistorySortType.profitHighest,
                  'По убыванию прибыли',
                  'arrow_downward',
                ),
                _buildSortOption(
                  context,
                  HistorySortType.profitLowest,
                  'По возрастанию прибыли',
                  'arrow_upward',
                ),
                _buildSortOption(
                  context,
                  HistorySortType.typeAscending,
                  'По типу (А-Я)',
                  'sort_by_alpha',
                ),
                _buildSortOption(
                  context,
                  HistorySortType.typeDescending,
                  'По типу (Я-А)',
                  'sort_by_alpha',
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Clear filters button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedFilter = HistoryFilterType.all;
                        _selectedSort = HistorySortType.dateNewest;
                      });
                      widget.onClearFilters?.call();
                    },
                    child: Text('Сбросить'),
                  ),
                ),
                SizedBox(width: 4.w),

                // Apply button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      widget.onFilterChanged?.call(_selectedFilter);
                      widget.onSortChanged?.call(_selectedSort);
                      Navigator.pop(context);
                    },
                    child: Text('Применить'),
                  ),
                ),
              ],
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  /// Builds a filter option tile
  Widget _buildFilterOption(
    BuildContext context,
    HistoryFilterType filterType,
    String title,
    String iconName,
    Color iconColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedFilter == filterType;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedFilter = filterType;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: colorScheme.primary, width: 1)
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: iconColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              ),
              if (isSelected)
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: colorScheme.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a sort option tile
  Widget _buildSortOption(
    BuildContext context,
    HistorySortType sortType,
    String title,
    String iconName,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedSort == sortType;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedSort = sortType;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: colorScheme.primary, width: 1)
                : null,
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              ),
              if (isSelected)
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: colorScheme.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
