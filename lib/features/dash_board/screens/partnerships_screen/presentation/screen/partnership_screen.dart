import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/logic/cubit/partner_ship_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/presentation/widgets/partnership_form.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/presentation/widgets/partnership_table.dart';

class PartnershipScreen extends StatefulWidget {
  const PartnershipScreen({super.key});

  @override
  State<PartnershipScreen> createState() => _PartnershipScreenState();
}

class _PartnershipScreenState extends State<PartnershipScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenSize.intial(context);

    return Column(
      children: [
        /// Add Offer Form
        PartnershipForm(),

        const SizedBox(height: 20),

        /// Offers Table
        Container(
          width: ScreenSize.width / 1.5,
          height: ScreenSize.height / 2,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Col.dark2,
            borderRadius: BorderRadius.circular(20),
          ),
          child: BlocBuilder<PartnerShipCubit, PartnerShipState>(
            builder: (context, state) {
              if (state is PartnerShipLoading) {
                return  Center(child: CircularIndicator());
              } else if (state is PartnerShipLoadOffers) {
                return PartnershipTable(offers: state.offers);
              } else {
                return const Center(
                  child: Text("Press reload to fetch offers"),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
