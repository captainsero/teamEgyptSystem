import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';

class OrededItemsColumn extends StatelessWidget {
  const OrededItemsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenSize.height / 4,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < 5; i++)
              Card(
                color: Col.dark2,
                child: Row(
                  children: [
                    Spacer(),
                    Column(
                      children: [
                        Text("Cola", style: TextStyle(color: Colors.white)),
                        Text(
                          "\$20.00 each",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),

                    // Minus button
                    Spacer(),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Col.light1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.remove, color: Colors.white),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        splashRadius: 20,
                      ),
                    ),

                    Spacer(),
                    Text("0", style: TextStyle(color: Colors.white)),

                    // Add button
                    Spacer(),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Col.light1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add, color: Colors.white),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        splashRadius: 20,
                      ),
                    ),

                    Spacer(),
                    Column(
                      children: [
                        Text("\$20.00", style: TextStyle(color: Colors.white)),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Remove",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
