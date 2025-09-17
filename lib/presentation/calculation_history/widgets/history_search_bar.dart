import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Search bar widget for calculation history screen
class HistorySearchBar extends StatefulWidget {
  final String searchQuery;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterPressed;
  final bool showFilter;

  const HistorySearchBar({
    super.key,
    this.searchQuery = '',
    this.onSearchChanged,
    this.onFilterPressed,
    this.showFilter = true,
  });

  @override
  State<HistorySearchBar> createState() => _HistorySearchBarState();
}

class _HistorySearchBarState extends State<HistorySearchBar> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.secondaryDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? colorScheme.primary
                      : AppTheme.borderColor,
                  width: _focusNode.hasFocus ? 1 : 0.5,
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                decoration: InputDecoration(
                  hintText: 'Поиск расчетов...',
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _searchController.clear();
                            widget.onSearchChanged?.call('');
                            _focusNode.unfocus();
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                  widget.onSearchChanged?.call(value);
                },
                onSubmitted: (value) {
                  _focusNode.unfocus();
                },
                textInputAction: TextInputAction.search,
              ),
            ),
          ),

          // Filter button
          if (widget.showFilter) ...[
            SizedBox(width: 3.w),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.secondaryDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.borderColor,
                  width: 0.5,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  widget.onFilterPressed?.call();
                },
                icon: CustomIconWidget(
                  iconName: 'filter_list',
                  color: colorScheme.primary,
                  size: 24,
                ),
                constraints: BoxConstraints(
                  minWidth: 12.w,
                  minHeight: 6.h,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
