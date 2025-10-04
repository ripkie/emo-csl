import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModeGamepadPage extends StatelessWidget {
  final String deviceName;

  const ModeGamepadPage({super.key, required this.deviceName});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    });

    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double buttonSize = constraints.maxWidth * 0.08;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/images/back.png'),
                          iconSize: buttonSize,
                          onPressed: () {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "Mode Gamepad - $deviceName",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                          icon: Image.asset('assets/images/home.png'),
                          iconSize: buttonSize,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Image.asset(
                                        'assets/images/arrow_up.png',
                                        width: buttonSize,
                                        height: buttonSize,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Image.asset(
                                            'assets/images/arrow_left.png',
                                            width: buttonSize,
                                            height: buttonSize,
                                          ),
                                        ),
                                        SizedBox(width: buttonSize),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Image.asset(
                                            'assets/images/arrow_right.png',
                                            width: buttonSize,
                                            height: buttonSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Image.asset(
                                        'assets/images/arrow_down.png',
                                        width: buttonSize,
                                        height: buttonSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: buttonSize * 3),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Image.asset(
                                        'assets/images/bt_lu.png',
                                        width: buttonSize,
                                        height: buttonSize,
                                      ),
                                    ),
                                    SizedBox(width: buttonSize),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Image.asset(
                                        'assets/images/bt_ru.png',
                                        width: buttonSize,
                                        height: buttonSize,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/images/bt_forward.png',
                                    width: buttonSize,
                                    height: buttonSize,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Image.asset(
                                        'assets/images/bt_light.png',
                                        width: buttonSize,
                                        height: buttonSize,
                                      ),
                                    ),
                                    SizedBox(width: buttonSize),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Image.asset(
                                        'assets/images/bt_music.png',
                                        width: buttonSize,
                                        height: buttonSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
