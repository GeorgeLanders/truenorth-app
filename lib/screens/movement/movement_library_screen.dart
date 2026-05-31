import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../services/storage_service.dart';

class MovementLibraryScreen extends StatefulWidget {
  const MovementLibraryScreen({super.key});
  @override
  State<MovementLibraryScreen> createState() => _MovementLibraryScreenState();
}

class _MovementLibraryScreenState extends State<MovementLibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _storage = StorageService();

  final List<_VideoInfo> _allVideos = [
    _VideoInfo('Seated Leg Lifts', 'seated', '1 min', 'assets/videos/seated_leg_lifts.mp4', true),
    _VideoInfo('Seated Torso Twist', 'seated', '2 min', 'assets/videos/seated_torso_twist.mp4', true),
    _VideoInfo('Seated Arm Circles', 'seated', '3 min', 'assets/videos/seated_arm_circles.mp4', true),
    _VideoInfo('Seated Forward Fold', 'seated', '4 min', 'assets/videos/seated_forward_fold.mp4', true),
    _VideoInfo('Body Scan Relaxation', 'seated', '10 min', 'assets/videos/body_scan_relaxation.mp4', true),

    _VideoInfo('Gentle Morning Stroll', 'low_impact', '8 min', 'assets/videos/gentle_morning_stroll.mp4', false),
    _VideoInfo('Side Steps', 'low_impact', '5 min', 'assets/videos/side_steps.mp4', false),
    _VideoInfo('Cat-Cow Stretch', 'low_impact', '5 min', 'assets/videos/cat_cow_stretch.mp4', true),
    _VideoInfo('Gentle Neck Stretch', 'low_impact', '4 min', 'assets/videos/gentle_neck_stretch.mp4', false),
    _VideoInfo('Relaxation Breath', 'low_impact', '5 min', 'assets/videos/relaxation_breath.mp4', true),

    _VideoInfo('Box Breathing', 'joyful', '5 min', 'assets/videos/box_breathing.mp4', true),
    _VideoInfo('Mindful Movement', 'joyful', '8 min', 'assets/videos/mindfull.mp4', true),
    _VideoInfo('Full Body Flow', 'joyful', '15 min', 'assets/videos/exercise.mp4', false),
    _VideoInfo('Energizing Flow 1', 'joyful', '12 min', 'assets/videos/exercise1.mp4', false),
    _VideoInfo('Energizing Flow 2', 'joyful', '15 min', 'assets/videos/exercise2.mp4', false),
    _VideoInfo('Body Weight Moves', 'joyful', '10 min', 'assets/videos/will_push.mp4', false),
    _VideoInfo('Walking Workout', 'joyful', '10 min', 'assets/videos/exercise3.mp4', false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_VideoInfo> _getVideos(String category) {
    return _allVideos.where((v) => v.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      appBar: AppBar(
        title: const Text('Movement Library', style: TextStyle(color: AppTheme.softSand, fontSize: 20)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.warmCoral,
          labelColor: AppTheme.warmCoral,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Seated'),
            Tab(text: 'Low Impact'),
            Tab(text: 'Joyful'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategory('seated', Icons.accessible, 'Gentle exercises you can do from a chair'),
          _buildCategory('low_impact', Icons.directions_walk, 'Supported movements with modifications'),
          _buildCategory('joyful', Icons.self_improvement, 'Move at your own pace, your way'),
        ],
      ),
    );
  }

  Widget _buildCategory(String category, IconData icon, String subtitle) {
    final videos = _getVideos(category);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.warmCoral, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(subtitle,
                    style: TextStyle(fontSize: 14, color: AppTheme.softSand.withValues(alpha: 0.7))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...videos.map((video) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _videoCard(video),
          )),
        ],
      ),
    );
  }

  Widget _videoCard(_VideoInfo video) {
    return GestureDetector(
      onTap: () {
        if (video.isAvailable) {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(video: video),
          )).then((_) {
            // After watching, update daily streak and movement minutes
            final user = _storage.loadUserData();
            final minutes = int.tryParse(video.duration.replaceAll(' min', '')) ?? 5;
            user.movementMinutes += minutes;

            // Proper daily streak: only count 1 per day
            final today = DateTime.now().toIso8601String().split('T')[0];
            if (user.lastActivityDate == null) {
              user.streak = 1; // first activity ever
            } else if (user.lastActivityDate == today) {
              // already active today, don't double-count
            } else if (user.lastActivityDate ==
                DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0]) {
              user.streak += 1; // consecutive day
            } else {
              user.streak = 1; // gap → reset streak
            }
            user.lastActivityDate = today;
            _storage.saveUserData(user);
            // Also persist to daily_logs table for history/analytics
            _storage.saveDailyLog(
              date: today,
              movementMinutes: user.movementMinutes,
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"${video.title}" will be available after you transfer the video file to your phone.'),
              backgroundColor: AppTheme.darkTeal,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        radius: 16,
        opacity: 0.08,
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: video.isAvailable ? AppTheme.warmCoral.withValues(alpha: 0.15) : AppTheme.glassWhite,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                video.isAvailable ? Icons.play_circle_fill : Icons.videocam_off_outlined,
                color: video.isAvailable ? AppTheme.warmCoral : Colors.white30,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.softSand)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 12, color: Colors.white.withValues(alpha: 0.4)),
                      const SizedBox(width: 4),
                      Text(video.duration,
                          style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.5))),
                      if (!video.isAvailable) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('ADD VIDEO', style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.4))),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.3), size: 20),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final _VideoInfo video;
  const VideoPlayerScreen({super.key, required this.video});
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      if (widget.video.assetPath.startsWith('assets/')) {
        _controller = VideoPlayerController.asset(widget.video.assetPath);
      } else {
        _controller = VideoPlayerController.file(File(widget.video.assetPath));
      }
      await _controller!.initialize();
      setState(() => _isInitialized = true);
    } catch (e) {
      print('Video load error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      appBar: AppBar(
        title: Text(widget.video.title, style: const TextStyle(color: AppTheme.softSand)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.softSand),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Video Player
          Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: AspectRatio(
              aspectRatio: _isInitialized && _controller != null
                  ? _controller!.value.aspectRatio
                  : 16 / 9,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isInitialized && _controller != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox.expand(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_isPlaying) {
                                  _controller!.pause();
                                  _isPlaying = false;
                                } else {
                                  _controller!.play();
                                  _isPlaying = true;
                                }
                              });
                            },
                            child: VideoPlayer(_controller!),
                          ),
                        ),
                      )
                    else
                      const Center(child: CircularProgressIndicator(color: AppTheme.warmCoral)),
                    if (!_isPlaying && _isInitialized)
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.warmCoral.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                          onPressed: () {
                            _controller!.play();
                            setState(() => _isPlaying = true);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Video Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.video.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          // Controls
          if (_isInitialized)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10, color: AppTheme.softSand),
                    onPressed: () {
                      final pos = _controller!.value.position - const Duration(seconds: 10);
                      _controller!.seekTo(pos);
                    },
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: AppTheme.warmCoral, size: 48),
                    onPressed: () {
                      setState(() {
                        if (_isPlaying) { _controller!.pause(); _isPlaying = false; }
                        else { _controller!.play(); _isPlaying = true; }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.forward_10, color: AppTheme.softSand),
                    onPressed: () {
                      final pos = _controller!.value.position + const Duration(seconds: 10);
                      _controller!.seekTo(pos);
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          // Modification tips
          GlassCard(
            padding: const EdgeInsets.all(16),
            opacity: 0.1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.warmAmber, size: 18),
                    const SizedBox(width: 8),
                    const Text('Modification Tips', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.softSand)),
                  ],
                ),
                const SizedBox(height: 10),
                Text('• Go at your own pace — there\'s no rush',
                    style: TextStyle(fontSize: 13, color: AppTheme.softSand.withValues(alpha: 0.7), height: 1.6)),
                Text('• Stop if you feel any pain or discomfort',
                    style: TextStyle(fontSize: 13, color: AppTheme.softSand.withValues(alpha: 0.7), height: 1.6)),
                Text('• Breathe steadily throughout',
                    style: TextStyle(fontSize: 13, color: AppTheme.softSand.withValues(alpha: 0.7), height: 1.6)),
                Text('• Use a chair or wall for support if needed',
                    style: TextStyle(fontSize: 13, color: AppTheme.softSand.withValues(alpha: 0.7), height: 1.6)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Completion
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check_circle),
                label: const Text('Complete & Log Movement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.softMint,
                  foregroundColor: AppTheme.charcoal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoInfo {
  final String title;
  final String category; // seated, low_impact, joyful
  final String duration;
  final String assetPath;
  final bool isAvailable;

  _VideoInfo(this.title, this.category, this.duration, this.assetPath, this.isAvailable);
}
