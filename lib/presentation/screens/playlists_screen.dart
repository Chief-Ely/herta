import 'package:flutter/material.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  int _currentIndex = 0;

  // Track dynamic list of playlists
  final List<String> _playlists = [
    'Playlists 1',
    'Playlists 2',
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

  // Dialog to handle new playlist creation
  void _showCreatePlaylistDialog() {
    final TextEditingController playlistController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Playlist'),
          content: TextField(
            controller: playlistController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Playlist Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = playlistController.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _playlists.add(text);
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
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
        title: const Text('Playlists'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                // "Create New" Action Card
                CreateNewPlaylistCard(
                  onTap: _showCreatePlaylistDialog,
                ),
                const SizedBox(height: 16),

                // Dynamic Playlist Cards
                ..._playlists.map(
                  (name) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PlaylistCard(
                      title: name,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/playlist-detail',
                          arguments: name,
                        );
                      },
                    ),
                  ),
                ),
              ],
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

// "Create New" Action Card Widget
class CreateNewPlaylistCard extends StatelessWidget {
  final VoidCallback onTap;

  const CreateNewPlaylistCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Color(0xFFE2E7F0);

    return Material(
      color: cardBgColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: const Row(
            children: [
              Icon(
                Icons.add_rounded,
                size: 22,
                color: Colors.black87,
              ),
              SizedBox(width: 16),
              Text(
                'Create New',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Playlist Item Card Widget
class PlaylistCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const PlaylistCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Color(0xFFE2E7F0);

    return Material(
      color: cardBgColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Row(
            children: [
              const Icon(
                Icons.play_arrow_outlined,
                size: 22,
                color: Colors.black87,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}