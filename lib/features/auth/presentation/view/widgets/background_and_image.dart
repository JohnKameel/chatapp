import 'package:flutter/material.dart';

class BackgroundAndImage extends StatelessWidget {
  const BackgroundAndImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, 320),
            painter: TopWavePainter(),
          ),
          Positioned(
            top: 78,
            right: 70,
            left: 70,
            child: Image.asset(
              'assets/images/background.png',
              color: Colors.white,
              fit: BoxFit.cover,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the wave
class TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = const Color(0xFFBD9FE9);
    final path1 = Path();
    path1.lineTo(0, size.height - 80);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height - 30,
      size.width * 0.5,
      size.height - 60,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height - 90,
      size.width,
      size.height - 50,
    );
    path1.lineTo(size.width, 0);
    path1.close();
    canvas.drawPath(path1, paint1);

    final paint2 = Paint()..color = const Color(0xFFAD87E4);
    final path2 = Path();
    path2.lineTo(0, size.height - 100);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height - 60,
      size.width * 0.5,
      size.height - 90,
    );
    path2.quadraticBezierTo(
      size.width * 0.75,
      size.height - 120,
      size.width,
      size.height - 80,
    );
    path2.lineTo(size.width, 0);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
