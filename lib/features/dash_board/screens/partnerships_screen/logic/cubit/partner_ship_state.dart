part of 'partner_ship_cubit.dart';

@immutable
sealed class PartnerShipState {}

final class PartnerShipInitial extends PartnerShipState {}

class PartnerShipLoading extends PartnerShipState {}

class PartnerShipLoadOffers extends PartnerShipState {
  final List<OfferClass> offers;

  PartnerShipLoadOffers({required this.offers});
}
