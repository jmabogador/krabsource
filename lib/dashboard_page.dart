import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'camera_page.dart'; // Import your camera page
import 'about_page.dart'; // Import the about page
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0; // Make this mutable
  late WebViewControllerPlus _controller;
  PageController _pageController = PageController();

  @override
  void initState() {
    _controller = WebViewControllerPlus()
      ..loadRequest(Uri.parse('http://192.168.236.238:5000/species_map'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _controller.runJavaScript('''
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            document.getElementsByTagName('head')[0].appendChild(meta);
            ''');
          },
        ),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/krab_logo2.png'),
        ),
        title: const Text("KrabSource",
            style: TextStyle(color: Colors.white, fontSize: 28)),
        backgroundColor: Colors.orange[900],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Crab Mappings",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // WebView section with fixed height and legend overlay
              // WebView section with fixed height and vertical legend overlay on the right with background
              Container(
                height: 200, // Fixed height to prevent overlapping
                child: Stack(
                  children: [
                    // WebView
                    WebViewWidget(
                      controller: _controller,
                    ),

                    // Vertical Legend overlay on the right with background using Positioned
                    Positioned(
                      right: 10, // Adjust the right margin for positioning
                      top: 10, // Adjust the top margin if necessary
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                              0.7), // Background color with transparency
                          borderRadius: BorderRadius.circular(
                              8), // Rounded corners for a softer look
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(4, 4), // Shadow positioning
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Legend:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                                height: 8), // Space between title and items
                            _buildLegendItem('Kasag (Female)', Colors.pink),
                            _buildLegendItem('Kasag (Male)', Colors.blue),
                            _buildLegendItem('Alimango', Colors.red),
                            _buildLegendItem('Dawat (Adult)', Colors.green),
                            _buildLegendItem(
                                'Dawat Juvenile', Colors.lightGreen),
                            _buildLegendItem('Kumong', Colors.purple),
                            _buildLegendItem('Kurusan', Colors.orange),
                            _buildLegendItem('Kalintugas', Colors.yellow),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Spacer for some vertical separation
              SizedBox(height: 30),

              // Species carousel section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Carousel with PageView
                    Container(
                      height:
                          400, // Adjusted height for the carousel to fit portrait images
                      child: PageView(
                        controller: _pageController,
                        children: [
                          _buildSpeciesCard(
                              'assets/alimango.jpg',
                              'Alimango (Scylla olivacea)',
                              'Inhabit mangroves; benthic carnivore, feed mainly on molluscs.'),
                          _buildSpeciesCard(
                            'assets/kasag.jpg',
                            'Kasag (Portunus pelagicus)',
                            'A type of crab commonly found in the coastal waters of the Philippines.',
                          ),
                          _buildSpeciesCard(
                            'assets/kurusan.jpg',
                            'Kurusan (Charybdis fereiata)',
                            'Known for its hard shell and large size.',
                          ),
                          _buildSpeciesCard(
                            'assets/dawat.jpg',
                            'Dawat (Thalamita crenata)',
                            'A species of crab, either adult or juvenile, found in different coastal areas.',
                          ),
                          _buildSpeciesCard(
                            'assets/kalintugas.jpg',
                            'Kalintugas (Charybdis variegata)',
                            'A species of crab found in mangroves and shallow waters.',
                          ),
                          _buildSpeciesCard(
                            'assets/kumong.jpg',
                            'Kumong (Menippe rumphii)',
                            'A rare species of crab with a distinct shape and size.',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    // Dot Indicator
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 6, // Number of items in the carousel
                      effect: ExpandingDotsEffect(
                        dotWidth: 8,
                        dotHeight: 8,
                        expansionFactor: 4,
                        spacing: 4,
                        activeDotColor: Colors.orange,
                        dotColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.orange,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index
          });

          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 10),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // Modify _buildSpeciesCard method to adjust image aspect
  Widget _buildSpeciesCard(String imagePath, String name, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: MediaQuery.of(context).size.width * 0.7, // 70% of the screen width
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 250, // Adjusted height for portrait image
            width: double.infinity, // Full width
            fit: BoxFit.cover, // Ensure it scales properly within the container
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
