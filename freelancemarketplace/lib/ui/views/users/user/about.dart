import 'package:flutter/material.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> showCoolAboutDialog(BuildContext context) async {
  final info = await PackageInfo.fromPlatform(); // 🚀 dynamic version
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'About',
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.white70, Colors.white38],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/logo.jpg'),
                  ).animate().scale(
                        delay: 100.ms,
                        duration: 300.ms,
                        curve: Curves.easeOutBack,
                      ),
                  const SizedBox(height: 20),
                  // Title
                  Text(
                    info.appName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 8),
                  // Version
                  Text(
                    'Version ${info.version}+${info.buildNumber}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    'Scale your professional workforce\nwith freelancers',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 24),
                  // Close button
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text('Close'),
                  ).animate().shake(
                        delay: 500.ms,
                        hz: 2,
                      ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
            scale: Tween(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
            ),
            child: child),
      );
    },
  );
}
