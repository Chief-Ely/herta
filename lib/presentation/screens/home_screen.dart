import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F72AF);
    const cardBgColor = Color(0xFFD9D9D9);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HERTA'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top section: Left Tall Card + Right Stacked Cards
                  Expanded(
                    flex: 5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Search Music - Tall Card
                        Expanded(
                          child: DashboardCard(
                            title: 'Search Music',
                            bgColor: cardBgColor,
                            icon: Icons.search_rounded,
                            onTap: () {
                              Navigator.pushNamed(context, '/search');
                            },
                          ),
                        ),
                        const SizedBox(width: 16),

                        // In Queue & Playlist
                        Expanded(
                          child: Column(
                            children: [
                              // In Queue Card
                              Expanded(
                                flex: 3,
                                child: DashboardCard(
                                  title: 'In queue',
                                  bgColor: cardBgColor,
                                  icon: Icons.queue_music_rounded,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/queue');
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Playlist Card
                              Expanded(
                                flex: 2,
                                child: DashboardCard(
                                  title: 'Playlist',
                                  bgColor: cardBgColor,
                                  icon: Icons.playlist_play_rounded,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/playlists');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Downloaded Music - Wide Card
                  Expanded(
                    flex: 2,
                    child: DashboardCard(
                      title: 'Downloaded Music',
                      bgColor: cardBgColor,
                      icon: Icons.download_done_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, '/downloaded');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        color: const Color(0xFFE2E7F0),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
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

// Dashboard Card Component
class DashboardCard extends StatelessWidget {
  final String title;
  final Color bgColor;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.bgColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Material(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity,
                child: Icon(
                  icon,
                  size: 36,
                  color: Colors.black38,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}