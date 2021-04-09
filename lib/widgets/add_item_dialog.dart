import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:learn_riverpod/controllers/item_list_controller.dart';
import 'package:learn_riverpod/models/item_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddItemDialog extends HookWidget {
  const AddItemDialog({Key? key, required this.item}) : super(key: key);

  static void show(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (_) => AddItemDialog(
        item: item,
      ),
    );
  }

  final Item item;

  bool get isUpdating => item.id != null;

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(text: item.name);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'item name'),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: isUpdating
                      ? Colors.purple
                      : Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  isUpdating
                      ? context
                          .read(itemListControllerProvider.notifier)
                          .updateItem(
                            updatedItem: item.copyWith(
                              name: textController.text.trim(),
                            ),
                          )
                      : context
                          .read(itemListControllerProvider.notifier)
                          .addItem(
                            name: textController.text.trim(),
                          );
                  Navigator.pop(context);
                },
                child: Text(isUpdating ? 'Update' : 'Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
