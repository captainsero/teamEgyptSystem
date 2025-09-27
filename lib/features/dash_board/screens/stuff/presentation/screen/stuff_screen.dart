import 'package:flutter/material.dart';
import 'package:team_egypt_v3/features/dash_board/screens/stuff/presentation/widgets/checkin_checkout.dart';
import 'package:team_egypt_v3/features/dash_board/screens/stuff/presentation/widgets/our_stuff.dart';

class StuffScreen extends StatefulWidget {
  const StuffScreen({super.key});

  @override
  State<StuffScreen> createState() => _StuffScreenState();
}

class _StuffScreenState extends State<StuffScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [Spacer(), CheckinCheckout(), Spacer()]),

        Spacer(),

        OurStuff(),

        Spacer(),
      ],
    );
  }
}
