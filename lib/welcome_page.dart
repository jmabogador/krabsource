import 'package:flutter/material.dart';
import 'package:krabsource/dashboard_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[900], // Set background color
      body: Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(seconds: 2), // Fade-in duration
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and text in a single Column
                  Image.asset(
                    'assets/krab_logo2.png', // Adjust the path if necessary
                    height: 200, // Adjust height as needed
                  ),
                  Text(
                    'KrabSource',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Change text color to white
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40, // Position the button at the bottom
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color:
                        Colors.orange[900], // Change text color to orange[900]
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
