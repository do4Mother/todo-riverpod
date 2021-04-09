import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learn_riverpod/controllers/item_list_controller.dart';
import 'package:learn_riverpod/repositories/custom_exception.dart';
import 'package:learn_riverpod/widgets/add_item_dialog.dart';

class ItemList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final itemListState = useProvider(itemListControllerProvider);
    return itemListState.when(
      data: (items) {
        if (items.isNotEmpty) {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              return Dismissible(
                key: ValueKey(item.id),
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  context
                      .read(itemListControllerProvider.notifier)
                      .deleteItem(itemId: item.id ?? '');
                },
                child: ListTile(
                  key: ValueKey(item.id),
                  title: Text(
                    item.name,
                  ),
                  trailing: Checkbox(
                    value: item.obtained,
                    onChanged: (val) {
                      context
                          .read(itemListControllerProvider.notifier)
                          .updateItem(
                            updatedItem: item.copyWith(
                              obtained: val ?? false,
                            ),
                          );
                    },
                  ),
                  onTap: () {
                    AddItemDialog.show(context, item);
                  },
                ),
              );
            },
          );
        }
        return const Center(
          child: Text('Tap + to add an item'),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      error: (error, _) {
        return Column(
          children: [
            Text(
              error is CustomException
                  ? error.message!
                  : 'Something went wrong!',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read(itemListControllerProvider.notifier)
                    .retrieveItems(isRefreshing: true);
              },
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }
}
