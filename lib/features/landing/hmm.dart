import 'package:flutter/material.dart';

void main() {
  runApp(const ResidenzaApp());
}

class ResidenzaApp extends StatelessWidget {
  const ResidenzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Residenza',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // Lorem ipsum placeholder text for content sections
  static const String loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Residenza',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => _scrollToSection(_homeKey),
            child: const Text('Home'),
          ),
          TextButton(
            onPressed: () => _scrollToSection(_aboutKey),
            child: const Text('About'),
          ),
          TextButton(
            onPressed: () => _scrollToSection(_galleryKey),
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => _scrollToSection(_contactKey),
            child: const Text('Contact'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            // Home Section
            Container(
              key: _homeKey,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Home',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildContentSection(),
                ],
              ),
            ),
            // About Section
            Container(
              key: _aboutKey,
              padding: const EdgeInsets.all(24),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildContentSection(),
                ],
              ),
            ),
            // Gallery Section
            Container(
              key: _galleryKey,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gallery',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildContentSection(),
                ],
              ),
            ),
            // Contact Section
            Container(
              key: _contactKey,
              padding: const EdgeInsets.all(24),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildContentSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A helper method to build three lorem ipsum paragraphs
  Widget _buildContentSection() {
    return Column(
      children: [
        Text(loremIpsum, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        Text(loremIpsum, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        Text(loremIpsum, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
