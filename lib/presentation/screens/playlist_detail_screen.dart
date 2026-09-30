import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playlist_provider.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final String playlistTitle;

  const PlaylistDetailScreen({
    super.key,
    this.playlistTitle = 'My Playlist',
  });

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  int _currentIndex = 0;

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
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
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Consumer<PlaylistData>(
              builder: (context, data, child) => ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          widget.playlistTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Playing all tracks')),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_outlined, size: 20),
                    label: const Text('Play All'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      data.addTrack('Title: New Track ${data.tracks.length + 1}');
                    },
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text('Add Music'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...data.tracks.map<Widget>(
                    (trackTitle) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TrackTile(title: trackTitle),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onBottomNavTapped,
        backgroundColor: const Color(0xFFE2E7F0),
        indicatorColor: primaryColor.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class TrackTile extends StatelessWidget {
  final String title;

  const TrackTile({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Color(0xFFE2E7F0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Icon(
            Icons.equalizer_rounded,
            size: 20,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}