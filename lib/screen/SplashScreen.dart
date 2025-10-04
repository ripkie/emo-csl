import 'package:flutter/material.dart';
import 'WelcomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/Logo_CC.png'), context);
      precacheImage(const AssetImage('assets/images/Logo_Telkom.png'), context);
    });

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: const Center(
                child: Text(
                  "EMO",
                  style: TextStyle(
                    fontSize: 84,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA31B1F),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo_CC.png',
                  height: 90,
                  width: 90,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 50),
                Image.asset(
                  'assets/images/Logo_Telkom.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
