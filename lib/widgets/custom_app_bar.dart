import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar widget implementing iOS-inspired design for mobile resale calculation app
/// Provides consistent navigation and professional presentation across all screens
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (automatically determined if not specified)
  final bool? showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether the app bar should be elevated with shadow
  final bool elevated;

  /// Background color override (uses theme color if not specified)
  final Color? backgroundColor;

  /// Text color override (uses theme color if not specified)
  final Color? foregroundColor;

  /// Whether to center the title
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton,
    this.leading,
    this.actions,
    this.elevated = false,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine if back button should be shown
    final bool shouldShowBack =
        showBackButton ?? (ModalRoute.of(context)?.canPop ?? false);

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? colorScheme.onSurface,
          letterSpacing: -0.41,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevated ? 4 : 0,
      shadowColor: elevated ? colorScheme.shadow : Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: leading ?? (shouldShowBack ? _buildBackButton(context) : null),
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: theme.brightness,
      ),
    );
  }

  /// Builds the back button with haptic feedback
  Widget _buildBackButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
      },
      icon: Icon(
        Icons.arrow_back_ios,
        color: foregroundColor ?? colorScheme.onSurface,
        size: 20,
      ),
      tooltip: 'Назад',
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Specialized app bar for calculator screen with calculation-specific actions
class CustomCalculatorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Current calculation result to display
  final String? result;

  /// Callback when history button is pressed
  final VoidCallback? onHistoryPressed;

  /// Callback when clear button is pressed
  final VoidCallback? onClearPressed;

  const CustomCalculatorAppBar({
    super.key,
    this.result,
    this.onHistoryPressed,
    this.onClearPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        'Калькулятор',
        style: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          letterSpacing: -0.41,
        ),
      ),
      centerTitle: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      actions: [
        // History button
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            if (onHistoryPressed != null) {
              onHistoryPressed!();
            } else {
              Navigator.pushNamed(context, '/calculation-history');
            }
          },
          icon: Icon(
            Icons.history,
            color: colorScheme.primary,
            size: 24,
          ),
          tooltip: 'История расчетов',
        ),
        // Clear button
        if (onClearPressed != null)
          IconButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              onClearPressed!();
            },
            icon: Icon(
              Icons.clear,
              color: colorScheme.error,
              size: 24,
            ),
            tooltip: 'Очистить',
          ),
        const SizedBox(width: 8),
      ],
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: theme.brightness,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Specialized app bar for history screen with search and filter actions
class CustomHistoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Whether search mode is active
  final bool isSearching;

  /// Search query text
  final String searchQuery;

  /// Callback when search is toggled
  final VoidCallback? onSearchToggle;

  /// Callback when search query changes
  final ValueChanged<String>? onSearchChanged;

  /// Callback when filter button is pressed
  final VoidCallback? onFilterPressed;

  const CustomHistoryAppBar({
    super.key,
    this.isSearching = false,
    this.searchQuery = '',
    this.onSearchToggle,
    this.onSearchChanged,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isSearching) {
      return AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            if (onSearchToggle != null) {
              onSearchToggle!();
            }
          },
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: TextField(
          autofocus: true,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Поиск расчетов...',
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: onSearchChanged,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: theme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: theme.brightness,
        ),
      );
    }

    return AppBar(
      title: Text(
        'История расчетов',
        style: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          letterSpacing: -0.41,
        ),
      ),
      centerTitle: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: colorScheme.onSurface,
          size: 20,
        ),
        tooltip: 'Назад',
      ),
      actions: [
        // Search button
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            if (onSearchToggle != null) {
              onSearchToggle!();
            }
          },
          icon: Icon(
            Icons.search,
            color: colorScheme.primary,
            size: 24,
          ),
          tooltip: 'Поиск',
        ),
        // Filter button
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            if (onFilterPressed != null) {
              onFilterPressed!();
            }
          },
          icon: Icon(
            Icons.filter_list,
            color: colorScheme.primary,
            size: 24,
          ),
          tooltip: 'Фильтр',
        ),
        const SizedBox(width: 8),
      ],
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: theme.brightness,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
