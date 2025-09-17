import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Widget displaying detailed calculation breakdown
class CalculationBreakdown extends StatelessWidget {
  final Map<String, dynamic> calculationData;

  const CalculationBreakdown({
    super.key,
    required this.calculationData,
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
    final double markup = costPrice > 0 ? (profit / costPrice) * 100 : 0.0;
    final double roi = costPrice > 0 ? (profit / costPrice) * 100 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Calculation formulas
        _buildCalculationItem(
          context,
          'Прибыль',
          '${sellingPrice.toStringAsFixed(2)} ₽ - ${costPrice.toStringAsFixed(2)} ₽',
          '${profit.toStringAsFixed(2)} ₽',
          profit >= 0 ? AppTheme.successGreen : AppTheme.errorRed,
        ),

        SizedBox(height: 2.h),

        _buildCalculationItem(
          context,
          'Маржа прибыли',
          '(${profit.toStringAsFixed(2)} ₽ / ${costPrice.toStringAsFixed(2)} ₽) × 100',
          '${profitMargin.toStringAsFixed(1)}%',
          profitMargin >= 0 ? AppTheme.successGreen : AppTheme.errorRed,
        ),

        SizedBox(height: 2.h),

        _buildCalculationItem(
          context,
          'Наценка',
          '(${profit.toStringAsFixed(2)} ₽ / ${costPrice.toStringAsFixed(2)} ₽) × 100',
          '${markup.toStringAsFixed(1)}%',
          markup >= 0 ? AppTheme.successGreen : AppTheme.errorRed,
        ),

        SizedBox(height: 2.h),

        _buildCalculationItem(
          context,
          'ROI',
          '(${profit.toStringAsFixed(2)} ₽ / ${costPrice.toStringAsFixed(2)} ₽) × 100',
          '${roi.toStringAsFixed(1)}%',
          roi >= 0 ? AppTheme.successGreen : AppTheme.errorRed,
        ),

        SizedBox(height: 3.h),

        // Break-even point
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.warningOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.warningOrange.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Точка безубыточности',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warningOrange,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Минимальная цена продажи: ${costPrice.toStringAsFixed(2)} ₽',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalculationItem(
    BuildContext context,
    String title,
    String formula,
    String result,
    Color resultColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onLongPress: () {
        HapticFeedback.mediumImpact();
        Clipboard.setData(ClipboardData(text: result));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title скопирован'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  result,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: resultColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              formula,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
