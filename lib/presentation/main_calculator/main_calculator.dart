import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/calculation_context_menu_widget.dart';
import './widgets/calculation_type_selector_widget.dart';
import './widgets/calculator_button_grid_widget.dart';
import './widgets/calculator_display_widget.dart';
import './widgets/quick_templates_bottom_sheet_widget.dart';

/// Main Calculator screen for resale profit calculations
class MainCalculator extends StatefulWidget {
  const MainCalculator({super.key});

  @override
  State<MainCalculator> createState() => _MainCalculatorState();
}

class _MainCalculatorState extends State<MainCalculator>
    with TickerProviderStateMixin {
  // Calculator state
  String _currentInput = '';
  String _result = '';
  String _calculationType = 'Базовый';
  String _operator = '';
  double _firstOperand = 0;
  bool _waitingForOperand = false;

  // Profit calculation state
  double? _costPrice;
  double? _sellingPrice;
  double? _marginPercent;
  Map<String, dynamic>? _calculationBreakdown;

  // Animation controllers
  late AnimationController _displayAnimationController;
  late AnimationController _buttonAnimationController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCalculationState();
  }

  @override
  void dispose() {
    _displayAnimationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _displayAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _displayAnimationController.forward();
    _buttonAnimationController.forward();
  }

  Future<void> _loadCalculationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedState = prefs.getString('calculator_state');
      if (savedState != null) {
        final state = json.decode(savedState);
        setState(() {
          _calculationType = state['calculationType'] ?? 'Базовый';
          _currentInput = state['currentInput'] ?? '';
          _result = state['result'] ?? '';
        });
      }
    } catch (e) {
      // Silent fail - use default state
    }
  }

  Future<void> _saveCalculationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final state = {
        'calculationType': _calculationType,
        'currentInput': _currentInput,
        'result': _result,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await prefs.setString('calculator_state', json.encode(state));
    } catch (e) {
      // Silent fail
    }
  }

  void _onButtonPressed(String value) {
    HapticFeedback.lightImpact();

    switch (value) {
      case 'C':
        _clear();
        break;
      case '=':
        _calculate();
        break;
      case 'COST_PRICE':
        _setCostPrice();
        break;
      case 'SELLING_PRICE':
        _setSellingPrice();
        break;
      case 'MARGIN_PERCENT':
        _setMarginPercent();
        break;
      case 'CALCULATE_PROFIT':
        _calculateProfit();
        break;
      case '±':
        _toggleSign();
        break;
      case ',':
        _addDecimal();
        break;
      default:
        if (_isOperator(value)) {
          _handleOperator(value);
        } else if (_isNumber(value)) {
          _handleNumber(value);
        }
    }

    _saveCalculationState();
  }

  void _clear() {
    setState(() {
      _currentInput = '';
      _result = '';
      _operator = '';
      _firstOperand = 0;
      _waitingForOperand = false;
      _costPrice = null;
      _sellingPrice = null;
      _marginPercent = null;
      _calculationBreakdown = null;
    });
  }

  void _handleNumber(String number) {
    setState(() {
      if (_waitingForOperand) {
        _currentInput = number;
        _waitingForOperand = false;
      } else {
        _currentInput = _currentInput == '0' ? number : _currentInput + number;
      }
    });
  }

  void _handleOperator(String operator) {
    final double inputValue =
        double.tryParse(_currentInput.replaceAll(',', '.')) ?? 0;

    if (_firstOperand == 0) {
      _firstOperand = inputValue;
    } else if (_operator.isNotEmpty) {
      final double result =
          _performCalculation(_firstOperand, inputValue, _operator);
      setState(() {
        _currentInput = _formatNumber(result);
        _firstOperand = result;
      });
    }

    setState(() {
      _operator = operator;
      _waitingForOperand = true;
    });
  }

  void _calculate() {
    if (_operator.isEmpty || _waitingForOperand) return;

    final double inputValue =
        double.tryParse(_currentInput.replaceAll(',', '.')) ?? 0;
    final double result =
        _performCalculation(_firstOperand, inputValue, _operator);

    setState(() {
      _result = '${_formatNumber(result)} ₽';
      _currentInput = _formatNumber(result);
      _operator = '';
      _firstOperand = 0;
      _waitingForOperand = true;
    });
  }

  double _performCalculation(double first, double second, String operator) {
    switch (operator) {
      case '+':
        return first + second;
      case '-':
        return first - second;
      case '×':
        return first * second;
      case '÷':
        return second != 0 ? first / second : 0;
      case '%':
        return first * (second / 100);
      default:
        return second;
    }
  }

  void _setCostPrice() {
    final double? value = double.tryParse(_currentInput.replaceAll(',', '.'));
    if (value != null) {
      setState(() {
        _costPrice = value;
        _currentInput = '';
      });
    }
  }

  void _setSellingPrice() {
    final double? value = double.tryParse(_currentInput.replaceAll(',', '.'));
    if (value != null) {
      setState(() {
        _sellingPrice = value;
        _currentInput = '';
      });
    }
  }

  void _setMarginPercent() {
    final double? value = double.tryParse(_currentInput.replaceAll(',', '.'));
    if (value != null) {
      setState(() {
        _marginPercent = value;
        _currentInput = '';
      });
    }
  }

  void _calculateProfit() {
    if (_calculationType == 'Прибыль') {
      _calculateProfitMargin();
    } else if (_calculationType == 'Наценка') {
      _calculateMarkup();
    }
  }

  void _calculateProfitMargin() {
    if (_costPrice != null && _sellingPrice != null) {
      final profit = _sellingPrice! - _costPrice!;
      final marginPercent = _costPrice! > 0 ? (profit / _costPrice!) * 100 : 0;

      setState(() {
        _result = '${_formatNumber(profit)} ₽';
        _calculationBreakdown = {
          'costPrice': _formatNumber(_costPrice!),
          'sellingPrice': _formatNumber(_sellingPrice!),
          'profit': _formatNumber(profit),
          'marginPercent': _formatNumber(marginPercent.toDouble()),
        };
      });
    } else if (_costPrice != null && _marginPercent != null) {
      final sellingPrice = _costPrice! * (1 + _marginPercent! / 100);
      final profit = sellingPrice - _costPrice!;

      setState(() {
        _sellingPrice = sellingPrice;
        _result = '${_formatNumber(profit)} ₽';
        _calculationBreakdown = {
          'costPrice': _formatNumber(_costPrice!),
          'sellingPrice': _formatNumber(sellingPrice),
          'profit': _formatNumber(profit),
          'marginPercent': _formatNumber(_marginPercent!),
        };
      });
    }
  }

  void _calculateMarkup() {
    if (_costPrice != null && _marginPercent != null) {
      final markup = _costPrice! * (_marginPercent! / 100);
      final sellingPrice = _costPrice! + markup;

      setState(() {
        _sellingPrice = sellingPrice;
        _result = '${_formatNumber(markup)} ₽';
        _calculationBreakdown = {
          'costPrice': _formatNumber(_costPrice!),
          'sellingPrice': _formatNumber(sellingPrice),
          'profit': _formatNumber(markup),
          'marginPercent': _formatNumber(_marginPercent!),
        };
      });
    }
  }

  void _toggleSign() {
    if (_currentInput.isNotEmpty && _currentInput != '0') {
      setState(() {
        if (_currentInput.startsWith('-')) {
          _currentInput = _currentInput.substring(1);
        } else {
          _currentInput = '-$_currentInput';
        }
      });
    }
  }

  void _addDecimal() {
    if (!_currentInput.contains(',')) {
      setState(() {
        _currentInput = _currentInput.isEmpty ? '0,' : '$_currentInput,';
      });
    }
  }

  bool _isOperator(String value) {
    return ['+', '-', '×', '÷', '%'].contains(value);
  }

  bool _isNumber(String value) {
    return RegExp(r'^\d$').hasMatch(value);
  }

  String _formatNumber(double number) {
    if (number == number.roundToDouble()) {
      return number.round().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]} ',
          );
    } else {
      return number.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]} ',
          );
    }
  }

  void _onCalculationTypeChanged(String type) {
    setState(() {
      _calculationType = type;
      _clear();
    });
  }

  void _showQuickTemplates() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickTemplatesBottomSheetWidget(
        onTemplateSelected: _applyTemplate,
      ),
    );
  }

  void _applyTemplate(Map<String, dynamic> template) {
    setState(() {
      _calculationType = 'Прибыль';
      _costPrice = template['costPrice'].toDouble();
      _marginPercent = template['marginPercent'].toDouble();
      _currentInput = '';
    });
    _calculateProfit();
  }

  void _showContextMenu() {
    if (_result.isEmpty) return;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: CalculationContextMenuWidget(
            result: _result,
            calculationData: _calculationBreakdown,
            onSaveToHistory: _saveToHistory,
            onShare: _shareResult,
            onCopy: _copyResult,
          ),
        ),
      ),
    );
  }

  Future<void> _saveToHistory() async {
    if (_result.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('calculation_history') ?? '[]';
      final List<dynamic> history = json.decode(historyJson);

      final calculation = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': _calculationType,
        'result': _result,
        'breakdown': _calculationBreakdown,
        'timestamp': DateTime.now().toIso8601String(),
      };

      history.insert(0, calculation);

      // Keep only last 100 calculations
      if (history.length > 100) {
        history.removeRange(100, history.length);
      }

      await prefs.setString('calculation_history', json.encode(history));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Расчет сохранен в историю'),
          backgroundColor: AppTheme.successGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка сохранения'),
          backgroundColor: AppTheme.errorRed,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareResult() {
    if (_result.isEmpty) return;

    String shareText = 'Результат расчета: $_result\n';
    if (_calculationBreakdown != null) {
      shareText += 'Тип: $_calculationType\n';
      if (_calculationBreakdown!['costPrice'] != null) {
        shareText +=
            'Себестоимость: ${_calculationBreakdown!['costPrice']} ₽\n';
      }
      if (_calculationBreakdown!['sellingPrice'] != null) {
        shareText +=
            'Цена продажи: ${_calculationBreakdown!['sellingPrice']} ₽\n';
      }
      if (_calculationBreakdown!['marginPercent'] != null) {
        shareText += 'Маржа: ${_calculationBreakdown!['marginPercent']}%\n';
      }
    }
    shareText += '\nРассчитано в Resale Calculator Pro';

    // Note: In a real app, you would use share_plus package
    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Результат скопирован для отправки'),
        backgroundColor: AppTheme.accentBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _copyResult() {
    if (_result.isEmpty) return;

    Clipboard.setData(ClipboardData(text: _result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Результат скопирован'),
        backgroundColor: AppTheme.accentBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: CustomCalculatorAppBar(
        result: _result,
        onHistoryPressed: () =>
            Navigator.pushNamed(context, '/calculation-history'),
        onClearPressed: _clear,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final isCompactScreen = availableHeight < 600;

            return Column(
              children: [
                // Calculation type selector
                Padding(
                  padding: EdgeInsets.all(isCompactScreen ? 2.w : 4.w),
                  child: AnimatedBuilder(
                    animation: _displayAnimationController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.5),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _displayAnimationController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: CalculationTypeSelectorWidget(
                          selectedType: _calculationType,
                          onTypeChanged: _onCalculationTypeChanged,
                        ),
                      );
                    },
                  ),
                ),

                // Display area - adaptive sizing
                Flexible(
                  flex: isCompactScreen ? 2 : 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: AnimatedBuilder(
                      animation: _displayAnimationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _displayAnimationController,
                          child: GestureDetector(
                            onLongPress: _showContextMenu,
                            child: CalculatorDisplayWidget(
                              currentInput: _currentInput,
                              result: _result,
                              calculationType: _calculationType,
                              calculationBreakdown: _calculationBreakdown,
                              isCompact: isCompactScreen,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Button grid - ensure it always fits
                Flexible(
                  flex: isCompactScreen ? 4 : 3,
                  child: AnimatedBuilder(
                    animation: _buttonAnimationController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _buttonAnimationController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: CalculatorButtonGridWidget(
                          onButtonPressed: _onButtonPressed,
                          calculationType: _calculationType,
                          availableHeight: availableHeight * 0.45,
                          isCompact: isCompactScreen,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickTemplates,
        backgroundColor: AppTheme.accentBlue,
        child: CustomIconWidget(
          iconName: 'flash_on',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/calculation-history');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/calculation-details');
          }
        },
      ),
    );
  }
}
