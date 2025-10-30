import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/logic/customers_data_cubit/customers_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/logic/days_data_cubit/days_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/logic/cubit/items_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/month_data/logic/cubit/month_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/logic/cubit/partner_ship_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/rooms_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/stuff/logic/cubit/stuff_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/logic/cubit/plans_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/logic/cubit/subscription_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tasks/logic/cubit/tasks_cubit.dart';
import 'package:team_egypt_v3/features/splash/presentation/screen/splash_screen.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String supabaseUrl;
  String supabaseKey;

  if (kIsWeb) {
    // 🟢 on web: take them from --dart-define
    supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
    supabaseKey = const String.fromEnvironment('SUPABASE_KEY');
  } else {
    // 🟢 on desktop/mobile: load from .env file
    await dotenv.load();
    supabaseUrl = dotenv.env['SUPABASE_URL']!;
    supabaseKey = dotenv.env['SUPABASE_KEY']!;
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  if (kIsWeb) {
    await Hive.initFlutter(); // للويب
  } else if (Platform.isWindows) {
    final exeDir = p.dirname(Platform.resolvedExecutable);
    final hivePath = p.join(exeDir, 'hive_data');
    await Directory(hivePath).create(recursive: true);
    Hive.init(hivePath);
  } else {
    await Hive.initFlutter(); // موبايل
  }

  Hive.registerAdapter(CheckoutItemsAdapter());
  Box itemsTotal = await Hive.openBox<double>('itemsTotal');
  Box noteBox = await Hive.openBox<String>('noteBox');
  await itemsTotal.compact();
  await noteBox.compact();

  if (itemsTotal.get('hourFee') == null) {
    itemsTotal.put("hourFee", 15.0);
  }
  Validators.hourFee = itemsTotal.get('hourFee');

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
        BlocProvider<MonthDataCubit>(create: (_) => MonthDataCubit()),
        BlocProvider<TasksCubit>(create: (_) => TasksCubit()..getTasks()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
