import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Calculator button grid widget with iOS-style design and haptic feedback
class CalculatorButtonGridWidget extends StatelessWidget {
  final Function(String) onButtonPressed;
  final String calculationType;
  final double availableHeight;
  final bool isCompact;

  const CalculatorButtonGridWidget({
    super.key,
    required this.onButtonPressed,
    required this.calculationType,
    required this.availableHeight,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final showProfitButtons =
        calculationType == 'Прибыль' || calculationType == 'Наценка';
    final totalRows = showProfitButtons
        ? 7
        : 5; // 2 profit rows + 5 basic rows OR just 5 basic rows
    final maxButtonHeight =
        (availableHeight - (totalRows * 1.w * 2) - 4.w) / totalRows;
    final optimalHeight = isCompact
        ? (maxButtonHeight * 0.9).clamp(8.h, 10.h)
        : maxButtonHeight.clamp(9.h, 12.h);

    return Container(
      padding: EdgeInsets.all(isCompact ? 1.w : 2.w),
      child: Column(
        children: [
          if (showProfitButtons) ...[
            _buildProfitCalculatorButtons(optimalHeight),
            SizedBox(height: isCompact ? 1.h : 2.h),
          ],
          Expanded(
            child: _buildBasicCalculatorGrid(optimalHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitCalculatorButtons(double buttonHeight) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCalculatorButton(
                'Себестоимость',
                buttonType: ButtonType.function,
                onPressed: () => onButtonPressed('COST_PRICE'),
                height: buttonHeight * 0.8,
              ),
            ),
            SizedBox(width: isCompact ? 1.w : 2.w),
            Expanded(
              child: _buildCalculatorButton(
                'Цена продажи',
                buttonType: ButtonType.function,
                onPressed: () => onButtonPressed('SELLING_PRICE'),
                height: buttonHeight * 0.8,
              ),
            ),
          ],
        ),
        SizedBox(height: isCompact ? 1.w : 2.w),
        Row(
          children: [
            Expanded(
              child: _buildCalculatorButton(
                'Маржа %',
                buttonType: ButtonType.function,
                onPressed: () => onButtonPressed('MARGIN_PERCENT'),
                height: buttonHeight * 0.8,
              ),
            ),
            SizedBox(width: isCompact ? 1.w : 2.w),
            Expanded(
              child: _buildCalculatorButton(
                'Рассчитать',
                buttonType: ButtonType.equals,
                onPressed: () => onButtonPressed('CALCULATE_PROFIT'),
                height: buttonHeight * 0.8,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicCalculatorGrid(double buttonHeight) {
    final List<List<Map<String, dynamic>>> buttonRows = [
      [
        {'text': 'C', 'type': ButtonType.clear},
        {'text': '±', 'type': ButtonType.operator},
        {'text': '%', 'type': ButtonType.operator},
        {'text': '÷', 'type': ButtonType.operator},
      ],
      [
        {'text': '7', 'type': ButtonType.number},
        {'text': '8', 'type': ButtonType.number},
        {'text': '9', 'type': ButtonType.number},
        {'text': '×', 'type': ButtonType.operator},
      ],
      [
        {'text': '4', 'type': ButtonType.number},
        {'text': '5', 'type': ButtonType.number},
        {'text': '6', 'type': ButtonType.number},
        {'text': '-', 'type': ButtonType.operator},
      ],
      [
        {'text': '1', 'type': ButtonType.number},
        {'text': '2', 'type': ButtonType.number},
        {'text': '3', 'type': ButtonType.number},
        {'text': '+', 'type': ButtonType.operator},
      ],
      [
        {'text': '0', 'type': ButtonType.number, 'span': 2},
        {'text': ',', 'type': ButtonType.number},
        {'text': '=', 'type': ButtonType.equals},
      ],
    ];

    return Column(
      children: buttonRows.asMap().entries.map((entry) {
        final index = entry.key;
        final row = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: isCompact ? 0.5.w : 1.w),
            child: _buildButtonRow(row, buttonHeight),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildButtonRow(
      List<Map<String, dynamic>> buttons, double buttonHeight) {
    return Row(
      children: buttons.map((button) {
        final int span = button['span'] ?? 1;
        return Expanded(
          flex: span,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isCompact ? 0.5.w : 1.w),
            child: _buildCalculatorButton(
              button['text'],
              buttonType: button['type'],
              onPressed: () => onButtonPressed(button['text']),
              height: buttonHeight,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalculatorButton(
    String text, {
    required ButtonType buttonType,
    required VoidCallback onPressed,
    required double height,
  }) {
    Color backgroundColor;
    Color textColor;
    double fontSize = isCompact ? 16.sp : 18.sp;

    switch (buttonType) {
      case ButtonType.number:
        backgroundColor = AppTheme.secondaryDark;
        textColor = AppTheme.textPrimary;
        break;
      case ButtonType.operator:
        backgroundColor = AppTheme.accentBlue;
        textColor = AppTheme.textPrimary;
        break;
      case ButtonType.equals:
        backgroundColor = AppTheme.accentBlue;
        textColor = AppTheme.textPrimary;
        break;
      case ButtonType.clear:
        backgroundColor = AppTheme.errorRed;
        textColor = AppTheme.textPrimary;
        break;
      case ButtonType.function:
        backgroundColor = AppTheme.warningOrange;
        textColor = AppTheme.textPrimary;
        fontSize = isCompact ? 12.sp : 14.sp;
        break;
    }

    return SizedBox(
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
              border: Border.all(
                color: AppTheme.borderColor.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ButtonType {
  number,
  operator,
  equals,
  clear,
  function,
}
