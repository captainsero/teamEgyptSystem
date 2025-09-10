import 'package:team_egypt_v3/core/models/offer_class.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';

class TimeScreenLogic {
  static double applyOffer(double total, double hours, OfferClass? offer) {
    if (offer == null) return total;

    switch (offer.type) {
      case "percentage":
        return total - (total * offer.value / 100);

      case "fixed":
        return (total - offer.value).clamp(0, double.infinity);

      case "freeHour":
        final chargeableHours = (hours - offer.value).clamp(0, double.infinity);
        return (chargeableHours * 15).roundToDouble();

      case "freeItem":
        // price stays same, but you can track free item separately
        return total;
    }
    return total;
  }

  static Future<String> getPartnerShipName(String code) async {
    return SupabasePartnership.getPartnershipName(code);
  }
}
