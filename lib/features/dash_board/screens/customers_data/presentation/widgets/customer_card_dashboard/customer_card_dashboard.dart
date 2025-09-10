import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/customer_card_dashboard/card_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/customer_card_dashboard/partnership_future_builder.dart';

class CustomerCardDashboard extends StatelessWidget {
  const CustomerCardDashboard({
    super.key,
    required this.teamData,
  });

  final List<Map<String, dynamic>> teamData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        physics: const BouncingScrollPhysics(),
        itemCount: teamData.length,
        itemBuilder: (context, index) {
          final item = teamData[index];
    
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              color: Col.dark2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      item["name"] ?? "",
                      style: TextStyle(
                        fontFamily: Fonts.head,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Col.light2,
                      ),
                    ),
                    const SizedBox(height: 8),
    
                    CardText(
                      text: "Number",
                      itemText: item['number'] ?? '',
                    ),
    
                    CardText(
                      text: "collage",
                      itemText: item['collage'] ?? '',
                    ),
    
                    CardText(
                      text: "Total Time",
                      itemText:
                          StringExtensions.formatTime(
                            item["total_time"],
                          ),
                    ),
    
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CardText(
                              text: "Supporting points",
                              itemText: item["support_points"] ?? '',
                            ),
    
                            PartnershipFutureBuilder(item: item),
                          ],
                        ),
    
                        Center(
                          child: BarcodeWidget(
                            data: item["number"],
                            barcode: Barcode.code128(),
                            width: ScreenSize.width / 5,
                            height: ScreenSize.height / 8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}