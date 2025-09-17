import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Empty state widget for calculation history screen
class EmptyHistoryWidget extends StatelessWidget {
  final VoidCallback? onCreateCalculation;

  const EmptyHistoryWidget({
    super.key,
    this.onCreateCalculation,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration container
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'calculate',
                  color: colorScheme.primary,
                  size: 15.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              'История расчетов пуста',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              'Здесь будут отображаться все ваши расчеты прибыли. Создайте первый расчет, чтобы начать отслеживать результаты.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Create calculation button
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                if (onCreateCalculation != null) {
                  onCreateCalculation!();
                } else {
                  Navigator.pushNamed(context, '/main-calculator');
                }
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.textPrimary,
                size: 20,
              ),
              label: Text('Создать первый расчет'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Secondary action - tips
            TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                _showTipsDialog(context);
              },
              icon: CustomIconWidget(
                iconName: 'lightbulb_outline',
                color: colorScheme.primary,
                size: 20,
              ),
              label: Text('Советы по расчетам'),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows tips dialog for calculation usage
  void _showTipsDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'lightbulb',
              color: AppTheme.warningOrange,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Советы по расчетам',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTipItem(
              context,
              'calculate',
              'Расчет прибыли',
              'Введите себестоимость и цену продажи для получения прибыли и маржи',
              AppTheme.accentBlue,
            ),
            SizedBox(height: 2.h),
            _buildTipItem(
              context,
              'percent',
              'Расчет маржи',
              'Узнайте процент прибыли от цены продажи для анализа эффективности',
              AppTheme.successGreen,
            ),
            SizedBox(height: 2.h),
            _buildTipItem(
              context,
              'history',
              'История расчетов',
              'Все расчеты сохраняются автоматически для дальнейшего анализа',
              AppTheme.warningOrange,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Text('Понятно'),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
              if (onCreateCalculation != null) {
                onCreateCalculation!();
              } else {
                Navigator.pushNamed(context, '/main-calculator');
              }
            },
            child: Text('Начать расчет'),
          ),
        ],
      ),
    );
  }

  /// Builds a tip item with icon and description
  Widget _buildTipItem(
    BuildContext context,
    String iconName,
    String title,
    String description,
    Color iconColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
