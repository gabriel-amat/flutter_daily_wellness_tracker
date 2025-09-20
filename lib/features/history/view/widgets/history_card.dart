import 'package:daily_wellness_tracker/core/enums/consumptiom_item.dart';
import 'package:daily_wellness_tracker/core/helper/extensions/string_to_date_extension.dart';
import 'package:daily_wellness_tracker/features/history/viewModel/history_view_model.dart';
import 'package:daily_wellness_tracker/shared/consumption/models/consumption_item.dart';
import 'package:daily_wellness_tracker/shared/ui/snack/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryCard extends StatefulWidget {
  final ConsumptionItemEntity item;
  final HistoryViewModel viewModel;

  const HistoryCard({super.key, required this.item, required this.viewModel});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  late CustomSnack customSnack;

  @override
  void initState() {
    customSnack = context.read<CustomSnack>();
    super.initState();
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ConsumptionItemEntity item,
  ) async {
    final bool? res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text(
            'Deseja excluir este registro de ${item.type.name.toLowerCase()}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (res == true) {
      await widget.viewModel.removeItem(item);
      customSnack.success(text: 'Registro excluído com sucesso');
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    ConsumptionItemEntity item,
  ) async {
    final controller = TextEditingController(text: item.value.toString());

    final bool? res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar ${item.type.name}'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: item.type == ConsumptionType.calories
                  ? 'Calorias'
                  : 'Água (ml)',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (res == true) {
      final newValue = double.tryParse(controller.text);

      if (newValue == null || newValue <= 0) {
        customSnack.error(text: 'Por favor, insira um valor válido');
        return;
      }

      final updatedItem = ConsumptionItemEntity(
        id: item.id,
        date: item.date,
        value: newValue,
        type: item.type,
      );
      await widget.viewModel.updateItem(updatedItem);
      customSnack.success(text: 'Registro atualizado com sucesso');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCalorie = widget.item.type == ConsumptionType.calories;
    final color = isCalorie ? Colors.orange : Colors.blue;
    final icon = isCalorie ? Icons.local_fire_department : Icons.water_drop;
    final unit = isCalorie ? 'kcal' : 'ml';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          '${widget.item.value.toStringAsFixed(widget.item.type == ConsumptionType.water ? 0 : 1)} $unit',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.type.name,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            Text(
              widget.item.date.toFormattedDate() ?? '',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (String result) async {
            if (result == 'delete') {
              await _confirmDelete(context, widget.item);
            } else if (result == 'edit') {
              await _showEditDialog(context, widget.item);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Excluir', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
