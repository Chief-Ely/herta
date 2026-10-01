import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_results/youtube_results.dart';

class VideoSearchResult {
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;
  final String channelName;

  VideoSearchResult({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.channelName,
  });
}

/// Hybrid search engine with detailed console logging and automatic fallbacks
Future<List<VideoSearchResult>> searchYouTubeMusic(String query) async {
  final trimmedQuery = query.trim();
  if (trimmedQuery.isEmpty) {
    debugPrint('--------------------------------------------------');
    debugPrint('[SEARCH DEBUG] Query is empty. Skipping search.');
    debugPrint('--------------------------------------------------');
    return [];
  }

  debugPrint('==================================================');
  debugPrint('[SEARCH DEBUG] STARTING SEARCH FOR: "$trimmedQuery"');
  debugPrint('==================================================');

  // Attempt 1: InnerTube API
  debugPrint('[SEARCH DEBUG] Attempting Method 1: YouTube InnerTube API...');
  List<VideoSearchResult> results = await _searchViaInnerTube(trimmedQuery);
  if (results.isNotEmpty) {
    debugPrint('[SEARCH DEBUG] SUCCESS! Method 1 (InnerTube) returned ${results.length} result(s).');
    return results;
  }
  debugPrint('[SEARCH DEBUG] Method 1 failed or returned 0 results.');

  // Attempt 2: Invidious Public API Mirrors
  debugPrint('[SEARCH DEBUG] Attempting Method 2: Invidious API Mirrors...');
  results = await _searchViaInvidious(trimmedQuery);
  if (results.isNotEmpty) {
    debugPrint('[SEARCH DEBUG] SUCCESS! Method 2 (Invidious) returned ${results.length} result(s).');
    return results;
  }
  debugPrint('[SEARCH DEBUG] Method 2 failed or returned 0 results.');

  // Attempt 3: youtube_results Package Fallback
  debugPrint('[SEARCH DEBUG] Attempting Method 3: youtube_results package...');
  results = await _searchViaYoutubeResultsPackage(trimmedQuery);
  if (results.isNotEmpty) {
    debugPrint('[SEARCH DEBUG] SUCCESS! Method 3 (youtube_results) returned ${results.length} result(s).');
    return results;
  }
  debugPrint('[SEARCH DEBUG] Method 3 failed or returned 0 results.');

  debugPrint('--------------------------------------------------');
  debugPrint('[SEARCH DEBUG] FAILED: All 3 search methods returned no data.');
  debugPrint('--------------------------------------------------');
  return [];
}

/// Method 1: YouTube InnerTube API endpoint
Future<List<VideoSearchResult>> _searchViaInnerTube(String query) async {
  try {
    final url = Uri.parse('https://www.youtube.com/youtubei/v1/search');
    debugPrint('[InnerTube] Sending POST request to $url');

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "context": {
              "client": {
                "clientName": "WEB",
                "clientVersion": "2.20230522.00.00"
              }
            },
            "query": query
          }),
        )
        .timeout(const Duration(seconds: 5));

    debugPrint('[InnerTube] Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<VideoSearchResult> videoList = [];

      final sectionList = data['contents']?['twoColumnSearchResultsRenderer']
          ?['primaryContents']?['sectionListRenderer']?['contents'];

      if (sectionList != null && sectionList is List) {
        debugPrint('[InnerTube] Found section list with ${sectionList.length} sections.');
        for (var section in sectionList) {
          final items = section['itemSectionRenderer']?['contents'];
          if (items != null && items is List) {
            for (var item in items) {
              final video = item['videoRenderer'];
              if (video != null) {
                final videoId = video['videoId'] ?? '';
                final title = video['title']?['runs']?[0]?['text'] ?? 'Unknown';
                final channel = video['ownerText']?['runs']?[0]?['text'] ?? '';
                final duration = video['lengthText']?['simpleText'] ?? '';

                String thumbUrl = '';
                final thumbs = video['thumbnails'] ?? video['thumbnail']?['thumbnails'];
                if (thumbs != null && thumbs is List && thumbs.isNotEmpty) {
                  thumbUrl = thumbs.last['url'] ?? '';
                }

                if (videoId.isNotEmpty) {
                  videoList.add(VideoSearchResult(
                    title: title,
                    thumbnailUrl: thumbUrl,
                    videoUrl: 'https://www.youtube.com/watch?v=$videoId',
                    duration: duration,
                    channelName: channel,
                  ));
                }
              }
            }
          }
        }
      } else {
        debugPrint('[InnerTube] JSON structure did not match expected layout or was empty.');
      }
      return videoList;
    } else {
      debugPrint('[InnerTube] Non-200 status code received: ${response.statusCode}');
    }
  } catch (e, stack) {
    debugPrint('[InnerTube ERROR] Exception: $e');
    debugPrint('[InnerTube STACKTRACE] $stack');
  }
  return [];
}

