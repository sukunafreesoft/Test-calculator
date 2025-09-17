import 'package:flutter/material.dart';
import '../presentation/calculation_history/calculation_history.dart';
import '../presentation/main_calculator/main_calculator.dart';
import '../presentation/calculation_details/calculation_details.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String calculationHistory = '/calculation-history';
  static const String mainCalculator = '/main-calculator';
  static const String calculationDetails = '/calculation-details';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const CalculationHistory(),
    calculationHistory: (context) => const CalculationHistory(),
    mainCalculator: (context) => const MainCalculator(),
    calculationDetails: (context) => const CalculationDetails(),
    // TODO: Add your other routes here
  };
}
