import 'package:bookstore/onBoarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _bookmarkSlideAnimation;
  late Animation<double> _bazarSlideAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _imageScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.6, curve: Curves.elasticInOut),
    ));

    _bookmarkSlideAnimation = Tween<double>(
      begin: -200.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.6, curve: Curves.elasticInOut),
    ));

    _bazarSlideAnimation = Tween<double>(
      begin: 200.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.6, curve: Curves.elasticInOut),
    ));

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.6,
        1.0,
        curve: Curves.easeInOut,
      ),
    ));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
        FadeRouteBuilder(page: const OnboardingScreen()),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: BackgroundPainter(
              progress: _backgroundAnimation.value,
              originalColor: Color(0xffFFE7C9),
              targetColor: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.16),
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _imageScaleAnimation,
                    child: Image.asset('assets/splash.png'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _bookmarkSlideAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_bookmarkSlideAnimation.value, 0),
                            child: Text(
                              "Bookmark ",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.aBeeZee().fontFamily,
                                color: Color(0xff92760E),
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _bazarSlideAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_bazarSlideAnimation.value, 0),
                            child: Text(
                              "Bazar",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.aBeeZee().fontFamily,
                                color: Color(0xff92760E),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double progress;
  final Color originalColor;
  final Color targetColor;

  BackgroundPainter({
    required this.progress,
    required this.originalColor,
    required this.targetColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(originalColor, BlendMode.src);

    if (progress > 0) {
      final center = Offset(size.width / 2, size.height * 0.16 + 160);
      final radius = (size.width * 0.7) * progress;

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            targetColor,
            targetColor.withValues(alpha: 0.9),
            originalColor,
          ],
          stops: [0.0, 0.8, 1.0],
        ).createShader(Rect.fromCircle(
          center: center,
          radius: radius,
        ))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class FadeRouteBuilder extends PageRouteBuilder {
  final Widget page;

  FadeRouteBuilder({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 500),
        );
}
