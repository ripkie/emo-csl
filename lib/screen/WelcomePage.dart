import 'package:flutter/material.dart';
import 'BluetoothPairingPage1.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/WP1.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Logo_CC.png',
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 20,
            right: 20,
            child: Text(
              "SELAMAT DATANG DI\nEMO's APP",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.65,
            left: 20,
            right: 20,
            child: Text(
              "siap jadi si\npaling robotik?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: Color(0xFF373739)),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BluetoothPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA31B1F),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "SIAP!",
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ], // Children
      ),
    );
  } // Widget
} //Class
