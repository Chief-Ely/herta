import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/playlist_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/search_screen.dart';
import 'presentation/screens/queue_screen.dart';
import 'presentation/screens/playlists_screen.dart';
import 'presentation/screens/playlist_detail_screen.dart';
import 'presentation/screens/downloaded_screen.dart';

void main() {
  runApp(const HertaApp());
}

class HertaApp extends StatelessWidget {
  const HertaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F72AF);

    return ChangeNotifierProvider<PlaylistData>(
      create: (context) => PlaylistData(),
      child: MaterialApp(
        title: 'HERTA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
            elevation: 0,
            centerTitle: false,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/playlist-detail') {
            final playlistTitle = settings.arguments as String? ?? 'My Playlist';
            return MaterialPageRoute(
              builder: (context) => PlaylistDetailScreen(playlistTitle: playlistTitle),
            );
          }
          return null;
        },
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/search': (context) => const SearchMusicScreen(),
          '/queue': (context) => const QueueScreen(),
          '/playlists': (context) => const PlaylistsScreen(),
          '/downloaded': (context) => const DownloadedScreen(),
        },
      ),
    );
  }
}