import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/models/in_team_users.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/checkout/checkout_button.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/name_text.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customer_card/note_button/note_button.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key, required this.item});

  final InTeamUsers item;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Col.dark2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          // 🔥 Main row: left info + right buttons
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LEFT SIDE (all texts)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NameText(name: item.name),
                  const SizedBox(height: 8),

                  // Phone & collage row
                  Row(
                    children: [
                      IconAndText(
                        icon: Icons.phone_outlined,
                        text: item.number,
                      ),
                      const SizedBox(width: 10),
                      // IconAndText(
                      //   icon: Icons.school_outlined,
                      //   text: item.collage,
                      // ),
                      Icon(Icons.school_outlined, color: Col.light2),
                      SizedBox(width: 5),
                      SizedBox(
                        width: ScreenSize.width / 6,
                        child: Text(
                          item.collage,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            color: Col.light2,
                            fontFamily: Fonts.names,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Timer text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringExtensions.getElapsedTime(item.timer),
                        style: TextStyle(
                          fontSize: 25,
                          color: Col.light1,
                          fontFamily: Fonts.names,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 15),

                      FutureBuilder<String>(
                        future: TimeScreenLogic.getPartnerShipName(
                          item.partnershipCode,
                        ),
                        builder: (context, snapshot) {
                          return IconAndText(
                            icon: Icons.group,
                            text: snapshot.data ?? "No Partnership",
                          );
                        },
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text(
                        "Time Active",
                        style: TextStyle(
                          color: Col.light1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // RIGHT SIDE (Note + Checkout buttons stacked vertically)
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NoteButton(
                  name: item.name,
                  number: item.number,
                  collage: item.collage,
                  parntershipCode: item.partnershipCode,
                ),
                SizedBox(height: 60),
                CheckoutButton(user: item, timer: item.timer),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
