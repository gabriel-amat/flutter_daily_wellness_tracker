// import 'package:daily_wellness_tracker/core/enums/entry_type_enum.dart';
// import 'package:daily_wellness_tracker/core/helper/extensions/string_to_date_extension.dart';
// import 'package:daily_wellness_tracker/core/theme/app_theme.dart';
// import 'package:daily_wellness_tracker/features/history/presentation/viewModel/history_view_model.dart';
// import 'package:daily_wellness_tracker/shared/consumption/data/models/consumption_item_entity.dart';
// import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class HistoryCard extends StatefulWidget {
//   final ConsumptionItemEntity item;
//   final bool canEdit;

//   const HistoryCard({super.key, required this.item, this.canEdit = true});

//   @override
//   State<HistoryCard> createState() => _HistoryCardState();
// }

// class _HistoryCardState extends State<HistoryCard> {
//   late CustomSnack customSnack;
//   late HistoryViewModel viewModel;

//   @override
//   void initState() {
//     customSnack = context.read<CustomSnack>();
//     viewModel = context.read<HistoryViewModel>();
//     super.initState();
//   }

//   Future<void> _confirmDelete(
//     BuildContext context,
//     ConsumptionItemEntity item,
//   ) async {
//     final bool? res = await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Confirm deletion'),
//           content: Text(
//             'Do you want to delete this ${item.type.name.toLowerCase()} entry?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               style: TextButton.styleFrom(foregroundColor: Colors.red),
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );

//     if (res == true) {
//       await viewModel.removeItem(item);
//       customSnack.success(text: 'Record deleted successfully');
//     }
//   }

//   Future<void> _showEditDialog(
//     BuildContext context,
//     ConsumptionItemEntity item,
//   ) async {
    
//     final controller = TextEditingController(
//       text: item.type == EntryType.meal
//           ? item.calorie.toString()
//           : item.water.toString(),
//     );

//     final bool? res = await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit ${item.type.name}'),
//           content: TextField(
//             controller: controller,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: item.type == EntryType.meal
//                   ? 'Meal (kcal)'
//                   : 'Water (ml)',
//               border: const OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );

//     if (res == true) {
//       final newValue = double.tryParse(controller.text);

//       if (newValue == null || newValue <= 0) {
//         customSnack.error(text: 'Please enter a valid value');
//         return;
//       }

//       if (item.type == EntryType.meal) {
//         item.copyWith(calorie: newValue);
//       } else {
//         item.copyWith(water: newValue);
//       }

//       await viewModel.updateItem(item);
//       customSnack.success(text: 'Record updated successfully');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMeal = widget.item.type == EntryType.meal;
//     final color = isMeal ? Colors.orange : Colors.blue;
//     final icon = isMeal ? Icons.local_fire_department : Icons.water_drop;
//     final unit = isMeal ? 'kcal' : 'ml';

//     return Card(
//       margin: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(AppTheme.borderRadius),
//         side: BorderSide(color: color.withValues(alpha: 0.2)),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         leading: CircleAvatar(
//           backgroundColor: color.withValues(alpha: 0.1),
//           child: Icon(icon, color: color),
//         ),
//         title: Text(
//           isMeal
//               ? '${widget.item.calorie.toStringAsFixed(0)} $unit'
//               : '${widget.item.water.toStringAsFixed(0)} $unit',
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.item.type.name,
//               style: TextStyle(
//                 color: color,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 12,
//               ),
//             ),
//             Text(
//               widget.item.date.toFormattedDate() ?? '',
//               style: TextStyle(color: Colors.grey[600], fontSize: 12),
//             ),
//           ],
//         ),
//         trailing: widget.canEdit
//             ? PopupMenuButton<String>(
//                 onSelected: (String result) async {
//                   if (result == 'delete') {
//                     await _confirmDelete(context, widget.item);
//                   } else if (result == 'edit') {
//                     await _showEditDialog(context, widget.item);
//                   }
//                 },
//                 itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                   const PopupMenuItem<String>(
//                     value: 'edit',
//                     child: Row(
//                       children: [
//                         Icon(Icons.edit, size: 16),
//                         SizedBox(width: 8),
//                         Text('Edit'),
//                       ],
//                     ),
//                   ),
//                   const PopupMenuItem<String>(
//                     value: 'delete',
//                     child: Row(
//                       children: [
//                         Icon(Icons.delete, size: 16, color: Colors.red),
//                         SizedBox(width: 8),
//                         Text('Delete', style: TextStyle(color: Colors.red)),
//                       ],
//                     ),
//                   ),
//                 ],
//               )
//             : null,
//       ),
//     );
//   }
// }
