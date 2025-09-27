import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/offer_class.dart';

class SupabasePartnership {
  static Future<OfferClass?> getOfferByCode(String code) async {
    try {
      // Method 1: Using .then() to get the response
      final response = await Supabase.instance.client
          .from("partnership")
          .select()
          .eq('offer_code', code.trim())
          .eq('active', true)
          .then((value) => value); // This converts to Future<List<dynamic>>

      if (response.isEmpty) {
        print("No offer found for code: $code");
        return null;
      }

      final offerData = response.first;
      print("Offer data: $offerData");

      return OfferClass(
        name: offerData['name'] as String,
        code: offerData['offer_code'] as String,
        type: offerData['offer_type'] as String,
        value: (offerData['offer_value'] as num).toDouble(),
        description: offerData['description'] as String,
        active: offerData['active'] as bool,
      );
    } catch (e) {
      print("Error get offer: $e");
      return null;
    }
  }

  static Future<bool> insertOffer(OfferClass offer) async {
    try {
      final supabase = Supabase.instance.client;

      // 🔍 Check if an offer already exists with same name or code
      final existing = await supabase
          .from("partnership")
          .select("id") // only need id for check
          .or("name.eq.${offer.name},offer_code.eq.${offer.code.trim()}");

      if (existing.isNotEmpty) {
        print("Offer already exists with same name or code");
        return false;
      }

      // ✅ Insert only if unique
      final response = await supabase.from("partnership").insert({
        'name': offer.name,
        'offer_code': offer.code.trim(),
        'offer_type': offer.type,
        'offer_value': offer.value,
        'description': offer.description,
        'active': true, // default active
      });

      print("Inserted offer: $response");
      return true;
    } catch (e) {
      print("Error inserting offer: $e");
      return false;
    }
  }

  static Future<String> getPartnershipName(String code) async {
    if (code == "Subscriped") {
      return "Subscriped";
    }
    try {
      final response = await Supabase.instance.client
          .from("partnership")
          .select()
          .eq('offer_code', code.trim());

      if (response.isNotEmpty) {
        return response[0]['name'] as String;
      } else {
        return "No PartnerShip"; // no partnership found
      }
    } catch (e) {
      print("Error get partnership name: $e");
      return "No PartnerShip";
    }
  }

  static Future<List<OfferClass>> getAllOffers() async {
    try {
      final response = await Supabase.instance.client
          .from("partnership")
          .select()
          .order('id', ascending: true); // 👈 keep order stable

      if (response.isEmpty) {
        return [];
      }

      return response.map<OfferClass>((offerData) {
        return OfferClass(
          name: offerData['name'] as String,
          code: offerData['offer_code'] as String,
          type: offerData['offer_type'] as String,
          value: (offerData['offer_value'] as num).toDouble(),
          description: offerData['description'] as String,
          active: offerData['active'] as bool,
        );
      }).toList();
    } catch (e) {
      print("Error fetching offers: $e");
      return [];
    }
  }

  static Future<bool> isActive(String code) async {
    try {
      final response = await Supabase.instance.client
          .from('partnership')
          .select('active')
          .eq('offer_code', code.trim());

      if (response.isNotEmpty) {
        return response[0]['active'] as bool;
      } else {
        return false; // no row found = not active
      }
    } catch (e) {
      print("Error checking active: $e");
      return false;
    }
  }

  static Future<void> toggleActive(String code) async {
    try {
      final response = await Supabase.instance.client
          .from('partnership')
          .select('active')
          .eq('offer_code', code.trim());

      if (response.isEmpty) return;

      final currentActive = response[0]['active'] as bool;

      await Supabase.instance.client
          .from('partnership')
          .update({'active': !currentActive})
          .eq('offer_code', code.trim());
    } catch (e) {
      print("Error toggling active: $e");
    }
  }

  static Future<void> deleteOffer(String code) async {
    try {
      await Supabase.instance.client
          .from('partnership')
          .delete()
          .eq('offer_code', code.trim());
    } catch (e) {
      print("Error deleting offer: $e");
    }
  }
}
