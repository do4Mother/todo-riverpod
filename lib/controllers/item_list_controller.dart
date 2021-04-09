import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learn_riverpod/controllers/auth_controller.dart';
import 'package:learn_riverpod/models/item_model.dart';
import 'package:learn_riverpod/repositories/custom_exception.dart';
import 'package:learn_riverpod/repositories/item_repository.dart';

final itemListControllerProvider =
    StateNotifierProvider<ItemListController, AsyncValue<List<Item>>>((ref) {
  final user = ref.watch(authControllerProvider);
  return ItemListController(ref.read, user?.uid);
});

class ItemListController extends StateNotifier<AsyncValue<List<Item>>> {
  final Reader _read;
  final String? _userId;

  ItemListController(this._read, this._userId) : super(AsyncValue.loading()) {
    if (_userId != null) {
      retrieveItems();
    }
  }

  Future<void> retrieveItems({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    try {
      final _items = await _read(itemRepositoryProvider)
          .retreiveItems(userId: _userId ?? '');
      if (mounted) {
        state = AsyncValue.data(_items);
      }
    } on CustomException catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addItem({required String name, bool obtained = false}) async {
    try {
      final _item = Item(name: name, obtained: obtained);
      final itemId = await _read(itemRepositoryProvider)
          .createItem(userId: _userId!, item: _item);
      state.whenData((value) =>
          state = AsyncValue.data(value..add(_item.copyWith(id: itemId))));
    } on CustomException catch (e) {
      _read(customExceptionProvider.notifier).state = e;
    }
  }

  Future<void> updateItem({required Item updatedItem}) async {
    try {
      await _read(itemRepositoryProvider)
          .updateItem(userId: _userId!, item: updatedItem);
      state.whenData((value) {
        state = AsyncValue.data([
          for (final item in value)
            if (item.id == updatedItem.id) updatedItem else item
        ]);
      });
    } on CustomException catch (e) {
      _read(customExceptionProvider.notifier).state = e;
    }
  }

  Future<void> deleteItem({required String itemId}) async {
    try {
      await _read(itemRepositoryProvider)
          .deleteItem(userId: _userId!, itemId: itemId);
      state.whenData((value) {
        value.removeWhere((e) => e.id == itemId);
        state = AsyncValue.data(value);
      });
    } on CustomException catch (e) {
      _read(customExceptionProvider.notifier).state = e;
    }
  }
}
