import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BSIApp());
}

class BSIApp extends StatelessWidget {
  const BSIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BSI Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF008D6E), // BSI Green
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF008D6E),
          unselectedItemColor: Color(0xFF9CA3AF),
          elevation: 8,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ==================== SPLASH SCREEN ====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2600), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
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
      backgroundColor: const Color(0xFF008D6E),
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(
                painter: IslamicPatternPainter(),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo BSI dengan efek rotasi
                        Transform.rotate(
                          angle: _rotateAnimation.value,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: CustomPaint(
                                  painter: BSILogoPainter(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'BSI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'Bank Syariah Indonesia',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 48),
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2.5,
                          ),
                        ),
                      ],
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

// ==================== HOME SCREEN ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showBalance = true;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.qr_code_scanner_rounded, 'label': 'QRIS', 'color': 0xFF008D6E, 'gradient': [0xFF008D6E, 0xFF00A886]},
    {'icon': Icons.send_rounded, 'label': 'Transfer', 'color': 0xFF008D6E, 'gradient': [0xFF008D6E, 0xFF00A886]},
    {'icon': Icons.receipt_rounded, 'label': 'Bayar', 'color': 0xFF008D6E, 'gradient': [0xFF008D6E, 0xFF00A886]},
    {'icon': Icons.account_balance_wallet_rounded, 'label': 'Top Up', 'color': 0xFF008D6E, 'gradient': [0xFF008D6E, 0xFF00A886]},
    {'icon': Icons.phone_android_rounded, 'label': 'Pulsa', 'color': 0xFF008D6E, 'gradient': [0xFF008D6E, 0xFF00A886]},
    {'icon': Icons.electric_bolt_rounded, 'label': 'Listrik', 'color': 0xFF008D6E, 'gradient': [0xFF008D6E, 0xFF00A886]},
    {'icon': Icons.mosque_rounded, 'label': 'Zakat', 'color': 0xFF008D6E, 'gradient': [0xFF008D6E, 0xFF00A886]},
    {'icon': Icons.handshake_rounded, 'label': 'Qurban', 'color': 0xFF008D6E, 'gradient': [0xFF008D6E, 0xFF00A886]},
  ];

  final List<Map<String, dynamic>> _promoCards = [
    {
      'title': 'Haji & Umrah',
      'subtitle': 'Tabungan berencana',
      'icon': '🕋',
      'bgColor': 0xFFE8F5E9,
      'iconColor': 0xFF008D6E,
      'gradient': [0xFF008D6E, 0xFF00A886],
    },
    {
      'title': 'BSI Poin',
      'subtitle': 'Tukarkan hadiah',
      'icon': '🎁',
      'bgColor': 0xFFFFF8E7,
      'iconColor': 0xFFFFB347,
      'gradient': [0xFFFFB347, 0xFFFFA01A],
    },
    {
      'title': 'Deposito Syariah',
      'subtitle': 'Bagi hasil kompetitif',
      'icon': '📈',
      'bgColor': 0xFFE3F2FD,
      'iconColor': 0xFF1976D2,
      'gradient': [0xFF1976D2, 0xFF42A5F5],
    },
  ];

  final List<Map<String, dynamic>> _transactions = [
    {
      'merchant': 'QRIS - Warung Makan Berkah',
      'date': 'Hari ini, 12:30',
      'amount': '- Rp 35.000',
      'isIncome': false,
      'icon': Icons.qr_code_scanner_rounded,
      'bgColor': 0xFFE8F5E9,
      'iconColor': 0xFF008D6E,
    },
    {
      'merchant': 'Transfer - ZAKAT FITRAH',
      'date': 'Hari ini, 09:15',
      'amount': '- Rp 45.000',
      'isIncome': false,
      'icon': Icons.mosque_rounded,
      'bgColor': 0xFFE8F5E9,
      'iconColor': 0xFF008D6E,
    },
    {
      'merchant': 'Top Up GoPay',
      'date': 'Kemarin, 18:45',
      'amount': '- Rp 100.000',
      'isIncome': false,
      'icon': Icons.account_balance_wallet_rounded,
      'bgColor': 0xFFFFF8E7,
      'iconColor': 0xFFFFB347,
    },
    {
      'merchant': 'Gaji Bulanan',
      'date': '25 Mar 2026',
      'amount': '+ Rp 12.500.000',
      'isIncome': true,
      'icon': Icons.attach_money_rounded,
      'bgColor': 0xFFE8F5E9,
      'iconColor': 0xFF008D6E,
    },
    {
      'merchant': 'Pembayaran Listrik',
      'date': '24 Mar 2026',
      'amount': '- Rp 350.000',
      'isIncome': false,
      'icon': Icons.electric_bolt_rounded,
      'bgColor': 0xFFFFF8E7,
      'iconColor': 0xFFFFB347,
    },
  ];

  final List<Map<String, dynamic>> _worshipFeatures = [
    {'icon': Icons.mosque_rounded, 'label': 'Jadwal Sholat', 'time': '12:15', 'color': 0xFF008D6E},
    {'icon': Icons.book_rounded, 'label': 'Al-Qur\'an', 'verse': 'Ar-Rahman: 33', 'color': 0xFF008D6E},
    {'icon': Icons.calculate_rounded, 'label': 'Kalkulator Zakat', 'value': '2.5%', 'color': 0xFF008D6E},
    {'icon': Icons.help_center_rounded, 'label': 'Konsultasi Syariah', 'color': 0xFF008D6E},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF008D6E),
                      Color(0xFF00A886),
                      Color(0xFFF5F7FA),
                    ],
                    stops: [0.0, 0.5, 0.9],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: CustomPaint(
                                        painter: BSILogoPainter(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Assalamu\'alaikum,',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Ahmad Fauzan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: Opacity(
                                opacity: _fadeAnimation.value,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 20,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total Saldo',
                                            style: TextStyle(
                                              color: Color(0xFF6B7280),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _showBalance = !_showBalance;
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF3F4F6),
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              child: Icon(
                                                _showBalance
                                                    ? Icons.visibility_rounded
                                                    : Icons.visibility_off_rounded,
                                                size: 18,
                                                color: const Color(0xFF6B7280),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            _showBalance ? 'Rp 32.750.000' : '••••••••',
                                            style: const TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF008D6E),
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            'IDR',
                                            style: TextStyle(
                                              color: Color(0xFF9CA3AF),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      const Divider(height: 1),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          _buildBalanceAction(
                                            icon: Icons.download_rounded,
                                            label: 'Top Up',
                                            color: const Color(0xFF008D6E),
                                          ),
                                          _buildBalanceAction(
                                            icon: Icons.upload_rounded,
                                            label: 'Tarik',
                                            color: const Color(0xFF008D6E),
                                          ),
                                          _buildBalanceAction(
                                            icon: Icons.qr_code_scanner_rounded,
                                            label: 'QRIS',
                                            color: const Color(0xFFFFB347),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Layanan Cepat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: _quickActions.length,
                      itemBuilder: (context, index) {
                        final action = _quickActions[index];
                        return _buildQuickAction(
                          icon: action['icon'],
                          label: action['label'],
                          gradient: action['gradient'],
                          index: index,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Fitur Ibadah
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🕌 Fitur Ibadah',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _worshipFeatures.length,
                        itemBuilder: (context, index) {
                          final feature = _worshipFeatures[index];
                          return _buildWorshipCard(feature);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Promo Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '✨ Promo BSI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.3,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          color: Color(0xFF008D6E),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _promoCards.length,
                  itemBuilder: (context, index) {
                    final promo = _promoCards[index];
                    return _buildPromoCard(promo);
                  },
                ),
              ),
              const SizedBox(height: 28),
              // Transaction History
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '📋 Transaksi Terbaru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.3,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          color: Color(0xFF008D6E),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return _buildTransactionItem(transaction);
                },
              ),
              const SizedBox(height: 80),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            HapticFeedback.lightImpact();
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFF008D6E),
          unselectedItemColor: const Color(0xFF9CA3AF),
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_outlined),
              activeIcon: Icon(Icons.qr_code_scanner_rounded),
              label: 'QRIS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mosque_outlined),
              activeIcon: Icon(Icons.mosque_rounded),
              label: 'Ibadah',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceAction({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required List<int> gradient,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fitur $label akan segera hadir'),
            duration: const Duration(milliseconds: 800),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF008D6E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(12),
          ),
        );
      },
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(gradient[0]),
                        Color(gradient[1]),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(gradient[0]).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorshipCard(Map<String, dynamic> feature) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF008D6E).withOpacity(0.1),
            const Color(0xFF00A886).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF008D6E).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(feature['color']).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature['icon'],
              color: Color(feature['color']),
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feature['label'],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF1F2937),
            ),
          ),
          if (feature.containsKey('time'))
            Text(
              feature['time'],
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
          if (feature.containsKey('verse'))
            Text(
              feature['verse'],
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF008D6E),
                fontWeight: FontWeight.w500,
              ),
            ),
          if (feature.containsKey('value'))
            Text(
              feature['value'],
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF008D6E),
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPromoCard(Map<String, dynamic> promo) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(promo['bgColor']),
            Color(promo['bgColor']).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(promo['iconColor']),
                  Color(promo['iconColor']).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Color(promo['iconColor']).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                promo['icon'],
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promo['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(promo['iconColor']),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  promo['subtitle'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Color(promo['iconColor']).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.chevron_right_rounded,
              color: Color(promo['iconColor']),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 400),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: Opacity(
              opacity: value,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(transaction['bgColor']),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        transaction['icon'],
                        color: Color(transaction['iconColor']),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction['merchant'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaction['date'],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      transaction['amount'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: transaction['isIncome']
                            ? const Color(0xFF008D6E)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==================== CUSTOM PAINTER FOR BSI LOGO ====================
class BSILogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF008D6E)
      ..style = PaintingStyle.fill;

    final Path path = Path();
    
    // Bintang segi delapan (simbol Islami)
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width * 0.65, size.height * 0.35);
    path.lineTo(size.width, size.height * 0.35);
    path.lineTo(size.width * 0.75, size.height * 0.6);
    path.lineTo(size.width * 0.85, size.height);
    path.lineTo(size.width / 2, size.height * 0.75);
    path.lineTo(size.width * 0.15, size.height);
    path.lineTo(size.width * 0.25, size.height * 0.6);
    path.lineTo(0, size.height * 0.35);
    path.lineTo(size.width * 0.35, size.height * 0.35);
    path.close();

    canvas.drawPath(path, paint);
    
    // Lingkaran tengah
    final paintCircle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.2,
      paintCircle,
    );
    
    // Huruf BSI di tengah
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'BSI',
        style: TextStyle(
          color: Color(0xFF008D6E),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== ISLAMIC PATTERN PAINTER ====================
class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const int count = 8;
    final double radius = 40;
    
    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * 3.14159 / count);
      final x = size.width / 2 + radius * cos(angle);
      final y = size.height / 2 + radius * sin(angle);
      
      canvas.drawCircle(Offset(x, y), 5, paint);
    }
    
    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * 3.14159 / count);
      final x1 = size.width / 2 + radius * cos(angle);
      final y1 = size.height / 2 + radius * sin(angle);
      final angle2 = ((i + 1) * 2 * 3.14159 / count);
      final x2 = size.width / 2 + radius * cos(angle2);
      final y2 = size.height / 2 + radius * sin(angle2);
      
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}