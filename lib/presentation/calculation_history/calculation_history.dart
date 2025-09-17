import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/calculation_card_widget.dart';
import './widgets/empty_history_widget.dart';
import './widgets/history_filter_sheet.dart';
import './widgets/history_search_bar.dart';

/// Calculation History screen for reviewing and managing previous calculations
class CalculationHistory extends StatefulWidget {
  const CalculationHistory({super.key});

  @override
  State<CalculationHistory> createState() => _CalculationHistoryState();
}

class _CalculationHistoryState extends State<CalculationHistory>
    with TickerProviderStateMixin {
  // Search and filter state
  String _searchQuery = '';
  HistoryFilterType _currentFilter = HistoryFilterType.all;
  HistorySortType _currentSort = HistorySortType.dateNewest;

  // Multi-select state
  bool _isMultiSelectMode = false;
  Set<int> _selectedCalculations = {};

  // Animation controllers
  late AnimationController _refreshController;
  late AnimationController _fabController;

  // Mock calculation data
  final List<Map<String, dynamic>> _allCalculations = [
    {
      'id': 1,
      'type': 'Расчет прибыли',
      'costPrice': 15000.0,
      'sellingPrice': 22000.0,
      'profit': 7000.0,
      'profitPercentage': 31.8,
      'date': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': 2,
      'type': 'Маржа',
      'costPrice': 8500.0,
      'sellingPrice': 12000.0,
      'profit': 3500.0,
      'profitPercentage': 29.2,
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 3,
      'type': 'Наценка',
      'costPrice': 25000.0,
      'sellingPrice': 25000.0,
      'profit': 0.0,
      'profitPercentage': 0.0,
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 4,
      'type': 'Расчет прибыли',
      'costPrice': 12000.0,
      'sellingPrice': 10000.0,
      'profit': -2000.0,
      'profitPercentage': -16.7,
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'id': 5,
      'type': 'Точка безубыточности',
      'costPrice': 18000.0,
      'sellingPrice': 28000.0,
      'profit': 10000.0,
      'profitPercentage': 35.7,
      'date': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': 6,
      'type': 'Маржа',
      'costPrice': 5000.0,
      'sellingPrice': 7500.0,
      'profit': 2500.0,
      'profitPercentage': 33.3,
      'date': DateTime.now().subtract(const Duration(days: 7)),
    },
    {
      'id': 7,
      'type': 'Расчет прибыли',
      'costPrice': 30000.0,
      'sellingPrice': 45000.0,
      'profit': 15000.0,
      'profitPercentage': 33.3,
      'date': DateTime.now().subtract(const Duration(days: 10)),
    },
    {
      'id': 8,
      'type': 'Наценка',
      'costPrice': 7500.0,
      'sellingPrice': 6000.0,
      'profit': -1500.0,
      'profitPercentage': -20.0,
      'date': DateTime.now().subtract(const Duration(days: 14)),
    },
  ];

  List<Map<String, dynamic>> _filteredCalculations = [];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabController.forward();
    _applyFiltersAndSort();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar:
          _isMultiSelectMode ? _buildMultiSelectAppBar() : _buildNormalAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            if (!_isMultiSelectMode)
              HistorySearchBar(
                searchQuery: _searchQuery,
                onSearchChanged: _onSearchChanged,
                onFilterPressed: _showFilterSheet,
              ),

            // Multi-select toolbar
            if (_isMultiSelectMode) _buildMultiSelectToolbar(),

            // Main content
            Expanded(
              child: _filteredCalculations.isEmpty
                  ? _buildEmptyState()
                  : _buildCalculationsList(),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _isMultiSelectMode ? null : _buildFloatingActionButton(),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: CustomBottomBar.getCurrentIndex('/calculation-history'),
        onTap: (index) {
          final route = CustomBottomBar.getRouteByIndex(index);
          if (route != '/calculation-history') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              route,
              (route) => false,
            );
          }
        },
      ),
    );
  }

  /// Builds normal app bar
  PreferredSizeWidget _buildNormalAppBar() {
    return CustomHistoryAppBar(
      onFilterPressed: _showFilterSheet,
    );
  }

  /// Builds multi-select app bar
  PreferredSizeWidget _buildMultiSelectAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryDark,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          _exitMultiSelectMode();
        },
        icon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
      title: Text(
        'Выбрано: ${_selectedCalculations.length}',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
      ),
      actions: [
        if (_selectedCalculations.isNotEmpty)
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _selectAllCalculations();
            },
            icon: CustomIconWidget(
              iconName:
                  _selectedCalculations.length == _filteredCalculations.length
                      ? 'deselect'
                      : 'select_all',
              color: AppTheme.accentBlue,
              size: 24,
            ),
          ),
      ],
    );
  }

  /// Builds multi-select toolbar
  Widget _buildMultiSelectToolbar() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderColor.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMultiSelectAction(
            'share',
            'Поделиться',
            AppTheme.accentBlue,
            _shareSelectedCalculations,
          ),
          _buildMultiSelectAction(
            'file_download',
            'Экспорт',
            AppTheme.successGreen,
            _exportSelectedCalculations,
          ),
          _buildMultiSelectAction(
            'delete',
            'Удалить',
            AppTheme.errorRed,
            _deleteSelectedCalculations,
          ),
        ],
      ),
    );
  }

  /// Builds multi-select action button
  Widget _buildMultiSelectAction(
    String iconName,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    final isEnabled = _selectedCalculations.isNotEmpty;

    return Expanded(
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: isEnabled ? color : AppTheme.textTertiary,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isEnabled ? color : AppTheme.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds empty state
  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty || _currentFilter != HistoryFilterType.all) {
      return _buildNoResultsState();
    }
    return EmptyHistoryWidget(
      onCreateCalculation: () {
        Navigator.pushNamed(context, '/main-calculator');
      },
    );
  }

  /// Builds no results state for search/filter
  Widget _buildNoResultsState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'search_off',
                  color: colorScheme.onSurfaceVariant,
                  size: 12.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Ничего не найдено',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Попробуйте изменить поисковый запрос'
                  : 'Попробуйте изменить фильтры',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _clearFilters();
              },
              child: Text('Сбросить фильтры'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds calculations list
  Widget _buildCalculationsList() {
    return RefreshIndicator(
      onRefresh: _refreshCalculations,
      color: AppTheme.accentBlue,
      backgroundColor: AppTheme.secondaryDark,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _filteredCalculations.length,
        itemBuilder: (context, index) {
          final calculation = _filteredCalculations[index];
          final calculationId = calculation['id'] as int;
          final isSelected = _selectedCalculations.contains(calculationId);

          return CalculationCardWidget(
            calculation: calculation,
            isSelected: isSelected,
            isMultiSelectMode: _isMultiSelectMode,
            onTap: () => _onCalculationTap(calculation),
            onEdit: () => _editCalculation(calculation),
            onDuplicate: () => _duplicateCalculation(calculation),
            onShare: () => _shareCalculation(calculation),
            onDelete: () => _deleteCalculation(calculation),
            onSelectionChanged: (selected) {
              _onCalculationSelectionChanged(calculationId, selected);
            },
          );
        },
      ),
    );
  }

  /// Builds floating action button
  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _fabController,
      child: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, '/main-calculator');
        },
        backgroundColor: AppTheme.accentBlue,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
    );
  }

  /// Handles search query changes
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFiltersAndSort();
  }

  /// Shows filter bottom sheet
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => HistoryFilterSheet(
        currentFilter: _currentFilter,
        currentSort: _currentSort,
        onFilterChanged: (filter) {
          setState(() {
            _currentFilter = filter;
          });
          _applyFiltersAndSort();
        },
        onSortChanged: (sort) {
          setState(() {
            _currentSort = sort;
          });
          _applyFiltersAndSort();
        },
        onClearFilters: _clearFilters,
      ),
    );
  }

  /// Clears all filters and search
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _currentFilter = HistoryFilterType.all;
      _currentSort = HistorySortType.dateNewest;
    });
    _applyFiltersAndSort();
  }

  /// Applies filters and sorting to calculations
  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> filtered = List.from(_allCalculations);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((calc) {
        final type = (calc['type'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return type.contains(query);
      }).toList();
    }

    // Apply result filter
    switch (_currentFilter) {
      case HistoryFilterType.profit:
        filtered =
            filtered.where((calc) => (calc['profit'] as double) > 0).toList();
        break;
      case HistoryFilterType.loss:
        filtered =
            filtered.where((calc) => (calc['profit'] as double) < 0).toList();
        break;
      case HistoryFilterType.breakEven:
        filtered =
            filtered.where((calc) => (calc['profit'] as double) == 0).toList();
        break;
      case HistoryFilterType.all:
        break;
    }

    // Apply sorting
    switch (_currentSort) {
      case HistorySortType.dateNewest:
        filtered.sort(
            (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
        break;
      case HistorySortType.dateOldest:
        filtered.sort(
            (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
        break;
      case HistorySortType.profitHighest:
        filtered.sort(
            (a, b) => (b['profit'] as double).compareTo(a['profit'] as double));
        break;
      case HistorySortType.profitLowest:
        filtered.sort(
            (a, b) => (a['profit'] as double).compareTo(b['profit'] as double));
        break;
      case HistorySortType.typeAscending:
        filtered.sort(
            (a, b) => (a['type'] as String).compareTo(b['type'] as String));
        break;
      case HistorySortType.typeDescending:
        filtered.sort(
            (a, b) => (b['type'] as String).compareTo(a['type'] as String));
        break;
    }

    setState(() {
      _filteredCalculations = filtered;
    });
  }

  /// Handles calculation card tap
  void _onCalculationTap(Map<String, dynamic> calculation) {
    Navigator.pushNamed(
      context,
      '/calculation-details',
      arguments: calculation,
    );
  }

  /// Handles calculation selection change
  void _onCalculationSelectionChanged(int calculationId, bool selected) {
    setState(() {
      if (selected) {
        _selectedCalculations.add(calculationId);
        if (!_isMultiSelectMode) {
          _isMultiSelectMode = true;
          _fabController.reverse();
        }
      } else {
        _selectedCalculations.remove(calculationId);
        if (_selectedCalculations.isEmpty) {
          _exitMultiSelectMode();
        }
      }
    });
  }

  /// Exits multi-select mode
  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedCalculations.clear();
    });
    _fabController.forward();
  }

  /// Selects or deselects all calculations
  void _selectAllCalculations() {
    setState(() {
      if (_selectedCalculations.length == _filteredCalculations.length) {
        _selectedCalculations.clear();
      } else {
        _selectedCalculations =
            _filteredCalculations.map((calc) => calc['id'] as int).toSet();
      }
    });
  }

  /// Refreshes calculations list
  Future<void> _refreshCalculations() async {
    _refreshController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.reset();
    _applyFiltersAndSort();
  }

  /// Edits a calculation
  void _editCalculation(Map<String, dynamic> calculation) {
    Navigator.pushNamed(
      context,
      '/main-calculator',
      arguments: calculation,
    );
  }

  /// Duplicates a calculation
  void _duplicateCalculation(Map<String, dynamic> calculation) {
    final duplicated = Map<String, dynamic>.from(calculation);
    duplicated['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicated['date'] = DateTime.now();

    setState(() {
      _allCalculations.insert(0, duplicated);
    });
    _applyFiltersAndSort();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Расчет скопирован'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  /// Shares a calculation
  void _shareCalculation(Map<String, dynamic> calculation) {
    final profit = calculation['profit'] as double;
    final profitPercentage = calculation['profitPercentage'] as double;
    final shareText = '''
Расчет прибыли - ${calculation['type']}

Себестоимость: ${(calculation['costPrice'] as double).toStringAsFixed(0)} ₽
Цена продажи: ${(calculation['sellingPrice'] as double).toStringAsFixed(0)} ₽
Прибыль: ${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(0)} ₽
Маржа: ${profitPercentage >= 0 ? '+' : ''}${profitPercentage.toStringAsFixed(1)}%

Создано в Resale Calculator Pro
    ''';

    // Here you would implement actual sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Расчет готов к отправке'),
        backgroundColor: AppTheme.accentBlue,
      ),
    );
  }

  /// Deletes a calculation
  void _deleteCalculation(Map<String, dynamic> calculation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.dialogColor,
        title: Text(
          'Удалить расчет?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
        ),
        content: Text(
          'Это действие нельзя отменить.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allCalculations
                    .removeWhere((calc) => calc['id'] == calculation['id']);
              });
              _applyFiltersAndSort();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Расчет удален'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: Text('Удалить'),
          ),
        ],
      ),
    );
  }

  /// Shares selected calculations
  void _shareSelectedCalculations() {
    final selectedCalcs = _filteredCalculations
        .where((calc) => _selectedCalculations.contains(calc['id']))
        .toList();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${selectedCalcs.length} расчетов готовы к отправке'),
        backgroundColor: AppTheme.accentBlue,
      ),
    );
    _exitMultiSelectMode();
  }

  /// Exports selected calculations
  void _exportSelectedCalculations() {
    final selectedCalcs = _filteredCalculations
        .where((calc) => _selectedCalculations.contains(calc['id']))
        .toList();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${selectedCalcs.length} расчетов экспортированы'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
    _exitMultiSelectMode();
  }

  /// Deletes selected calculations
  void _deleteSelectedCalculations() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.dialogColor,
        title: Text(
          'Удалить выбранные расчеты?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
        ),
        content: Text(
          'Будет удалено ${_selectedCalculations.length} расчетов. Это действие нельзя отменить.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _allCalculations.removeWhere(
                  (calc) => _selectedCalculations.contains(calc['id']),
                );
              });
              _applyFiltersAndSort();
              _exitMultiSelectMode();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Расчеты удалены'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
