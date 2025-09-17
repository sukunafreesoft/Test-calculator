import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Summary card widget displaying main calculation results with profit/loss indicator
class CalculationSummaryCard extends StatelessWidget {
  final Map<String, dynamic> calculationData;
  final VoidCallback? onEdit;

  const CalculationSummaryCard({
    super.key,
    required this.calculationData,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double costPrice =
        (calculationData['costPrice'] as num?)?.toDouble() ?? 0.0;
    final double sellingPrice =
        (calculationData['sellingPrice'] as num?)?.toDouble() ?? 0.0;
    final double profit = sellingPrice - costPrice;
    final double profitMargin =
        costPrice > 0 ? (profit / costPrice) * 100 : 0.0;

    final bool isProfit = profit > 0;
    final bool isBreakEven = profit == 0;

    Color indicatorColor;
    String statusText;

    if (isBreakEven) {
      indicatorColor = AppTheme.warningOrange;
      statusText = 'Безубыточность';
    } else if (isProfit) {
      indicatorColor = AppTheme.successGreen;
      statusText = 'Прибыль';
    } else {
      indicatorColor = AppTheme.errorRed;
      statusText = 'Убыток';
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Результат расчёта',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              if (onEdit != null)
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onEdit!();
                  },
                  icon: CustomIconWidget(
                    iconName: 'edit',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  tooltip: 'Редактировать',
                ),
            ],
          ),

          SizedBox(height: 3.h),

          // Main profit/loss display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: indicatorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: indicatorColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  statusText,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: indicatorColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '${profit.toStringAsFixed(2)} ₽',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: indicatorColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${profitMargin.toStringAsFixed(1)}% маржа',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Quick stats row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Себестоимость',
                  '${costPrice.toStringAsFixed(2)} ₽',
                  colorScheme.onSurfaceVariant,
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Цена продажи',
                  '${sellingPrice.toStringAsFixed(2)} ₽',
                  colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);

    return GestureDetector(
      onLongPress: () {
        HapticFeedback.mediumImpact();
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label скопирован'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
