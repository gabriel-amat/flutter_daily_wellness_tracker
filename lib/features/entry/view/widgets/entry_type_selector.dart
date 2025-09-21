import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:daily_wellness_tracker/core/theme/app_text_style.dart';
import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EntryTypeSelector extends StatefulWidget {
  final Function(EntryType type) onTypeChanged;
  final EntryType currentType;

  const EntryTypeSelector({
    super.key,
    required this.onTypeChanged,
    required this.currentType,
  });

  @override
  State<EntryTypeSelector> createState() => _EntryTypeSelectorState();
}

class _EntryTypeSelectorState extends State<EntryTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text('What would you like to add?', style: AppTextStyle.subtitle),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onTypeChanged(EntryType.calorie);
                    },
                    child: _buildButton(
                      currentType: widget.currentType,
                      color: AppColors.primary,
                      type: EntryType.calorie,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onTypeChanged(EntryType.water),
                    child: _buildButton(
                      currentType: widget.currentType,
                      color: Colors.blue,
                      type: EntryType.water,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required Color color,
    required EntryType currentType,
    required EntryType type,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: currentType == type ? color : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Icon(
            type == EntryType.calorie
                ? Icons.local_fire_department
                : Icons.water_drop,
            color: currentType == type ? Colors.white : Colors.grey,
            size: 20,
          ),
          Text(
            type.text,
            style: TextStyle(
              color: currentType == type ? Colors.white : Colors.grey,
              fontWeight: currentType == type
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
