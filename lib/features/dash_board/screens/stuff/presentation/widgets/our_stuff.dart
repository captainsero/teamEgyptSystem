import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';

class OurStuff extends StatelessWidget {
  const OurStuff({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 1.5,
      height: ScreenSize.height / 2.5,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconAndText(text: "Our Stuff", icon: Icons.group_sharp),
          const SizedBox(height: 20),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                children: [
                  TableHeader("Name"),
                  TableHeader("Number"),
                  TableHeader("position"),
                  Center(child: TableHeader("Actions")),
                ],
              ),
              TableRow(
                children: [
                  TableCell1("ele.name"),
                  TableCell1("{ele.price}"),
                  TableCell1("{ele.reservationNum}"),

                  IconButton(
                    onPressed: () {},
                    icon: Padding(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
