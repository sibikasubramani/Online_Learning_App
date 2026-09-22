import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_learning_application/data/mock_data.dart';
import 'package:online_learning_application/providers/course_provider.dart';
import 'package:online_learning_application/utils/appcolor.dart';
import 'package:online_learning_application/views/notification_screen.dart';
import 'package:online_learning_application/views/profile_pages.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq         = MediaQuery.of(context);
    final sw         = mq.size.width;
    final sh         = mq.size.height;
    final outerPad   = sw * 0.040;
    final cardGap    = sh * 0.014;

    final courseProvider = Provider.of<CourseProvider>(context);
    final user = MockData.mockUser;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Header with Gradient
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: sh * 0.18,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.darkPurple, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 48), // Balance for back button if needed, or just padding
                            const Text(
                              'My Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            // IconButton(
                            //   icon: const Icon(Icons.settings_outlined, color: Colors.white),
                            //   onPressed: () {},
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Avatar positioned halfway out of the header
                Positioned(
                  bottom: -sw * 0.12,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.bg, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: sw * 0.14,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_rounded,
                        size: sw * 0.16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sw * 0.15),

            // User Info
            Text(
              user['name']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              user['email']!,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textMid,
              ),
            ),
            SizedBox(height: sh * 0.03),

            // User Stats
            Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('Enrolled', '${courseProvider.purchasedCourses.length}', Icons.book_rounded, sw, imageAsset: 'assests/images/open-enrollment.png'),
                  _buildStatCard('Completed', '0', Icons.workspace_premium_rounded, sw, imageAsset: 'assests/images/course_completed.png'),
                  _buildStatCard('Hours Spent', '12h', Icons.timer_rounded, sw, imageAsset: 'assests/images/time_spent.png'),
                ],
              ),
            ),
            SizedBox(height: sh * 0.04),

            // Settings Options
            Padding(
              padding: EdgeInsets.symmetric(horizontal: outerPad),
              child: Column(
                children: [
                  _buildProfileTile(Icons.person_outline_rounded, 'Edit Profile', cardGap, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                  }),
                  _buildProfileTile(Icons.notifications_none_rounded, 'Notifications', cardGap, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                  }),
                  _buildProfileTile(Icons.help_outline_rounded, 'Help & Support', cardGap, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()));
                  }),
                  _buildProfileTile(Icons.lock_outline_rounded, 'Privacy Policy', cardGap, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
                  }),
                  SizedBox(height: cardGap * 2),

                  // Logout
                  Container(
                    margin: EdgeInsets.only(bottom: cardGap * 2),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        onTap: () {},
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.logout_rounded, color: AppColors.error),
                        ),
                        title: const Text(
                          'Log Out',
                          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, double sw, {String? imageAsset}) {
    return Container(
      width: sw * 0.29,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: imageAsset != null 
                ? Image.asset(imageAsset, width: 24, height: 24, fit: BoxFit.contain)
                : Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMid,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, double cardGap, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: cardGap * 1.2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textDark),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
          ),
        ),
      ),
    );
  }
}
