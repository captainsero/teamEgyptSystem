import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/offer_class.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';

part 'partner_ship_state.dart';

class PartnerShipCubit extends Cubit<PartnerShipState> {
  PartnerShipCubit() : super(PartnerShipInitial());

  void partnerShipLoadData() async {
    emit(PartnerShipLoading());
    final offers = await SupabasePartnership.getAllOffers();
    if (isClosed) return;
    emit(PartnerShipLoadOffers(offers: offers));
  }

  Future<void> toggleActive(String code) async {
    await SupabasePartnership.toggleActive(code);
    partnerShipLoadData(); // refresh data after update
  }

  Future<void> deleteOffer(String code) async {
    await SupabasePartnership.deleteOffer(code);
    partnerShipLoadData(); // refresh after delete
  }
}
