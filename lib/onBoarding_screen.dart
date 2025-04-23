import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as Math;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _pageAnimation;
  int _currentPage = 0;
  late AnimationController _fillAnimationController;
  late Animation<double> _fillAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pageAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutBack);
    _fillAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fillAnimation = CurvedAnimation(
      parent: _fillAnimationController,
      curve: Curves.easeInOut,
    );
    // Add a listener to properly update UI when animation completes
    _fillAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          // This will refresh the UI when animation completes
        });
      }
    });
  }

  void _resetState() {
    // Reset animation controllers
    _fillAnimationController.reset();
    _animationController.reset();
    // Reset state variables
    setState(() {
      _isAnimating = false;
      _currentPage = 0;
    });

    // Reset page controller
    _pageController.jumpToPage(0);
  }

  void _startFillAnimation() {
    setState(() => _isAnimating = true);
    _fillAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Bookmark Bazar",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.aBeeZee().fontFamily,
                  color: Color(0xff92760E),
                ),
              ),
            ),
            PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                  _animationController.reset();
                  _animationController.forward();
                });
              },
              children: [
                buildPageView(
                  image: "assets/read.jpg",
                  title: "Find Professional Trainer",
                  description:
                      "Connect with expert trainers who specialize in teaching and guiding young readers through their literary journey",
                ),
                buildPageView(
                  image: "assets/books.jpg",
                  title: "Browse Books",
                  description:
                      "Explore a vast collection of books, from classic literature to contemporary bestsellers",
                ),
                buildPageView(
                  image: "assets/reading.png",
                  title: "Increase your Knowledge",
                  description:
                      "Enhance your reading skills and expand your vocabulary with our comprehensive resources",
                ),
              ],
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.18,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 25 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Color(0xffC56C50)
                          : Color(0xffC56C50).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_currentPage == 0) {
                          // Skip
                        } else {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _currentPage == 0 ? "skip" : "back",
                        style: TextStyle(
                          fontSize: 14,
                          height: 0,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.aBeeZee().fontFamily,
                          color: Color(0xffC56C50),
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                          );
                        } else if (!_isAnimating) {
                          _startFillAnimation();
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: 40,
                        width: _isAnimating
                            ? 40
                            : _currentPage == 2
                                ? 120
                                : 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          color: _isAnimating
                              ? Color(0xffC56C50)
                              : Colors.transparent,
                          border:
                              Border.all(color: Color(0xffC56C50), width: 2),
                        ),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                            );
                          },
                          child: _isAnimating
                              ? SizedBox()
                              : _currentPage == 2
                                  ? Text(
                                      'Get Started',
                                      key: ValueKey('text'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 0,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily:
                                            GoogleFonts.aBeeZee().fontFamily,
                                        color: Color(0xffC56C50),
                                      ),
                                    )
                                  : Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      key: ValueKey('icon'),
                                      color: Color(0xffC56C50),
                                    ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // In the _OnboardingScreenState class, update the expanding circle animation:

            if (_isAnimating)
              Positioned(
                bottom: 20,
                right: 10,
                child: AnimatedBuilder(
                  animation: _fillAnimation,
                  builder: (context, child) {
                    final screenSize = MediaQuery.of(context).size;
                    // Calculate distance from button position to farthest screen corner
                    final distToTopLeft = Math.sqrt((screenSize.width - 10) *
                            (screenSize.width - 10) +
                        (screenSize.height - 20) * (screenSize.height - 20));
                    // Add a bit extra to ensure full coverage
                    final maxScale = distToTopLeft / 20 + 0.5;

                    return Transform.scale(
                      scale: _fillAnimation.value * maxScale,
                      alignment: Alignment.center,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xffC56C50),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ),
            AnimatedBuilder(
              animation: _fillAnimation,
              builder: (context, child) {
                // Only show welcome text when animation is truly complete
                // and we're in the animating state
                final showWelcome = _isAnimating &&
                    _fillAnimationController.status ==
                        AnimationStatus.completed;

                return Opacity(
                  opacity: showWelcome ? 1.0 : 0.0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Thank You',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.aBeeZee().fontFamily,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            if (_isAnimating) {
                              _resetState();
                            }
                          },
                          child: Text(
                            'Go Back',
                            key: ValueKey('Measurement'),
                            style: TextStyle(
                              fontSize: 14,
                              height: 0,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w600,
                              fontFamily: GoogleFonts.aBeeZee().fontFamily,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fillAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget buildPageView({
    required String image,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 60),
          Image.asset(image),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.aBeeZee().fontFamily,
              color: Color(0xffC56C50),
            ),
          ),
          SizedBox(height: 30),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 0,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.aBeeZee().fontFamily,
              color: Color(0xff92760E),
            ),
          ),
        ],
      ),
    );
  }
}
