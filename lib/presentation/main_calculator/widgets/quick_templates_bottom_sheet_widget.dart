import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Bottom sheet widget for quick calculation templates
class QuickTemplatesBottomSheetWidget extends StatelessWidget {
  final Function(Map<String, dynamic>) onTemplateSelected;

  const QuickTemplatesBottomSheetWidget({
    super.key,
    required this.onTemplateSelected,
  });

  static final List<Map<String, dynamic>> templates = [
    {
      'title': 'Электроника',
      'description': 'Смартфоны, планшеты, ноутбуки',
      'icon': 'smartphone',
      'costPrice': 25000,
      'marginPercent': 15,
      'category': 'electronics',
    },
    {
      'title': 'Одежда и аксессуары',
      'description': 'Брендовая одежда, обувь, сумки',
      'icon': 'checkroom',
      'costPrice': 5000,
      'marginPercent': 40,
      'category': 'fashion',
    },
    {
      'title': 'Автозапчасти',
      'description': 'Запчасти для автомобилей',
      'icon': 'build',
      'costPrice': 3000,
      'marginPercent': 25,
      'category': 'auto',
    },
    {
      'title': 'Антиквариат',
      'description': 'Винтажные предметы, коллекционные вещи',
      'icon': 'museum',
      'costPrice': 10000,
      'marginPercent': 60,
      'category': 'antique',
    },
    {
      'title': 'Спортивные товары',
      'description': 'Спортивное оборудование, инвентарь',
      'icon': 'sports_soccer',
      'costPrice': 2000,
      'marginPercent': 30,
      'category': 'sports',
    },
    {
      'title': 'Книги и медиа',
      'description': 'Редкие книги, винил, DVD',
      'icon': 'menu_book',
      'costPrice': 500,
      'marginPercent': 50,
      'category': 'media',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Быстрые шаблоны',
                  style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Templates list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: templates.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.w),
              itemBuilder: (context, index) {
                final template = templates[index];
                return _buildTemplateCard(context, template);
              },
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(
      BuildContext context, Map<String, dynamic> template) {
    final sellingPrice =
        (template['costPrice'] * (1 + template['marginPercent'] / 100)).round();
    final profit = sellingPrice - template['costPrice'];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderColor.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTemplateSelected(template);
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: template['icon'],
                      color: AppTheme.accentBlue,
                      size: 24,
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template['title'],
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        template['description'],
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          _buildInfoChip('${template['costPrice']} ₽',
                              AppTheme.textTertiary),
                          SizedBox(width: 2.w),
                          _buildInfoChip('${template['marginPercent']}%',
                              AppTheme.warningOrange),
                          SizedBox(width: 2.w),
                          _buildInfoChip('+$profit ₽', AppTheme.successGreen),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  color: AppTheme.textTertiary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
