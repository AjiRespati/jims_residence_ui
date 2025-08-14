import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/asset_image_with_border.dart';

class LandingDesktop extends StatefulWidget with GetItStatefulWidgetMixin {
  LandingDesktop({super.key});

  @override
  State<LandingDesktop> createState() => _LandingDesktopState();
}

class _LandingDesktopState extends State<LandingDesktop> with GetItStateMixin {
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

  ScrollController scrollControl = ScrollController();
  List<dynamic> _kosts = [];
  dynamic _solo;

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) {
      _kosts = x.kosts;
      for (var i = 0; i < _kosts.length; i++) {
        dynamic kost = _kosts[i];
        if (kost['name'] == "Residenza Solo") {
          _solo = kost;
        }
      }
      return x.kosts;
    });
    print(_kosts);
    print(_solo);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.green.shade100,
        elevation: 3,
        title: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              ),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40, child: Image.asset('logo/mini_logo.png')),
                SizedBox(
                  height: 54,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "esidenza",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.green.shade900,
                        ),
                      ),
                      SizedBox(height: 2.2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => _scrollToSection(_homeKey),
            child: Text(
              'Home',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.green.shade900,
              ),
            ),
          ),
          SizedBox(width: 30),
          TextButton(
            onPressed: () => _scrollToSection(_aboutKey),
            child: Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.green.shade900,
              ),
            ),
          ),
          SizedBox(width: 30),
          TextButton(
            onPressed: () => _scrollToSection(_galleryKey),
            child: Text(
              'Gallery',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.green.shade900,
              ),
            ),
          ),
          SizedBox(width: 30),
          TextButton(
            onPressed: () => _scrollToSection(_contactKey),
            child: Text(
              'Contact',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.green.shade900,
              ),
            ),
          ),
          SizedBox(width: 60),
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
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Text(
                                        'Definisi rumah kost idaman',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    "Bangunan baru, fasilitas lengkap, lokasi strategis, lingkungan aman.",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            const SizedBox(width: 20),
                            AssetImageWithBorder(
                              imagePath: "images/main_image.jpg",
                              width: MediaQuery.of(context).size.width / 4,
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SizedBox(
                      height: 70,
                      width: 600,
                      child: Card(
                        shape: StadiumBorder(),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  Text("Kamar tersedia"),
                                  Text(_solo?['availableRoomsCount'] ?? ""),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
    return Scaffold(
      body: Stack(
        children: [
          Scrollbar(
            controller: scrollControl,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 8,
            child: SingleChildScrollView(
              controller: scrollControl,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _kosts.length,
                    itemBuilder: (context, idx) {
                      if (idx % 2 != 0) {
                        return Column(
                          children: [
                            Row(children: [Text(_kosts[idx]['name'])]),
                            Row(
                              children: [
                                Text(_kosts[idx]['availableRoomsCount']),
                              ],
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          SizedBox(width: 50),
                          Column(
                            children: [
                              Text(_kosts[idx]['name']),
                              Row(
                                children: [
                                  Text(_kosts[idx]['availableRoomsCount']),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.2),
                ),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    child: Image.asset('logo/mini_logo.png'),
                  ),
                  SizedBox(
                    height: 54,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "esidenza",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
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
