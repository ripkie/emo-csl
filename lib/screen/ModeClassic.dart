import 'package:flutter/material.dart';
import 'ModeGamepad.dart';

class ModeClassicPage extends StatefulWidget {
  final String deviceName;

  const ModeClassicPage({super.key, required this.deviceName});

  @override
  _ModeClassicPageState createState() => _ModeClassicPageState();
}

class _ModeClassicPageState extends State<ModeClassicPage> {
  Orientation? _lastOrientation;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_lastOrientation != orientation) {
          _lastOrientation = orientation;

          if (orientation == Orientation.landscape) {
            Future.microtask(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder:
                      (_) => ModeGamepadPage(deviceName: widget.deviceName),
                ),
              );
            });
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double buttonSize = constraints.maxWidth * 0.2;
                double screenHeight = constraints.maxHeight;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Image.asset('assets/images/back.png'),
                            iconSize: buttonSize,
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Mode Classic - ${widget.deviceName}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/home.png'),
                            iconSize: buttonSize,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: screenHeight * 0.8,
                      child: Column(
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
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/arrow_up.png',
                                  width: buttonSize,
                                  height: buttonSize,
                                ),
                              ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/arrow_left.png',
                                  width: buttonSize,
                                  height: buttonSize,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/bt_forward.png',
                                  width: buttonSize,
                                  height: buttonSize,
                                ),
                              ),
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
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/arrow_down.png',
                                  width: buttonSize,
                                  height: buttonSize,
                                ),
                              ),
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
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "F1",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 40),
                        Text(
                          "F2",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 40),
                        Text(
                          "F3",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 0),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
