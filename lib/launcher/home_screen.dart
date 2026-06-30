import 'package:flutter/material.dart';
import '../glass/liquid_glass.dart';
import '../models/installed_app.dart';
import '../services/app_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum HomePageType {
  apps,
  widgets,
}

class _HomeScreenState extends State<HomeScreen> {
  final AppService _appService = AppService();
  final PageController _pageController = PageController();

  List<InstalledApp> apps = [];
  List<InstalledApp> filteredApps = [];

  bool loading = true;
  bool controlCenterOpen = false;
  bool islandExpanded = false;

  int currentPage = 0;
  String query = '';

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    try {
      final result = await _appService.getInstalledApps();

      setState(() {
        apps = result;
        filteredApps = result;
        loading = false;
      });
    } catch (error) {
      setState(() {
        apps = [];
        filteredApps = [];
        loading = false;
      });
    }
  }

  void _searchApps(String value) {
    setState(() {
      query = value;

      if (value.trim().isEmpty) {
        filteredApps = apps;
      } else {
        filteredApps = apps
            .where(
              (app) => app.name.toLowerCase().contains(
                    value.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  Future<void> _openApp(InstalledApp app) async {
    await _appService.launchApp(app.packageName);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              _StatusBar(
                onControlCenterTap: () {
                  setState(() {
                    controlCenterOpen = true;
                  });
                },
              ),
              const SizedBox(height: 4),
              _DynamicIsland(
                expanded: islandExpanded,
                onTap: () {
                  setState(() {
                    islandExpanded = !islandExpanded;
                  });
                },
              ),
              const SizedBox(height: 18),
              _SearchBar(
                value: query,
                onChanged: _searchApps,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  children: [
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : _AppGrid(
                            apps: filteredApps,
                            onOpenApp: _openApp,
                          ),
                    const _WidgetsPage(),
                  ],
                ),
              ),
              _PageDots(currentPage: currentPage),
              const SizedBox(height: 10),
              _Dock(
                apps: apps,
                onOpenApp: _openApp,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          top: controlCenterOpen ? 0 : -MediaQuery.of(context).size.height,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height,
          child: _ControlCenter(
            onClose: () {
              setState(() {
                controlCenterOpen = false;
              });
            },
          ),
        ),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  final VoidCallback onControlCenterTap;

  const _StatusBar({
    required this.onControlCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
      child: Row(
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onControlCenterTap,
            child: Row(
              children: [
                const Icon(
                  Icons.signal_cellular_alt_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.wifi_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Container(
                  width: 28,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 19,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF58FFB6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
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

class _DynamicIsland extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;

  const _DynamicIsland({
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutBack,
        width: expanded ? MediaQuery.of(context).size.width - 44 : 122,
        height: expanded ? 78 : 32,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.96),
          borderRadius: BorderRadius.circular(expanded ? 28 : 99),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 26,
              offset: const Offset(0, 13),
            ),
          ],
        ),
        child: expanded
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF7A5CFF),
                      child: Icon(
                        Icons.music_note_rounded,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Liquid Waves',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'iOS 26 Launcher',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.graphic_eq_rounded,
                      color: Color(0xFF58FFB6),
                    ),
                  ],
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Color(0xFF42FFB0),
                  ),
                  SizedBox(width: 16),
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: Color(0xFF7A5CFF),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: LiquidGlass(
        radius: 24,
        blur: 18,
        opacity: 0.15,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: Colors.white70,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search apps...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.58),
                    ),
                  ),
                ),
              ),
              if (value.isNotEmpty)
                const Icon(
                  Icons.close_rounded,
                  color: Colors.white54,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppGrid extends StatelessWidget {
  final List<InstalledApp> apps;
  final ValueChanged<InstalledApp> onOpenApp;

  const _AppGrid({
    required this.apps,
    required this.onOpenApp,
  });

  @override
  Widget build(BuildContext context) {
    if (apps.isEmpty) {
      return Center(
        child: LiquidGlass(
          radius: 28,
          padding: const EdgeInsets.all(20),
          child: const Text(
            'No apps found',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      physics: const BouncingScrollPhysics(),
      itemCount: apps.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 14,
        childAspectRatio: 0.74,
      ),
      itemBuilder: (context, index) {
        final app = apps[index];

        return GestureDetector(
          onTap: () => onOpenApp(app),
          child: Column(
            children: [
              LiquidGlass(
                radius: 21,
                blur: 18,
                opacity: 0.13,
                padding: const EdgeInsets.all(9),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.35),
                    const Color(0xFF65F4FF).withOpacity(0.10),
                    const Color(0xFF8F5CFF).withOpacity(0.14),
                  ],
                ),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.memory(
                      app.iconBytes,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const Icon(
                          Icons.apps_rounded,
                          color: Colors.white,
                          size: 32,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                app.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black87,
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WidgetsPage extends StatelessWidget {
  const _WidgetsPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 18),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _GlassWidgetCard(
                  title: 'Weather',
                  subtitle: '24° Clear',
                  icon: Icons.wb_sunny_rounded,
                  color: Color(0xFFFFB34E),
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _GlassWidgetCard(
                  title: 'Battery',
                  subtitle: '85%',
                  icon: Icons.battery_full_rounded,
                  color: Color(0xFF58FFB6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LiquidGlass(
            radius: 32,
            blur: 28,
            opacity: 0.16,
            padding: const EdgeInsets.all(22),
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF9C7A).withOpacity(0.28),
                const Color(0xFF7A5CFF).withOpacity(0.22),
                const Color(0xFF56F7FF).withOpacity(0.20),
              ],
            ),
            child: const SizedBox(
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '09:41',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -3,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _GlassWidgetCard(
                  title: 'Music',
                  subtitle: 'Liquid Waves',
                  icon: Icons.music_note_rounded,
                  color: Color(0xFFFF4DA6),
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _GlassWidgetCard(
                  title: 'Focus',
                  subtitle: 'Personal',
                  icon: Icons.nights_stay_rounded,
                  color: Color(0xFF7A5CFF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassWidgetCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _GlassWidgetCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      radius: 30,
      blur: 26,
      opacity: 0.15,
      padding: const EdgeInsets.all(18),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0.28),
          Colors.white.withOpacity(0.08),
          const Color(0xFF55F7FF).withOpacity(0.12),
        ],
      ),
      child: SizedBox(
        height: 116,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.68),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int currentPage;

  const _PageDots({
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        2,
        (index) {
          final active = index == currentPage;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 20 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(99),
            ),
          );
        },
      ),
    );
  }
}

class _Dock extends StatelessWidget {
  final List<InstalledApp> apps;
  final ValueChanged<InstalledApp> onOpenApp;

  const _Dock({
    required this.apps,
    required this.onOpenApp,
  });

  @override
  Widget build(BuildContext context) {
    final dockApps = apps.take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LiquidGlass(
        radius: 34,
        blur: 32,
        opacity: 0.16,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: SizedBox(
          height: 66,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dockApps.isEmpty
                ? const [
                    Icon(Icons.phone_rounded, color: Colors.white, size: 32),
                    Icon(Icons.message_rounded, color: Colors.white, size: 32),
                    Icon(Icons.camera_alt_rounded, color: Colors.white, size: 32),
                    Icon(Icons.settings_rounded, color: Colors.white, size: 32),
                  ]
                : dockApps.map((app) {
                    return GestureDetector(
                      onTap: () => onOpenApp(app),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Image.memory(
                          app.iconBytes,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ControlCenter extends StatefulWidget {
  final VoidCallback onClose;

  const _ControlCenter({
    required this.onClose,
  });

  @override
  State<_ControlCenter> createState() => _ControlCenterState();
}

class _ControlCenterState extends State<_ControlCenter> {
  double brightness = 0.72;
  double volume = 0.45;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.18),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Control Center',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  GlassButton(
                    icon: Icons.close_rounded,
                    onTap: widget.onClose,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: LiquidGlass(
                      radius: 30,
                      blur: 32,
                      opacity: 0.17,
                      padding: const EdgeInsets.all(16),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          _ControlCircle(
                            icon: Icons.wifi_rounded,
                            color: Color(0xFF348BFF),
                          ),
                          _ControlCircle(
                            icon: Icons.bluetooth_rounded,
                            color: Color(0xFF348BFF),
                          ),
                          _ControlCircle(
                            icon: Icons.airplanemode_active_rounded,
                            color: Color(0xFFFF9E3D),
                          ),
                          _ControlCircle(
                            icon: Icons.signal_cellular_alt_rounded,
                            color: Color(0xFF58FFB6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: LiquidGlass(
                      radius: 30,
                      blur: 32,
                      opacity: 0.17,
                      padding: const EdgeInsets.all(18),
                      child: const SizedBox(
                        height: 154,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.music_note_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Liquid Waves',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'Now Playing',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _GlassSlider(
                      value: brightness,
                      icon: Icons.wb_sunny_rounded,
                      label: 'Brightness',
                      onChanged: (value) {
                        setState(() {
                          brightness = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _GlassSlider(
                      value: volume,
                      icon: Icons.volume_up_rounded,
                      label: 'Volume',
                      onChanged: (value) {
                        setState(() {
                          volume = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 120,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlCircle extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _ControlCircle({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.95),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 25,
      ),
    );
  }
}

class _GlassSlider extends StatelessWidget {
  final double value;
  final IconData icon;
  final String label;
  final ValueChanged<double> onChanged;

  const _GlassSlider({
    required this.value,
    required this.icon,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      radius: 30,
      blur: 30,
      opacity: 0.16,
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        height: 160,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: value,
                    child: Container(
                      width: 72,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.white.withOpacity(0.88),
                            const Color(0xFF68F6FF).withOpacity(0.72),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    child: Icon(
                      icon,
                      color: Colors.black87,
                      size: 24,
                    ),
                  ),
                  Positioned.fill(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 72,
                          thumbShape: SliderComponentShape.noThumb,
                          overlayShape: SliderComponentShape.noOverlay,
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                        ),
                        child: Slider(
                          value: value,
                          onChanged: onChanged,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.70),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
