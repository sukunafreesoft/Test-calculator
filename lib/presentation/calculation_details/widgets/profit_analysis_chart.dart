import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Interactive profit analysis chart widget
class ProfitAnalysisChart extends StatefulWidget {
  final Map<String, dynamic> calculationData;

  const ProfitAnalysisChart({
    super.key,
    required this.calculationData,
  });

  @override
  State<ProfitAnalysisChart> createState() => _ProfitAnalysisChartState();
}

class _ProfitAnalysisChartState extends State<ProfitAnalysisChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double costPrice =
        (widget.calculationData['costPrice'] as num?)?.toDouble() ?? 0.0;
    final double sellingPrice =
        (widget.calculationData['sellingPrice'] as num?)?.toDouble() ?? 0.0;
    final double profit = sellingPrice - costPrice;

    final double maxValue = sellingPrice > 0 ? sellingPrice : 100;
    final double costPercentage = (costPrice / maxValue) * 100;
    final double profitPercentage = profit > 0 ? (profit / maxValue) * 100 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Анализ структуры цены',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 3.h),

        // Horizontal bar chart
        Container(
          width: double.infinity,
          height: 15.h,
          child: Semantics(
            label: "Анализ структуры цены",
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (event is FlTapUpEvent && barTouchResponse != null) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _touchedIndex =
                            barTouchResponse.spot?.touchedBarGroupIndex ?? -1;
                      });
                    }
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: colorScheme.surface,
                    tooltipBorder: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String label;
                      String value;

                      if (groupIndex == 0) {
                        label = 'Себестоимость';
                        value = '${costPrice.toStringAsFixed(2)} ₽';
                      } else {
                        label = 'Прибыль';
                        value = '${profit.toStringAsFixed(2)} ₽';
                      }

                      return BarTooltipItem(
                        '$label\n$value',
                        theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ) ??
                            const TextStyle(),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String title;
                        if (value == 0) {
                          title = 'Себестоимость';
                        } else {
                          title = 'Прибыль';
                        }

                        return Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Text(
                            title,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                      reservedSize: 4.h,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 10.w,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: costPercentage,
                        color: _touchedIndex == 0
                            ? AppTheme.warningOrange.withValues(alpha: 0.8)
                            : AppTheme.warningOrange,
                        width: 15.w,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: profitPercentage,
                        color: _touchedIndex == 1
                            ? (profit >= 0
                                ? AppTheme.successGreen.withValues(alpha: 0.8)
                                : AppTheme.errorRed.withValues(alpha: 0.8))
                            : (profit >= 0
                                ? AppTheme.successGreen
                                : AppTheme.errorRed),
                        width: 15.w,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ],
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: colorScheme.outline.withValues(alpha: 0.1),
                      strokeWidth: 0.5,
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegendItem(
              context,
              AppTheme.warningOrange,
              'Себестоимость',
              '${costPercentage.toStringAsFixed(1)}%',
            ),
            _buildLegendItem(
              context,
              profit >= 0 ? AppTheme.successGreen : AppTheme.errorRed,
              'Прибыль',
              '${profitPercentage.toStringAsFixed(1)}%',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(
      BuildContext context, Color color, String label, String percentage) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 2.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              percentage,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}