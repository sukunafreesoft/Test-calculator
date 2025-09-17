import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data for bottom navigation bar
class BottomNavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;

  const BottomNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.route,
  });
}

/// Custom bottom navigation bar implementing iOS-inspired design
/// Provides main navigation between calculator, history, and details screens
class CustomBottomBar extends StatelessWidget {
  /// Currently selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final ValueChanged<int>? onTap;

  /// Whether to show labels under icons
  final bool showLabels;

  /// Custom background color
  final Color? backgroundColor;

  // Predefined navigation items for the resale calculation app
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      label: 'Калькулятор',
      icon: Icons.calculate_outlined,
      activeIcon: Icons.calculate,
      route: '/main-calculator',
    ),
    BottomNavItem(
      label: 'История',
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      route: '/calculation-history',
    ),
    BottomNavItem(
      label: 'Детали',
      icon: Icons.info_outline,
      activeIcon: Icons.info,
      route: '/calculation-details',
    ),
  ];

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.showLabels = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.secondary,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: showLabels ? 65 : 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              return _buildNavItem(
                context,
                _navItems[index],
                index,
                currentIndex == index,
              );
            }),
          ),
        ),
      ),
    );
  }

  /// Builds individual navigation item
  Widget _buildNavItem(
    BuildContext context,
    BottomNavItem item,
    int index,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color itemColor =
        isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          if (onTap != null) {
            onTap!(index);
          } else {
            _navigateToRoute(context, item.route, index);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected && item.activeIcon != null
                      ? item.activeIcon!
                      : item.icon,
                  key: ValueKey(isSelected),
                  color: itemColor,
                  size: 24,
                ),
              ),

              // Label
              if (showLabels) ...[
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: itemColor,
                    letterSpacing: 0.12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Handles navigation to the specified route
  void _navigateToRoute(BuildContext context, String route, int index) {
    // Get current route name
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Don't navigate if already on the target route
    if (currentRoute == route) return;

    // Navigate to the new route
    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false, // Remove all previous routes
    );
  }

  /// Helper method to get current index based on route
  static int getCurrentIndex(String? routeName) {
    if (routeName == null) return 0;

    for (int i = 0; i < _navItems.length; i++) {
      if (_navItems[i].route == routeName) {
        return i;
      }
    }
    return 0; // Default to calculator
  }

  /// Helper method to get route name by index
  static String getRouteByIndex(int index) {
    if (index >= 0 && index < _navItems.length) {
      return _navItems[index].route;
    }
    return _navItems[0].route; // Default to calculator
  }
}

/// Floating bottom navigation bar variant with elevated design
class CustomFloatingBottomBar extends StatelessWidget {
  /// Currently selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final ValueChanged<int>? onTap;

  /// Margin from screen edges
  final EdgeInsets margin;

  /// Border radius for the floating bar
  final double borderRadius;

  const CustomFloatingBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.margin = const EdgeInsets.all(16),
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: CustomBottomBar(
          currentIndex: currentIndex,
          onTap: onTap,
          showLabels: false,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

/// Compact bottom navigation bar for minimal design
class CustomCompactBottomBar extends StatelessWidget {
  /// Currently selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final ValueChanged<int>? onTap;

  const CustomCompactBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(CustomBottomBar._navItems.length, (index) {
            final item = CustomBottomBar._navItems[index];
            final isSelected = currentIndex == index;
            final itemColor =
                isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

            return InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                if (onTap != null) {
                  onTap!(index);
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    item.route,
                    (route) => false,
                  );
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  isSelected && item.activeIcon != null
                      ? item.activeIcon!
                      : item.icon,
                  color: itemColor,
                  size: 26,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
