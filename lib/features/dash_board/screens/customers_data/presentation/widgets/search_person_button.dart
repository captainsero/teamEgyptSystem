import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/users_class.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/data/supabase_customers_data.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';

class SearchPersonButton extends StatelessWidget {
  const SearchPersonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final TextEditingController numberController = TextEditingController();
        await showDialog(
          context: context,
          builder: (context) {
            String name = "";
            String number = "";
            String collage = "";
            String code = "";
            String partnierShip = "";

            return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: Center(child: Text("Search a Person")),
                content: SizedBox(
                  width: ScreenSize.width / 5,
                  height: ScreenSize.height / 2.5,
                  child: Center(
                    child: Column(
                      children: [
                        TextField(
                          controller: numberController,
                          decoration: InputDecoration(
                            hintText: "Enter Number",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: Fonts.head,
                            ),
                          ),
                        ),
                        SelectableText(
                          "Name : $name",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: Fonts.names,
                            fontSize: 20,
                          ),
                        ),
                        SelectableText(
                          "Number : $number",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: Fonts.names,
                            fontSize: 20,
                          ),
                        ),
                        SelectableText(
                          "Collage : $collage",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: Fonts.names,
                            fontSize: 20,
                          ),
                        ),
                        SelectableText(
                          "Code : $code",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: Fonts.names,
                            fontSize: 20,
                          ),
                        ),
                        SelectableText(
                          "partnierShip : $partnierShip",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: Fonts.names,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        BarcodeWidget(
                          data: number,
                          barcode: Barcode.code128(),
                          width: ScreenSize.width / 7,
                          height: ScreenSize.height / 7,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final UsersClass? user =
                          await SupabaseCustomersData.getUsersDataByNumber(
                            number: numberController.text,
                          );
                      if (user != null) {
                        String partnerShipName =
                            await TimeScreenLogic.getPartnerShipName(
                              user.partnershipCode,
                            );
                        setState(() {
                          name = user.name;
                          number = user.number;
                          collage = user.collage;
                          code = user.code;
                          partnierShip = partnerShipName;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Col.dark2),
                    child: Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Col.light2),
      child: Text(
        "Search person",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.head,
          color: Colors.black,
        ),
      ),
    );
  }
}