/// Method 2: Public Invidious API Search
Future<List<VideoSearchResult>> _searchViaInvidious(String query) async {
  final instances = [
    'https://inv.riverside.rocks',
    'https://invidious.nerdvpn.de',
    'https://vid.puffyan.us',
  ];

  for (final instance in instances) {
    try {
      final uri = Uri.parse('$instance/api/v1/search?q=${Uri.encodeComponent(query)}&type=video');
      debugPrint('[Invidious] Trying instance: $uri');

      final response = await http.get(uri).timeout(const Duration(seconds: 4));
      debugPrint('[Invidious] $instance returned status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint('[Invidious] Received ${data.length} raw video items.');

        final List<VideoSearchResult> videoList = [];

        for (var item in data) {
          final videoId = item['videoId'] ?? '';
          final title = item['title'] ?? 'Unknown';
          final channel = item['author'] ?? '';
          final durationSec = item['lengthSeconds'] ?? 0;
          final duration = '${durationSec ~/ 60}:${(durationSec % 60).toString().padLeft(2, '0')}';

          String thumbUrl = '';
          if (item['videoThumbnails'] != null && (item['videoThumbnails'] as List).isNotEmpty) {
            thumbUrl = item['videoThumbnails'].first['url'] ?? '';
          } else {
            thumbUrl = 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg';
          }

          if (videoId.isNotEmpty) {
            videoList.add(VideoSearchResult(
              title: title,
              thumbnailUrl: thumbUrl,
              videoUrl: 'https://www.youtube.com/watch?v=$videoId',
              duration: duration,
              channelName: channel,
            ));
          }
        }
        if (videoList.isNotEmpty) return videoList;
      }
    } catch (e) {
      debugPrint('[Invidious] Instance $instance failed: $e');
    }
  }
  return [];
}

/// Method 3: youtube_results Package Fallback
Future<List<VideoSearchResult>> _searchViaYoutubeResultsPackage(String query) async {
  try {
    debugPrint('[youtube_results] Instantiating package...');
    final youtube = YoutubeResults();

    final dynamic rawVideos = await youtube.fetchVideos(query) ?? await youtube.fetchSearchResults(query);
    debugPrint('[youtube_results] Raw output type: ${rawVideos.runtimeType}');

    if (rawVideos != null && rawVideos is List) {
      debugPrint('[youtube_results] Output list length: ${rawVideos.length}');
      List<VideoSearchResult> videoList = [];
      for (var item in rawVideos) {
        final title = item.title ?? 'Unknown Title';
        final url = item.url ?? '';
        final duration = item.duration ?? '';
        final channelName = item.channelName ?? item.channel?.name ?? '';

        String thumbnailUrl = '';
        if (item.thumbnails != null && item.thumbnails.isNotEmpty) {
          thumbnailUrl = item.thumbnails.last.url ?? item.thumbnails.first.url ?? '';
        }

        videoList.add(VideoSearchResult(
          title: title,
          thumbnailUrl: thumbnailUrl,
          videoUrl: url,
          duration: duration,
          channelName: channelName,
        ));
      }
      return videoList;
    } else {
      debugPrint('[youtube_results] Returned null or non-List output.');
    }
  } catch (e, stack) {
    debugPrint('[youtube_results ERROR] Exception: $e');
    debugPrint('[youtube_results STACKTRACE] $stack');
  }
  return [];
}