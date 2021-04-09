import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learn_riverpod/controllers/auth_controller.dart';
import 'package:learn_riverpod/models/item_model.dart';
import 'package:learn_riverpod/repositories/custom_exception.dart';
import 'package:learn_riverpod/widgets/add_item_dialog.dart';
import 'package:learn_riverpod/widgets/item_list.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping list'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddItemDialog.show(context, Item.empty());
        },
        child: const Icon(Icons.add),
      ),
      body: ProviderListener(
        onChange: (context, StateController<CustomException?> snapshot) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(snapshot.state?.message ?? ''),
            ),
          );
        },
        provider: customExceptionProvider,
        child: ItemList(),
      ),
    );
  }
}
