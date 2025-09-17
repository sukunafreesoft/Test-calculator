import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/action_buttons.dart';
import './widgets/calculation_breakdown.dart';
import './widgets/calculation_summary_card.dart';
import './widgets/expandable_section.dart';
import './widgets/profit_analysis_chart.dart';

/// Calculation Details screen providing comprehensive breakdown of profit calculations
/// with sharing and modification capabilities optimized for mobile viewing
class CalculationDetails extends StatefulWidget {
  const CalculationDetails({super.key});

  @override
  State<CalculationDetails> createState() => _CalculationDetailsState();
}

class _CalculationDetailsState extends State<CalculationDetails> {
  final ScrollController _scrollController = ScrollController();
  bool _isEditMode = false;
  double _scrollPosition = 0.0;

  // Mock calculation data - in real app this would come from arguments or state management
  final Map<String, dynamic> _calculationData = {
    "id": 1,
    "costPrice": 15000.0,
    "sellingPrice": 22500.0,
    "category": "Электроника",
    "productName": "iPhone 13 Pro",
    "date": DateTime.now().subtract(const Duration(hours: 2)),
    "notes": "Покупка с рук, состояние отличное",
    "currency": "₽",
    "taxes": 0.0,
    "additionalCosts": 500.0,
  };

  // Input data for expandable sections
  late List<Map<String, dynamic>> _inputDataItems;
  late List<Map<String, dynamic>> _calculationItems;
  late List<Map<String, dynamic>> _analysisItems;

