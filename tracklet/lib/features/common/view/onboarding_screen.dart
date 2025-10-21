import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              // Gas Cylinder Illustration
              _buildGasCylinderIllustration(),
              const SizedBox(height: 48),
              // Title
              const Text(
                'Track All Your Orders',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Subtitle
              const Text(
                'Easily manage and monitor every gas order in one place.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Get Started Button
              CustomButton(
                text: 'Get Started',
                onPressed: () {
                  // Simple navigation for UI testing
                  Navigator.pushReplacementNamed(
                    context,
                    '/language-selection',
                  );
                },
                width: double.infinity,
                backgroundColor: const Color(0xFF1A2B4C),
                textColor: Colors.white,
                height: 50,
                borderRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGasCylinderIllustration() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gas Cylinder
          Container(
            width: 120,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF4ECDC4), // Light teal
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top valve
                Container(
                  width: 80,
                  height: 30,
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                // Main cylinder body
                Expanded(
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                // Base
                Container(
                  width: 80,
                  height: 25,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3BA99F), // Darker teal
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
          // Leaves
          Positioned(
            right: 30,
            bottom: 30,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [_buildLeaf(), const SizedBox(width: 6), _buildLeaf()],
            ),
          ),
          // Workers
          Positioned(left: 20, bottom: 20, child: _buildWorker(isLeft: true)),
          Positioned(right: 20, bottom: 20, child: _buildWorker(isLeft: false)),
        ],
      ),
    );
  }

  Widget _buildLeaf() {
    return Container(
      width: 16,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50), // Green
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomPaint(painter: LeafPainter()),
    );
  }

  Widget _buildWorker({required bool isLeft}) {
    return SizedBox(
      width: 40,
      height: 60,
      child: Stack(
        children: [
          // Body
          Positioned(
            bottom: 0,
            left: isLeft ? 5 : 0,
            child: Container(
              width: 30,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0), // Light grey shirt
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          // Head
          Positioned(
            top: 0,
            left: isLeft ? 8 : 3,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFFFDBB3), // Skin color
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Hard hat
          Positioned(
            top: -2,
            left: isLeft ? 6 : 1,
            child: Container(
              width: 28,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.3,
      size.width * 0.6,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.9,
      size.width * 0.2,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.3,
      size.width * 0.5,
      0,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
