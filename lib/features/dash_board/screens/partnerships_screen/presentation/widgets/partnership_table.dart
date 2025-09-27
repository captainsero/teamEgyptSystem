import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/models/offer_class.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/logic/cubit/partner_ship_cubit.dart';

class PartnershipTable extends StatelessWidget {
  final List<OfferClass> offers;
  const PartnershipTable({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const Center(child: Text("No offers found"));
    }

    return SingleChildScrollView(
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(1.5),
        },
        children: [
          TableRow(
            children: [
              TableHeader("Name"),
              TableHeader("Code"),
              TableHeader("Description"),
              TableHeader("Type"),
              TableHeader("Actions"),
            ],
          ),
          ...offers.map(
            (offer) => TableRow(
              children: [
                TableCell1(offer.name),
                TableCell1(offer.code),
                TableCell1(offer.description),
                TableCell1(offer.type),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<PartnerShipCubit>().deleteOffer(
                          offer.code,
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<PartnerShipCubit>().toggleActive(
                          offer.code,
                        );
                      },
                      icon: Icon(
                        offer.active ? Icons.toggle_on : Icons.toggle_off,
                        color: offer.active ? Colors.green : Colors.grey,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
