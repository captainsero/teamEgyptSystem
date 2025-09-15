import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/items_model.dart';

class SupabaseItems {
  static final _supabase = Supabase.instance.client.from('items');

  // Insert with name checker
  static Future<bool> insert(ItemsModel items) async {
    try {
      // Check if item with same name exists
      final existing = await _supabase
          .select()
          .eq('name', items.name)
          .maybeSingle();
      if (existing != null) {
        print("Item with name '${items.name}' already exists.");
        return false;
      }
      await _supabase.insert({
        'name': items.name,
        'price': items.price,
        'quantity': items.quantity,
      });
      return true;
    } catch (e) {
      print("Error inserting item: $e");
      return false;
    }
  }

  // Get all items
  static Future<List<ItemsModel>> getAll() async {
    try {
      final response = await _supabase.select();
      return (response as List)
          .map(
            (e) => ItemsModel(
              name: e['name'],
              price: e['price'],
              quantity: e['quantity'],
            ),
          )
          .toList();
    } catch (e) {
      print("Error getting items: $e");
      return [];
    }
  }

  // Delete item by name
  static Future<bool> deleteByName(String name) async {
    try {
      await _supabase.delete().eq('name', name);
      return true;
    } catch (e) {
      print("Error deleting item: $e");
      return false;
    }
  }

  // Update item by name
  static Future<bool> updateByName(ItemsModel items) async {
    try {
      await _supabase
          .update({'price': items.price, 'quantity': items.quantity})
          .eq('name', items.name);
      return true;
    } catch (e) {
      print("Error updating item: $e");
      return false;
    }
  }
}
