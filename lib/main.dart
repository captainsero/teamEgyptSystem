import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/logic/customers_data_cubit/customers_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/logic/days_data_cubit/days_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/logic/cubit/items_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/logic/cubit/partner_ship_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/rooms_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/stuff/logic/cubit/stuff_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/logic/cubit/plans_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/logic/cubit/subscription_cubit.dart';
import 'package:team_egypt_v3/features/splash/presentation/screen/splash_screen.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://eykuucqwmgnfjbczkice.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV5a3V1Y3F3bWduZmpiY3praWNlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwMTQwODgsImV4cCI6MjA3MDU5MDA4OH0.2FP_QbOXWeXCBLk4j71CmS8Pj27yyyHNzDNuKM4rPp0",
  );

  if (Platform.isWindows) {
    final hivePath =
        '${Platform.environment['APPDATA']}\\team_egypt_v_1_0_1\\hive_data';
    await Directory(hivePath).create(recursive: true); // Make sure it exists
    Hive.init(hivePath);
  } else {
    await Hive.initFlutter();
  }
  Hive.registerAdapter(CheckoutItemsAdapter());


  // Box itemsBox = await Hive.openBox<CheckoutItems>('itemsBox');
  // Box itemsTotal = await Hive.openBox<double>('itemsTotal');
  // await itemsBox.clear();
  // await itemsBox.close();
  // await itemsTotal.clear();
  // await itemsTotal.close();
  await Hive.deleteBoxFromDisk('itemsBox');
  await Hive.deleteBoxFromDisk('itemsTotal');

  Box itemsBox2 = await Hive.openBox<CheckoutItems>('itemsBox');
  Box itemsTotal2 = await Hive.openBox<double>('itemsTotal');
  await itemsTotal2.compact();
  await itemsBox2.compact();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomersDataCubit>(
          create: (context) => CustomersDataCubit(),
        ),
        BlocProvider<TimeScreenCubit>(create: (_) => TimeScreenCubit()),
        BlocProvider<InTeamCubit>(
          create: (context) => InTeamCubit()..loadUsers(),
        ),
        BlocProvider<DaysDataCubit>(create: (_) => DaysDataCubit()),
        BlocProvider<PartnerShipCubit>(create: (_) => PartnerShipCubit()),
        BlocProvider<SubscriptionCubit>(
          create: (_) => SubscriptionCubit()..getSubscriptions(),
        ),
        BlocProvider<PlansCubit>(create: (_) => PlansCubit()..getPlans()),
        BlocProvider<RoomsCubit>(create: (_) => RoomsCubit()..getRooms()),
        BlocProvider<ReservationCubit>(
          create: (_) => ReservationCubit()..getAllRev(),
        ),
        BlocProvider<StuffCubit>(create: (_) => StuffCubit()..getAll()),
        BlocProvider<ItemsCubit>(create: (_) => ItemsCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
