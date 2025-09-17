import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Action buttons widget for calculation details screen
class ActionButtons extends StatelessWidget {
  final Map<String, dynamic> calculationData;
  final VoidCallback? onRecalculate;
  final VoidCallback? onSaveTemplate;

  const ActionButtons({
    super.key,
    required this.calculationData,
    this.onRecalculate,
    this.onSaveTemplate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary action - Recalculate
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  if (onRecalculate != null) {
                    onRecalculate!();
                  } else {
                    Navigator.pushNamed(context, '/main-calculator');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'calculate',
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Пересчитать',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Secondary actions row
            Row(
              children: [
                // Save as template
                Expanded(
                  child: SizedBox(
                    height: 5.h,
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _saveAsTemplate(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'bookmark_add',
                            color: colorScheme.onSurface,
                            size: 18,
                          ),
                          SizedBox(width: 1.w),
                          Flexible(
                            child: Text(
                              'Шаблон',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Share button
                Expanded(
                  child: SizedBox(
                    height: 5.h,
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _shareCalculation(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'share',
                            color: colorScheme.onSurface,
                            size: 18,
                          ),
                          SizedBox(width: 1.w),
                          Flexible(
                            child: Text(
                              'Поделиться',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveAsTemplate(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        String templateName = '';

        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            'Сохранить как шаблон',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          content: TextField(
            onChanged: (value) => templateName = value,
            decoration: InputDecoration(
              hintText: 'Название шаблона',
              filled: true,
              fillColor: colorScheme.secondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Отмена',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (templateName.isNotEmpty) {
                  // Save template logic here
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Шаблон "$templateName" сохранён'),
                      backgroundColor: AppTheme.successGreen,
                    ),
                  );
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _shareCalculation(BuildContext context) {
    final double costPrice =
        (calculationData['costPrice'] as num?)?.toDouble() ?? 0.0;
    final double sellingPrice =
        (calculationData['sellingPrice'] as num?)?.toDouble() ?? 0.0;
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

    Share.share(
      shareText,
      subject: 'Расчёт прибыли',
    );
  }
}
