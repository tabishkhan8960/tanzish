import 'package:flutter/material.dart';

class MobileEmulatorWrapper extends StatelessWidget {
  const MobileEmulatorWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If the screen is already mobile-sized, just return the child.
        if (constraints.maxWidth <= 600) {
          return child;
        }

        // Otherwise, wrap it in a centered box with a mobile phone aspect ratio/width.
        return Container(
          color: const Color(0xFFE5E5E5), // Light gray background for the letterboxing
          child: Center(
            child: ClipRect(
              child: Container(
                width: 414, // Max width of a typical large phone
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
