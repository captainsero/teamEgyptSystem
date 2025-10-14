import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/sign_in/data/auth.dart';
import 'package:team_egypt_v3/features/splash/presentation/screen/splash_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController emailCtrl = TextEditingController(
    text: "yomnahagag43@gmail.com",
  );
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenSize.intial(context); // initialize once per build

    return Scaffold(
      backgroundColor: Col.dark1,
      body: Center(
        child: Container(
          width: ScreenSize.width * 0.35,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Col.dark2,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sign In',
                style: TextStyle(
                  fontFamily: Fonts.head,
                  fontSize: ScreenSize.width * 0.03,
                  color: Col.light2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _buildInputField(
                label: 'Email',
                controller: emailCtrl,
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Password',
                controller: passwordCtrl,
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Col.light1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final auth = AuthService();
                    try {
                      final res = await auth.signIn(
                        email: emailCtrl.text.trim(),
                        password: passwordCtrl.text,
                      );
                      if (res != null && res.user != null) {
                        // Navigate to your home page or dashboard
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SplashScreen(),
                          ),
                        );
                      }
                    } catch (e) {
                      // Show an error snackbar/dialog
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },

                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: Fonts.names,
                      fontSize: ScreenSize.width * 0.018,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(fontFamily: Fonts.names, color: Col.light2),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Col.light1),
        labelText: label,
        labelStyle: TextStyle(fontFamily: Fonts.tableHead, color: Col.light2),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Col.light1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Col.light2, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
