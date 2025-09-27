import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/images.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/add_reservation/pick_date_theme.dart';
import 'package:team_egypt_v3/features/splash/data/supabase_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  String? statusMessage;

  /// Opens a date picker dialog
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return PickDateTheme(child: child!);
      },
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  /// Calls Supabase insert
  Future<void> insertDay() async {
    setState(() {
      isLoading = true;
      statusMessage = null;
    });

    final result = await SupabaseSplash.insertDay(selectedDate, context);

    setState(() {
      isLoading = false;
      statusMessage = result != null
          ? '✅ Day added: ${DateFormat.yMMMd().format(result)}'
          : '❌ Failed to insert day.';
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.intial(context);
    return Scaffold(
      backgroundColor: Col.dark1,
      body: Center(
        child: Container(
          width: ScreenSize.width / 2.5,
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.width / 20,
            vertical: ScreenSize.height / 20,
          ),
          decoration: BoxDecoration(
            color: Col.dark2,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Team Icon
              CircleAvatar(
                radius: ScreenSize.width / 18,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(Images.teamIcon),
              ),
              const SizedBox(height: 32),

              // Date display + picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Date:',
                    style: TextStyle(
                      fontSize: ScreenSize.width / 60,
                      fontWeight: FontWeight.bold,
                      color: Col.light2,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: pickDate,
                    icon: const Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Pick Date',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: Fonts.head,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Col.light2,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  DateFormat.yMMMd().format(selectedDate),
                  style: TextStyle(
                    fontSize: ScreenSize.width / 70,
                    color: Colors.black87,
                    fontFamily: Fonts.names,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Insert button
              isLoading
                  ? const CircularIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: insertDay,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Col.light2,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Start The Day',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: Fonts.head,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 24),

              // Status message
              if (statusMessage != null)
                Text(
                  statusMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusMessage!.startsWith('✅')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
