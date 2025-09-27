import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/images.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/app_bar/presentation/widgets/screens_button.dart';
import 'package:team_egypt_v3/features/dash_board/screens/dash_board.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/screen/time_screen.dart';

class AppBarMain extends StatefulWidget implements PreferredSizeWidget {
  const AppBarMain({super.key});

  @override
  State<AppBarMain> createState() => _AppBarMainState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarMainState extends State<AppBarMain> {
  int isChanged = Validators.isAppBarChanged;

  @override
  Widget build(BuildContext context) {
    ScreenSize.intial(context);
    return AppBar(
      backgroundColor: Col.light2,
      leadingWidth: ScreenSize.width / 3,
      leading: Row(
        children: [
          SizedBox(width: 10),
          CircleAvatar(
            backgroundImage: AssetImage(Images.tWithoutBackground),
            backgroundColor: Colors.transparent,
            radius: 25,
          ),
          SizedBox(width: 10),
          Text(
            "Team Egypt",
            style: TextStyle(
              color: Colors.black,
              fontSize: ScreenSize.width / 50,
              fontWeight: FontWeight.bold,
              fontFamily: Fonts.head,
            ),
          ),
        ],
      ),
      actions: [
        ScreensButton(
          screen: DashBoard(),
          title: "Dash Board",
          isSelected: isChanged == 1,
          onSelected: () {
            setState(() {
              Validators.isAppBarChanged = 1;
            });
          },
        ),
        ScreensButton(
          screen: TimeScreen(day: Validators.choosenDay),
          title: "Time Screen",
          isSelected: isChanged == 2,
          onSelected: () {
            setState(() {
              Validators.isAppBarChanged = 2;
            });
          },
        ),
      ],
    );
  }
}
