import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Calculator display widget showing current calculation and results
class CalculatorDisplayWidget extends StatelessWidget {
  final String currentInput;
  final String result;
  final String calculationType;
  final Map<String, dynamic>? calculationBreakdown;
  final bool isCompact;

  const CalculatorDisplayWidget({
    super.key,
    required this.currentInput,
    required this.result,
    required this.calculationType,
    this.calculationBreakdown,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: isCompact ? 2.h : 3.h,
      ),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderColor.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Calculation type indicator
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: isCompact ? 0.5.h : 1.h,
            ),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              calculationType,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.accentBlue,
                fontWeight: FontWeight.w500,
                fontSize: isCompact ? 12.sp : null,
              ),
            ),
          ),
          SizedBox(height: isCompact ? 1.h : 2.h),

          // Current input display
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: isCompact ? 4.h : 6.h,
              maxHeight: isCompact ? 5.h : 7.h,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                currentInput.isEmpty ? "0" : currentInput,
                style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w400,
                  fontSize: isCompact ? 20.sp : 24.sp,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),

          SizedBox(height: isCompact ? 0.5.h : 1.h),

          // Result display
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: isCompact ? 5.h : 8.h,
              maxHeight: isCompact ? 6.h : 9.h,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  result.isEmpty ? "0 ₽" : result,
                  style: AppTheme.darkTheme.textTheme.displaySmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: isCompact ? 28.sp : 32.sp,
                  ),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                ),
              ),
            ),
          ),

          // Calculation breakdown for profit calculations - only show if not compact or essential
          if (calculationBreakdown != null && !isCompact) ...[
            SizedBox(height: 2.h),
            _buildCalculationBreakdown(),
          ] else if (calculationBreakdown != null && isCompact) ...[
            SizedBox(height: 1.h),
            _buildCompactBreakdown(),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactBreakdown() {
    if (calculationBreakdown == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (calculationBreakdown!['profit'] != null)
            _buildCompactBreakdownItem(
              'Прибыль',
              '${calculationBreakdown!['profit']} ₽',
              color:
                  double.parse(calculationBreakdown!['profit'].toString()) > 0
                      ? AppTheme.successGreen
                      : AppTheme.errorRed,
            ),
          if (calculationBreakdown!['marginPercent'] != null)
            _buildCompactBreakdownItem(
              'Маржа',
              '${calculationBreakdown!['marginPercent']}%',
              color: double.parse(
                          calculationBreakdown!['marginPercent'].toString()) >
                      0
                  ? AppTheme.successGreen
                  : AppTheme.warningOrange,
            ),
        ],
      ),
    );
  }

  Widget _buildCompactBreakdownItem(String label, String value,
      {Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
            fontSize: 10.sp,
          ),
        ),
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: color ?? AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildCalculationBreakdown() {
    if (calculationBreakdown == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Детали расчета',
            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          if (calculationBreakdown!['costPrice'] != null)
            _buildBreakdownRow(
                'Себестоимость:', '${calculationBreakdown!['costPrice']} ₽'),
          if (calculationBreakdown!['sellingPrice'] != null)
            _buildBreakdownRow(
                'Цена продажи:', '${calculationBreakdown!['sellingPrice']} ₽'),
          if (calculationBreakdown!['profit'] != null)
            _buildBreakdownRow(
              'Прибыль:',
              '${calculationBreakdown!['profit']} ₽',
              color:
                  double.parse(calculationBreakdown!['profit'].toString()) > 0
                      ? AppTheme.successGreen
                      : AppTheme.errorRed,
            ),
          if (calculationBreakdown!['marginPercent'] != null)
            _buildBreakdownRow(
              'Маржа:',
              '${calculationBreakdown!['marginPercent']}%',
              color: double.parse(
                          calculationBreakdown!['marginPercent'].toString()) >
                      0
                  ? AppTheme.successGreen
                  : AppTheme.warningOrange,
            ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: color ?? AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
