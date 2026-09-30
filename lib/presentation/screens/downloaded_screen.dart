import 'package:flutter/material.dart';

class DownloadedScreen extends StatefulWidget {
  const DownloadedScreen({super.key});

  @override
  State<DownloadedScreen> createState() => _DownloadedScreenState();
}

class _DownloadedScreenState extends State<DownloadedScreen> {
  int _currentIndex = 0;

  // Mock downloaded tracks matching reference screen
  final List<String> _downloadedTracks = [
    'Title: Lorem Ipsum 1',
    'Title: Lorem Ipsum 2',
    'Title: Lorem Ipsum 3',
    'Title: Lorem Ipsum 4',
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      // Return to Home screen if home icon is clicked
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F72AF);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Downloaded'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _downloadedTracks.length,
              itemBuilder: (context, index) {
                final trackTitle = _downloadedTracks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DownloadedTrackTile(
                    title: trackTitle,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Playing $trackTitle')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        color: const Color(0xFFE2E7F0),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTapped,
          backgroundColor: const Color(0xFFE2E7F0),
          elevation: 0,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.black54,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// Downloaded Track Tile Widget
class DownloadedTrackTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DownloadedTrackTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Color(0xFFE2E7F0); // Light blue-gray tile background

    return Material(
      color: cardBgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              // Play Icon Button
              const Icon(
                Icons.play_arrow_rounded,
                size: 20,
                color: Colors.black87,
              ),
              const SizedBox(width: 16),

              // Track Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Equalizer Icon Indicator
              const Icon(
                Icons.equalizer_rounded,
                size: 20,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}