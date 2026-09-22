import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:online_learning_application/models/course.dart';
import 'package:online_learning_application/models/lesson.dart';
import 'package:online_learning_application/providers/course_provider.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/views/main_navigation.dart';

class LearningScreen extends StatefulWidget {
  final Course course;

  const LearningScreen({super.key, required this.course});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late YoutubePlayerController _youtubeController;
  late Lesson _activeLesson;

  @override
  void initState() {
    super.initState();
    _activeLesson = widget.course.lessons.first;
    
    // Initialize YouTube player
    final videoId = YoutubePlayerController.convertUrlToId(_activeLesson.videoUrl) ?? 'CD1Y2DmL5JM';
    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );
  }

  void _changeLesson(Lesson lesson) {
    setState(() {
      _activeLesson = lesson;
    });

    Provider.of<CourseProvider>(context, listen: false).markLessonCompleted(widget.course.id, lesson.id);

    final newVideoId = YoutubePlayerController.convertUrlToId(lesson.videoUrl) ?? 'CD1Y2DmL5JM';
    _youtubeController.loadVideoById(videoId: newVideoId);
  }

  @override
  void dispose() {
    _youtubeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery calculation method
    final mq         = MediaQuery.of(context);
    final sw         = mq.size.width;
    final outerPad   = sw * 0.040;
    final cardGap    = mq.size.height * 0.014;
    final cardRowGap = sw * 0.028;

    final courseProvider = Provider.of<CourseProvider>(context);
    final liveCourse = courseProvider.purchasedCourses.firstWhere(
      (c) => c.id == widget.course.id,
      orElse: () => widget.course,
    );

    final progress = courseProvider.getCourseProgress(liveCourse);
    final completedCount = liveCourse.lessons.where((l) => l.isCompleted).length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(widget.course.title),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainNavigation(initialIndex: 0)),
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Embedded YouTube Player
          YoutubePlayer(
            controller: _youtubeController,
            aspectRatio: 16 / 9,
          ),

          // Active Lesson Header
          Container(
            padding: EdgeInsets.all(outerPad),
            color: AppColors.cardBg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _activeLesson.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ),
                    SizedBox(width: cardRowGap),
                    Text(
                      '$completedCount/${liveCourse.lessons.length} Completed',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMid),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Lessons List Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: outerPad, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Course Lessons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                Text('${liveCourse.lessons.length} Videos', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ],
            ),
          ),

          // Lessons List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              itemCount: liveCourse.lessons.length,
              itemBuilder: (context, index) {
                final lesson = liveCourse.lessons[index];
                final isActive = lesson.id == _activeLesson.id;

                return Container(
                  margin: EdgeInsets.only(bottom: cardGap * 0.6),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      onTap: () => _changeLesson(lesson),
                      leading: Icon(
                        lesson.isCompleted ? Icons.check_circle : Icons.play_circle_outline,
                        color: lesson.isCompleted || isActive ? AppColors.primary : Colors.grey,
                      ),
                      title: Text(
                        lesson.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                          color: isActive ? AppColors.primary : AppColors.textDark,
                        ),
                      ),
                      trailing: Text(
                        lesson.duration,
                        style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
