import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memo/core/utlis/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _masterController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _logoGlow;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineFade;
  late Animation<double> _lineWidth;
  late Animation<double> _dotFade;

  final List<_Particle> _particles = [];
  final Random _random = Random();

  static const _accent = Color(0xFFD4C5F9);
  static const _accentMid = Color(0xFFB8A4F0);

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    _generateParticles();

    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();

    _logoScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.0,
              end: 1.06,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
            weight: 60,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.06,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 40,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _masterController,
            curve: const Interval(0.0, 0.55),
          ),
        );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _logoGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _lineWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.45, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.5, 0.78, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _masterController,
            curve: const Interval(0.5, 0.82, curve: Curves.easeOutCubic),
          ),
        );

    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.7, 0.95, curve: Curves.easeOut),
      ),
    );

    _dotFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.88, 1.0, curve: Curves.easeOut),
      ),
    );

    _masterController.forward();
    _navigateNext();
  }

  void _generateParticles() {
    for (int i = 0; i < 25; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2.5 + 0.8,
          speed: _random.nextDouble() * 0.2 + 0.05,
          opacity: _random.nextDouble() * 0.45 + 0.08,
          phase: _random.nextDouble(),
        ),
      );
    }
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 4200));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRouter.kBottomNavView);
    }
  }

  @override
  void dispose() {
    _masterController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.25),
                radius: 1.3,
                colors: [
                  Color(0xFFEDE6FF),
                  Color(0xFFF3EFFE),
                  Color(0xFFFAF8FF),
                ],
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) {
              return Positioned(
                top: size.height * 0.15,
                left: size.width * 0.05,
                right: size.width * 0.05,
                child: Container(
                  height: size.height * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFD4C5F9,
                        ).withOpacity(0.25 + 0.12 * _pulseController.value),
                        blurRadius: 100,
                        spreadRadius: 30,
                      ),
                      BoxShadow(
                        color: const Color(
                          0xFFB8A4F0,
                        ).withOpacity(0.12 + 0.08 * _pulseController.value),
                        blurRadius: 160,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _particleController,
            builder: (_, __) {
              return CustomPaint(
                size: size,
                painter: _ParticlePainter(
                  particles: _particles,
                  progress: _particleController.value,
                ),
              );
            },
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _masterController,
                    _pulseController,
                  ]),
                  builder: (_, __) {
                    final glowOpacity = _logoGlow.value;
                    final pulse = _pulseController.value;
                    return FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (glowOpacity > 0)
                              Container(
                                width: size.width * 0.58 + (8 * pulse),
                                height: size.width * 0.58 + (8 * pulse),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _accent.withOpacity(
                                        0.28 * glowOpacity,
                                      ),
                                      blurRadius: 60,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              ),

                            SizedBox(
                              width: size.width * 1,
                              height: size.width * 1,
                              child: Image.asset(
                                'assets/logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                AnimatedBuilder(
                  animation: _lineWidth,
                  builder: (_, __) {
                    return Opacity(
                      opacity: _lineWidth.value,
                      child: Container(
                        width: 50 * _lineWidth.value,
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              _accent,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (_, child) {
                        final shimmerX = (_shimmerController.value * 3 - 1);
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment(shimmerX - 1, 0),
                              end: Alignment(shimmerX, 0),
                              colors: const [
                                Color(0xFFB8A4F0),
                                Color(0xFFD4C5F9),
                                Color(0xFFEDE6FF),
                                Color(0xFFD4C5F9),
                                Color(0xFFB8A4F0),
                              ],
                              stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                            ).createShader(bounds);
                          },
                          child: child!,
                        );
                      },
                      child: const Text(
                        'MEMOIR',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                FadeTransition(
                  opacity: _taglineFade,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _accent.withOpacity(0.45),
                        width: 0.7,
                      ),
                      borderRadius: BorderRadius.circular(2),
                      color: _accent.withOpacity(0.06),
                    ),
                    child: const Text(
                      'CAPTURE EVERY MOMENT',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                        color: _accentMid,
                        letterSpacing: 3.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 5. Loading dots
          Positioned(
            bottom: 55,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _dotFade,
              child: Center(
                child: AnimatedBuilder(
                  animation: _particleController,
                  builder: (_, __) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        final phase =
                            (_particleController.value * 3 - i).abs() % 1;
                        final opacity = (sin(phase * pi)).clamp(0.15, 1.0);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == 1 ? 20 : 6,
                          height: 2,
                          decoration: BoxDecoration(
                            color: _accent.withOpacity(opacity.toDouble()),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final double phase;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.phase,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.y - progress * p.speed + p.phase) % 1.0;
      final x = p.x + sin(progress * 2 * pi + p.phase * 2 * pi) * 0.018;
      final opacity =
          p.opacity * (0.5 + 0.5 * sin(progress * 2 * pi + p.phase * pi));

      final paint = Paint()
        ..color = const Color(0xFFD4C5F9).withOpacity(opacity.clamp(0, 1))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        p.size * 0.7,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}
