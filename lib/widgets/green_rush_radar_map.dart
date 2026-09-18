import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/ecore.dart';
import '../theme/app_theme.dart';

/// Neo-Brutalist GreenRush Interactive Radar Map.
/// Displays an animated tactical radar map with realistic campus terrain,
/// interactive Ecore action hubs, pulsing user location, and animated sweep line.
/// Never goes blank even when Google Maps API key is missing or offline.
class GreenRushRadarMap extends StatefulWidget {
  final List<Ecore> ecores;
  final LatLng? userLocation;
  final Ecore? selectedEcore;
  final Function(Ecore ecore)? onEcoreTap;
  final bool isCompact;
  final VoidCallback? onOpenFullMap;

  const GreenRushRadarMap({
    Key? key,
    required this.ecores,
    this.userLocation,
    this.selectedEcore,
    this.onEcoreTap,
    this.isCompact = false,
    this.onOpenFullMap,
  }) : super(key: key);

  @override
  State<GreenRushRadarMap> createState() => _GreenRushRadarMapState();
}

class _GreenRushRadarMapState extends State<GreenRushRadarMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _sweepController;
  bool _showGoogleMap = true;
  MapType _currentMapType = MapType.normal;
  GoogleMapController? _googleMapController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _sweepController.dispose();
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showGoogleMap) {
      return _buildGoogleMapView();
    }
    return _buildTacticalRadarView();
  }

  Widget _buildGoogleMapView() {
    final pos = widget.userLocation ?? const LatLng(18.5204, 73.8567);
    final markers = <Marker>{};

    markers.add(
      Marker(
        markerId: const MarkerId('user_loc'),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'Your Campus Location', snippet: 'Green Yuva Active'),
      ),
    );

    for (final ecore in widget.ecores) {
      markers.add(
        Marker(
          markerId: MarkerId('ecore_${ecore.id}'),
          position: LatLng(ecore.latitude, ecore.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            ecore.isConquered ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueOrange,
          ),
          infoWindow: InfoWindow(
            title: ecore.name,
            snippet: '${ecore.missions.length} Missions • ${ecore.totalPoints} Karma',
            onTap: () => widget.onEcoreTap?.call(ecore),
          ),
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (ctrl) => _googleMapController = ctrl,
          initialCameraPosition: CameraPosition(target: pos, zoom: 16.5),
          mapType: _currentMapType,
          markers: markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: true,
          buildingsEnabled: true,
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildMapModeToggle(),
              const SizedBox(height: 6),
              _buildSatelliteToggle(),
              const SizedBox(height: 6),
              _buildCenterGpsButton(pos),
              const SizedBox(height: 6),
              _buildAllIndiaButton(),
              const SizedBox(height: 6),
              _buildOpenInMapsButton(pos),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSatelliteToggle() {
    final isSatellite = _currentMapType == MapType.hybrid;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentMapType = isSatellite ? MapType.normal : MapType.hybrid;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSatellite ? AppColors.electricMint : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.solidBlack, width: 1.8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.solidBlack,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSatellite ? Icons.map_rounded : Icons.satellite_alt_rounded,
              size: 13,
              color: AppColors.solidBlack,
            ),
            const SizedBox(width: 4),
            Text(
              isSatellite ? 'Street Map' : 'Satellite',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.solidBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapModeToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showGoogleMap = !_showGoogleMap;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.butterYellow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.solidBlack, width: 1.8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.solidBlack,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _showGoogleMap ? Icons.radar_rounded : Icons.map_rounded,
              size: 13,
              color: AppColors.solidBlack,
            ),
            const SizedBox(width: 4),
            Text(
              _showGoogleMap ? 'Tactical Radar' : 'Satellite / Maps',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.solidBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterGpsButton(LatLng pos) {
    return GestureDetector(
      onTap: () {
        _googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: pos, zoom: 17.0),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.softSky,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.solidBlack, width: 1.8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.solidBlack,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.my_location_rounded, size: 13, color: AppColors.solidBlack),
            const SizedBox(width: 4),
            Text(
              'My Campus',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.solidBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllIndiaButton() {
    return GestureDetector(
      onTap: () {
        _googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(target: LatLng(21.5, 78.9629), zoom: 4.8),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.paperCream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.solidBlack, width: 1.8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.solidBlack,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.public_rounded, size: 13, color: AppColors.solidBlack),
            const SizedBox(width: 4),
            Text(
              'All India',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.solidBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenInMapsButton(LatLng pos) {
    return GestureDetector(
      onTap: () async {
        final url = 'https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}';
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.dustyCoral,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.solidBlack, width: 1.8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.solidBlack,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.open_in_new_rounded, size: 13, color: AppColors.solidBlack),
            const SizedBox(width: 4),
            Text(
              'Live Street View',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.solidBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTacticalRadarView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          children: [
            // Base Radar Canvas (Terrain, Grid, River, Concentric Rings, Radar Sweep)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _sweepController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _TacticalRadarPainter(
                      sweepAngle: _sweepController.value * 2 * math.pi,
                      isCompact: widget.isCompact,
                    ),
                  );
                },
              ),
            ),

            // Interactive Ecore Pins
            ...widget.ecores.asMap().entries.map((entry) {
              final idx = entry.key;
              final ecore = entry.value;

              // Normalized pin coordinates across canvas
              final pinOffsets = [
                const Offset(0.24, 0.32), // PCCOE Green Hub
                const Offset(0.68, 0.28), // VIT Solar
                const Offset(0.42, 0.72), // COEP Hydro
                const Offset(0.78, 0.65), // PICT Tech Core
                const Offset(0.22, 0.76), // MIT-WPU Eco
                const Offset(0.55, 0.40), // VIIT Clean Stream
                const Offset(0.82, 0.38), // BITS Renewable
                const Offset(0.35, 0.20), // VIT Vellore Air
              ];

              final offsetRatio = pinOffsets[idx % pinOffsets.length];
              final dx = offsetRatio.dx * width;
              final dy = offsetRatio.dy * height;

              final isSelected = widget.selectedEcore?.id == ecore.id;

              return Positioned(
                left: dx - (widget.isCompact ? 36 : 46),
                top: dy - (widget.isCompact ? 28 : 34),
                child: GestureDetector(
                  onTap: () {
                    if (widget.onEcoreTap != null) {
                      widget.onEcoreTap!(ecore);
                    } else if (widget.onOpenFullMap != null) {
                      widget.onOpenFullMap!();
                    }
                  },
                  child: _buildEcorePinWidget(ecore, isSelected),
                ),
              );
            }).toList(),

            // User GPS Location Pin (Center-slanted)
            Positioned(
              left: (width * 0.48) - 18,
              top: (height * 0.48) - 18,
              child: _buildUserLocationPin(),
            ),

            // Top-Right Controls (Toggle & Zoom hints)
            if (!widget.isCompact)
              Positioned(
                top: 12,
                right: 12,
                child: _buildMapModeToggle(),
              ),

            // Bottom Radar Info Pill (Full map mode)
            if (!widget.isCompact)
              Positioned(
                bottom: 160,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.solidBlack, width: 1.4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.leafGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Live Climate Radar • 8 Hubs Active',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.solidBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildUserLocationPin() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0066FF).withValues(alpha: 0.25),
            border: Border.all(color: const Color(0xFF0066FF), width: 1.5),
          ),
          child: Center(
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0066FF),
                border: Border.all(color: Colors.white, width: 2.2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 1.5),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.solidBlack,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'YOU (GPS)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEcorePinWidget(Ecore ecore, bool isSelected) {
    final pinColor = ecore.isConquered ? AppColors.electricMint : AppColors.butterYellow;
    final icon = ecore.isConquered ? Icons.eco_rounded : Icons.bolt_rounded;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 8 : 6,
            vertical: isSelected ? 4 : 3,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.dustyCoral : pinColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.solidBlack,
              width: isSelected ? 2.0 : 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.solidBlack,
                offset: Offset(1.5, 2.0),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: AppColors.solidBlack),
              const SizedBox(width: 3),
              Text(
                ecore.name.split(' ').first,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.solidBlack,
                ),
              ),
            ],
          ),
        ),
        // Pin pointer triangle
        CustomPaint(
          size: const Size(10, 6),
          painter: _TrianglePainter(
            color: isSelected ? AppColors.dustyCoral : pinColor,
            borderColor: AppColors.solidBlack,
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  _TrianglePainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Canvas Painter for Tactical Neo-Brutalist Radar Map
class _TacticalRadarPainter extends CustomPainter {
  final double sweepAngle;
  final bool isCompact;

  _TacticalRadarPainter({
    required this.sweepAngle,
    required this.isCompact,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.48, size.height * 0.48);

    // 1. Base Land Background (Soft Carto Warm Sage)
    final bgPaint = Paint()..color = const Color(0xFFEAF1EB);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Soft Green Ecological Zones (Parks / Reserves)
    final parkPaint = Paint()
      ..color = const Color(0xFFD3E7D5)
      ..style = PaintingStyle.fill;

    // North-West Green Reserve
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.08, size.height * 0.12, size.width * 0.28, size.height * 0.32),
        const Radius.circular(16),
      ),
      parkPaint,
    );

    // South-East Green Campus Belt
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.60, size.height * 0.55, size.width * 0.32, size.height * 0.35),
        const Radius.circular(20),
      ),
      parkPaint,
    );

    // 3. Water Body / River Bend (Mutha River curve)
    final riverPaint = Paint()
      ..color = const Color(0xFFC3E0FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isCompact ? 16 : 24
      ..strokeCap = StrokeCap.round;

    final riverPath = Path()
      ..moveTo(0, size.height * 0.35)
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.25,
        size.width * 0.55,
        size.height * 0.70,
        size.width,
        size.height * 0.60,
      );
    canvas.drawPath(riverPath, riverPaint);

    // River subtle border
    final riverBorder = Paint()
      ..color = const Color(0xFF90C2EE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(riverPath, riverBorder);

    // 4. Street Grid & Campus Transit Roads
    final roadPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isCompact ? 3.5 : 5.0;

    final roadBorder = Paint()
      ..color = const Color(0xFFCAD7CE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Horizontal Primary Arteries
    for (double dy in [0.22, 0.48, 0.75]) {
      final y = size.height * dy;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadBorder);
    }

    // Vertical Arteries
    for (double dx in [0.25, 0.50, 0.78]) {
      final x = size.width * dx;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadBorder);
    }

    // Diagonal Campus Avenue
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.8),
      Offset(size.width * 0.9, size.height * 0.2),
      roadPaint,
    );

    // 5. Tactical Concentric Radar Rings
    final ringPaint = Paint()
      ..color = const Color(0xFF2E7D32).withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final maxRadius = math.min(size.width, size.height) * 0.45;
    for (int i = 1; i <= 3; i++) {
      final r = maxRadius * (i / 3.0);
      canvas.drawCircle(center, r, ringPaint);
    }

    // Radar Crosshairs
    final crossPaint = Paint()
      ..color = const Color(0xFF2E7D32).withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(center.dx - maxRadius, center.dy),
      Offset(center.dx + maxRadius, center.dy),
      crossPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - maxRadius),
      Offset(center.dx, center.dy + maxRadius),
      crossPaint,
    );

    // 6. Rotating Animated Radar Sweep Beam
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: FractionalOffset(center.dx / size.width, center.dy / size.height),
        startAngle: 0.0,
        endAngle: math.pi / 2,
        colors: [
          const Color(0xFF00E676).withValues(alpha: 0.28),
          const Color(0xFF00E676).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(sweepAngle);
    canvas.drawCircle(Offset.zero, maxRadius, sweepPaint);

    // Leading sweep line
    final linePaint = Paint()
      ..color = const Color(0xFF00C853).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawLine(Offset.zero, Offset(maxRadius, 0), linePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TacticalRadarPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle;
  }
}
