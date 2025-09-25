import 'package:flutter/material.dart';
import 'pages/homePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _kontrolBackground;
  late Animation<double> _animasiBackground;

  late AnimationController _kontrolLogo;
  late Animation<Offset> _animasiLogo;

  late AnimationController _kontrolText;
  late Animation<Offset> _animasiTextSlide;
  late Animation<double> _animasiTextScale;

  late AnimationController _kontrolTeksMuncul;
  late Animation<double> _animasiTeksBesarScale;
  late Animation<Offset> _animasiTeksNaik;

  bool _showTeksBesar = false;

  @override
  void initState() {
    super.initState();

    _kontrolBackground = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
    );
    _animasiBackground = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _kontrolBackground, curve: Curves.easeOut),
    );

    _kontrolLogo = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
    );
    _animasiLogo = Tween<Offset>(
      begin: Offset(-3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _kontrolLogo, curve: Curves.easeOut));

    _kontrolText = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
    );
    _animasiTextSlide = Tween<Offset>(
      begin: Offset(-3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _kontrolText, curve: Curves.easeOut));
    _animasiTextScale = Tween<double>(
      begin: 0.1,
      end: 0.1,
    ).animate(_kontrolText);

    _kontrolTeksMuncul = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animasiTeksBesarScale = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: _kontrolTeksMuncul, curve: Curves.easeOutBack),
    );

    _animasiTeksNaik = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1.8))
        .animate(
          CurvedAnimation(parent: _kontrolTeksMuncul, curve: Curves.easeOut),
        );

    _kontrolBackground.forward();

    _kontrolBackground.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _kontrolLogo.forward();
        _kontrolText.forward();
      }
    });

    _kontrolText.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _showTeksBesar = true;
          });
          _kontrolTeksMuncul.forward();
        });
      }
    });

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _kontrolBackground.dispose();
    _kontrolLogo.dispose();
    _kontrolText.dispose();
    _kontrolTeksMuncul.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHigh = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animasiBackground,
            builder: (context, child) {
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: _animasiBackground.value * screenHigh,
                child: Container(color: Color(0xFF26424C)),
              );
            },
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SlideTransition(
                  position: _animasiTextSlide,
                  child: ScaleTransition(
                    scale: _animasiTextScale,
                    child: Text(
                      'Siap Bayar!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (_showTeksBesar)
                  SlideTransition(
                    position: _animasiTeksNaik,
                    child: ScaleTransition(
                      scale: _animasiTeksBesarScale,
                      child: Hero(
                        tag: 'teksSiapBayar',
                        child: Text(
                          'Siap Bayar!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                SlideTransition(
                  position: _animasiLogo,
                  child: Image.asset(
                    'assets/logosplash.png',
                    height: 200,
                    width: 200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
