import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'camera_page.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/krab_logo2.png'), // Updated logo
        ),
        title: const Text("About KrabSource",
            style: TextStyle(color: Colors.white, fontSize: 28)),
        backgroundColor: Colors.orange[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: 24.0), // Horizontal padding only
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the left
          children: [
            SizedBox(height: 40), // Add top padding before the logo
            // Centered KrabSource logo
            Center(
              child: Image.asset(
                'assets/krabsource_logo.png', // Display logo
                height: 130,
              ),
            ),
            SizedBox(height: 30),
            // App description
            Text(
              'KrabSource',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.orange[900], // Set title color to orange[900]
              ),
            ),
            SizedBox(height: 5),
            Text(
              'KrabSource provides an interactive platform to explore and identify various crab species, leveraging Flask for the backend and Flutter for a front-end experience, and it also integrates OpenStreetMap to track and display the locations of different crab species.',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 24,
                  color: const Color.fromARGB(255, 125, 124, 124)),
            ),
            SizedBox(height: 30),
            // Team section
            Text(
              'Our Team',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.orange[900], // Set title color to orange[900]
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Ireneo A. Catequista III\n'
              'John Marc M. Abogador\n'
              'Mizraem A. Calimutan\n'
              'Rizalie S. Belarmino\n'
              'Adrian Jan Y. Hernia\n'
              'Angelica A. Villar',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 24,
                  color: const Color.fromARGB(255, 125, 124, 124)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.orange,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyPage()),
            );
          } else if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          }
        },
      ),
    );
  }
}
