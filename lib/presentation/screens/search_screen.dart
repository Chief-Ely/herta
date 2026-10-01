import 'package:flutter/material.dart';
import '../../functions/search.dart';

class SearchMusicScreen extends StatefulWidget {
  const SearchMusicScreen({super.key});

  @override
  State<SearchMusicScreen> createState() => _SearchMusicScreenState();
}

class _SearchMusicScreenState extends State<SearchMusicScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<VideoSearchResult> _searchResults = [];
  bool _isLoading = false;
  int _currentIndex = 0;

  void _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final results = await searchYouTubeMusic(query);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

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
        title: const Text('Search Music'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // Search Input Box
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _performSearch(),
                    decoration: InputDecoration(
                      hintText: 'Search songs or artists...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded),
                        onPressed: _performSearch,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFE2E7F0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // Video Thumbnails Results
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _searchResults.isEmpty
                          ? const Center(
                              child: Text(
                                'Search music to view video thumbnails',
                                style: TextStyle(color: Colors.black45),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final item = _searchResults[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ThumbnailTrackTile(
                                    result: item,
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Selected: ${item.title}'),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Bottom Navigation Bar
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

// Widget rendering only thumbnail & music audio information
class ThumbnailTrackTile extends StatelessWidget {
  final VideoSearchResult result;
  final VoidCallback onTap;

  const ThumbnailTrackTile({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const cardBgColor = Color(0xFFE2E7F0);

    return Material(
      color: cardBgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Cover Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: result.thumbnailUrl.isNotEmpty
                    ? Image.network(
                        result.thumbnailUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          width: 70,
                          height: 70,
                          color: Colors.black26,
                          child: const Icon(Icons.music_note, color: Colors.white),
                        ),
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        color: Colors.black26,
                        child: const Icon(Icons.music_note, color: Colors.white),
                      ),
              ),
              const SizedBox(width: 14),

              // Title, Channel Name, & Duration Meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${result.channelName.isNotEmpty ? result.channelName : 'Music'} ${result.duration.isNotEmpty ? '• ${result.duration}' : ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              const Icon(
                Icons.play_arrow_rounded,
                size: 24,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}