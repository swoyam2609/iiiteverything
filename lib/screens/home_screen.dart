import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iiiteverything/screens/main_screen.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration:
              Duration(milliseconds: 700), // Adjust the duration as needed
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn,
                ),
              ),
              child: MainScreen(),
            );
          },
        ),
      );
    });

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            color: Color(0xFF302C42),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: SvgPicture.asset(
                            "lib/assets/bg_stripes.svg",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Lottie.asset(
                          "lib/assets/animation.json",
                        )
                      ],
                    ),
                    SvgPicture.asset(
                      "lib/assets/logo.svg",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: "Your one-stop ",
                              style: TextStyle(
                                color: Colors.purple[200],
                              ),
                            ),
                            TextSpan(
                              text: "destination for your study needs at ",
                            ),
                            TextSpan(
                              text: "IIIT Bhubaneswar",
                              style: TextStyle(
                                color: Colors.purple[200],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
