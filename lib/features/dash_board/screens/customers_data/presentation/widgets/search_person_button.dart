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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Col.light2, width: 2),
                ),
                backgroundColor: Colors.black.withOpacity(0.7),
                contentPadding: const EdgeInsets.all(24),
                title: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Col.light2),
                      const SizedBox(width: 8),
                      Text(
                        "Search a Person",
                        style: TextStyle(
                          color: Col.light2,
                          fontFamily: Fonts.head,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                content: SizedBox(
                  width: ScreenSize.width / 5,
                  height: ScreenSize.height / 2.3,
                  child: Column(
                    children: [
                      TextField(
                        controller: numberController,
                        decoration: InputDecoration(
                          hintText: "Enter Number",
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontFamily: Fonts.head,
                          ),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.3),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Col.light2,
                              width: 1.3,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Col.light2,
                              width: 1.8,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: Fonts.head,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        "Name : $name",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: Fonts.names,
                          fontSize: 20,
                        ),
                      ),
                      SelectableText(
                        "Number : $number",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: Fonts.names,
                          fontSize: 20,
                        ),
                      ),
                      SelectableText(
                        "Collage : $collage",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: Fonts.names,
                          fontSize: 20,
                        ),
                      ),
                      SelectableText(
                        "Code : $code",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: Fonts.names,
                          fontSize: 20,
                        ),
                      ),
                      SelectableText(
                        "partnierShip : $partnierShip",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: Fonts.names,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: ScreenSize.width / 7,
                        height: ScreenSize.height / 7,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.white),
                        child: BarcodeWidget(
                          data: number,
                          backgroundColor: Colors.white,
                          barcode: Barcode.code128(),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),

                    style: TextButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Col.light2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.black),
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