  @override
  void initState() {
    super.initState();
    _initializeDataItems();

    // Save scroll position when scrolling
    _scrollController.addListener(() {
      _scrollPosition = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeDataItems() {
    final double costPrice =
        (_calculationData['costPrice'] as num?)?.toDouble() ?? 0.0;
    final double sellingPrice =
        (_calculationData['sellingPrice'] as num?)?.toDouble() ?? 0.0;
    final double additionalCosts =
        (_calculationData['additionalCosts'] as num?)?.toDouble() ?? 0.0;
    final double taxes = (_calculationData['taxes'] as num?)?.toDouble() ?? 0.0;
    final double profit = sellingPrice - costPrice - additionalCosts - taxes;
    final double profitMargin =
        costPrice > 0 ? (profit / costPrice) * 100 : 0.0;
    final double markup = costPrice > 0 ? (profit / costPrice) * 100 : 0.0;
    final double roi = costPrice > 0 ? (profit / costPrice) * 100 : 0.0;

    _inputDataItems = [
      {
        "label": "Товар",
        "value": _calculationData['productName'] ?? 'Не указан',
        "type": "text",
      },
      {
        "label": "Категория",
        "value": _calculationData['category'] ?? 'Не указана',
        "type": "text",
      },
      {
        "label": "Себестоимость",
        "value": "${costPrice.toStringAsFixed(2)} ₽",
        "type": "currency",
      },
      {
        "label": "Цена продажи",
        "value": "${sellingPrice.toStringAsFixed(2)} ₽",
        "type": "currency",
      },
      {
        "label": "Дополнительные расходы",
        "value": "${additionalCosts.toStringAsFixed(2)} ₽",
        "type": "currency",
      },
      {
        "label": "Налоги",
        "value": "${taxes.toStringAsFixed(2)} ₽",
        "type": "currency",
      },
      {
        "label": "Заметки",
        "value": _calculationData['notes'] ?? 'Нет заметок',
        "type": "text",
      },
    ];

    _calculationItems = [
      {
        "label": "Валовая прибыль",
        "value": "${(sellingPrice - costPrice).toStringAsFixed(2)} ₽",
        "formula": "Цена продажи - Себестоимость",
      },
      {
        "label": "Чистая прибыль",
        "value": "${profit.toStringAsFixed(2)} ₽",
        "formula": "Валовая прибыль - Расходы - Налоги",
      },
      {
        "label": "Маржа прибыли",
        "value": "${profitMargin.toStringAsFixed(1)}%",
        "formula": "(Прибыль / Себестоимость) × 100",
      },
      {
        "label": "Наценка",
        "value": "${markup.toStringAsFixed(1)}%",
        "formula": "(Прибыль / Себестоимость) × 100",
      },
      {
        "label": "ROI",
        "value": "${roi.toStringAsFixed(1)}%",
        "formula": "(Прибыль / Инвестиции) × 100",
      },
    ];

    _analysisItems = [
      {
        "label": "Статус сделки",
        "value": profit > 0
            ? "Прибыльная"
            : profit == 0
                ? "Безубыточная"
                : "Убыточная",
        "color": profit > 0
            ? AppTheme.successGreen
            : profit == 0
                ? AppTheme.warningOrange
                : AppTheme.errorRed,
      },
      {
        "label": "Точка безубыточности",
        "value":
            "${(costPrice + additionalCosts + taxes).toStringAsFixed(2)} ₽",
        "color": AppTheme.warningOrange,
      },
      {
        "label": "Рекомендация",
        "value": profit > costPrice * 0.2
            ? "Отличная сделка"
            : profit > 0
                ? "Приемлемая прибыль"
                : "Пересмотреть цену",
        "color": profit > costPrice * 0.2
            ? AppTheme.successGreen
            : profit > 0
                ? AppTheme.warningOrange
                : AppTheme.errorRed,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentIndex =
        CustomBottomBar.getCurrentIndex('/calculation-details');

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Детали расчёта',
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _toggleEditMode();
            },
            icon: CustomIconWidget(
              iconName: _isEditMode ? 'check' : 'edit',
              color: colorScheme.primary,
              size: 20,
            ),
            tooltip: _isEditMode ? 'Сохранить' : 'Редактировать',
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _shareCalculation();
            },
            icon: CustomIconWidget(
              iconName: 'share',
              color: colorScheme.primary,
              size: 20,
            ),
            tooltip: 'Поделиться',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          // Main content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calculation summary card
                  CalculationSummaryCard(
                    calculationData: _calculationData,
                    onEdit: _isEditMode ? () => _editCalculation() : null,
                  ),

                  SizedBox(height: 2.h),

                  // Исходные данные section
                  ExpandableSection(
                    title: 'Исходные данные',
                    leadingIcon: Icons.input,
                    initiallyExpanded: false,
                    content: _buildInputDataContent(),
                  ),

                  SizedBox(height: 1.h),

                  // Расчёты section
                  ExpandableSection(
                    title: 'Расчёты',
                    leadingIcon: Icons.calculate,
                    initiallyExpanded: true,
                    content: CalculationBreakdown(
                      calculationData: _calculationData,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Анализ прибыли section
                  ExpandableSection(
                    title: 'Анализ прибыли',
                    leadingIcon: Icons.analytics,
                    initiallyExpanded: false,
                    content: Column(
                      children: [
                        ProfitAnalysisChart(
                          calculationData: _calculationData,
                        ),
                        SizedBox(height: 3.h),
                        _buildAnalysisContent(),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h), // Space for bottom actions
                ],
              ),
            ),
          ),

          // Bottom action buttons
          ActionButtons(
            calculationData: _calculationData,
            onRecalculate: () => _recalculate(),
            onSaveTemplate: () => _saveAsTemplate(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          final route = CustomBottomBar.getRouteByIndex(index);
          if (route != '/calculation-details') {
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

  Widget _buildInputDataContent() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: _inputDataItems.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: GestureDetector(
            onLongPress: () {
              HapticFeedback.mediumImpact();
              Clipboard.setData(ClipboardData(text: item['value'] as String));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item['label']} скопирован'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    item['label'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    item['value'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnalysisContent() {
    final theme = Theme.of(context);

    return Column(
      children: _analysisItems.map((item) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: (item['color'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (item['color'] as Color).withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['label'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: item['color'] as Color,
                  ),
                ),
              ),
              Text(
                item['value'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: item['color'] as Color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });

    if (!_isEditMode) {
      // Restore scroll position when exiting edit mode
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollPosition,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _editCalculation() {
    // Navigate to calculator with current values for editing
    Navigator.pushNamed(
      context,
      '/main-calculator',
      arguments: _calculationData,
    );
  }

  void _recalculate() {
    Navigator.pushNamed(
      context,
      '/main-calculator',
      arguments: _calculationData,
    );
  }

  void _saveAsTemplate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Шаблон сохранён'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _shareCalculation() {
    final double costPrice =
        (_calculationData['costPrice'] as num?)?.toDouble() ?? 0.0;
    final double sellingPrice =
        (_calculationData['sellingPrice'] as num?)?.toDouble() ?? 0.0;
    final double profit = sellingPrice - costPrice;
    final double profitMargin =
        costPrice > 0 ? (profit / costPrice) * 100 : 0.0;

    final String shareText = '''
📊 Расчёт прибыли - Resale Calculator Pro

💰 Себестоимость: ${costPrice.toStringAsFixed(2)} ₽
💵 Цена продажи: ${sellingPrice.toStringAsFixed(2)} ₽
📈 Прибыль: ${profit.toStringAsFixed(2)} ₽
📊 Маржа: ${profitMargin.toStringAsFixed(1)}%

${profit > 0 ? '✅ Прибыльная сделка' : profit == 0 ? '⚖️ Безубыточность' : '❌ Убыточная сделка'}

Рассчитано с помощью Resale Calculator Pro
    ''';

    // Copy to clipboard as fallback
    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Расчёт скопирован в буфер обмена'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
