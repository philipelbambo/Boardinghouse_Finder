import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../utils/permissions.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _showScanner = false;
  final MobileScannerController _cameraController = MobileScannerController();

  // Facebook-inspired color palette
  static const Color _backgroundColor = Color(0xFFF0F2F5);
  static const Color _cardBackground = Color(0xFFFFFFFF);
  static const Color _primaryBlue = Color(0xFF1877F2);
  static const Color _darkText = Color(0xFF1C1E21);
  static const Color _secondaryText = Color(0xFF65676B);
  static const Color _divider = Color(0xFFE4E6EB);

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _startScanning() async {
    bool hasPermission = await PermissionUtils.requestCameraPermission();
    if (hasPermission) {
      setState(() {
        _showScanner = true;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Camera permission is required for QR scanning'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void _handleBarcode(BarcodeCapture barcode) {
    final code = barcode.barcodes.first.rawValue;
    if (code != null) {
      _cameraController.stop();
      setState(() {
        _showScanner = false;
      });
      
      _processScannedCode(code);
    }
  }

  void _processScannedCode(String code) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scanned: $code'),
          backgroundColor: _primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      
      switch (code) {
        case 'TAGOLOAN_AFFORDABLE':
          Navigator.pushNamed(context, '/home');
          break;
        case 'TAGOLOAN_HIGHCLASS':
          Navigator.pushNamed(context, '/home');
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Unknown QR code scanned'),
              backgroundColor: Colors.orange.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showScanner) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scan QR Code'),
          backgroundColor: _cardBackground,
          foregroundColor: _darkText,
          elevation: 0,
          shadowColor: Colors.black.withOpacity(0.1),
          surfaceTintColor: Colors.transparent,
        ),
        body: MobileScanner(
          controller: _cameraController,
          onDetect: _handleBarcode,
        ),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _cardBackground,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Scan QR Codes',
          style: TextStyle(
            color: _darkText,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: _primaryBlue, size: 24),
            onPressed: _startScanning,
            tooltip: 'Start Scanning',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              color: _cardBackground,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: _primaryBlue,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Boardinghouse Finder',
                    style: TextStyle(
                      color: _darkText,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tagoloan, Misamis Oriental',
                    style: TextStyle(
                      color: _secondaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Scan Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _startScanning,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE7F3FF),
                        foregroundColor: _primaryBlue,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.camera_alt, size: 20),
                      label: const Text(
                        'Start Scanning',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Info Card
            Container(
              width: double.infinity,
              color: _cardBackground,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: _primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Choose your preferred category and scan using your phone',
                      style: TextStyle(
                        color: _secondaryText,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // QR Cards Section Header
            Container(
              width: double.infinity,
              color: _backgroundColor,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: const Text(
                'Available Categories',
                style: TextStyle(
                  color: _darkText,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            _buildQRCard(
              title: 'Affordable',
              subtitle: 'Budget-Friendly Boardinghouses',
              qrData: 'TAGOLOAN_AFFORDABLE',
              priceRange: '₱2,500 and below/month',
              icon: Icons.savings_outlined,
              description:
                  'Perfect for students and working individuals looking for affordable housing',
            ),

            const SizedBox(height: 8),

            _buildQRCard(
              title: 'High Class',
              subtitle: 'Premium Boardinghouses',
              qrData: 'TAGOLOAN_HIGHCLASS',
              priceRange: '₱5,000 and below/month',
              icon: Icons.workspace_premium_outlined,
              description:
                  'Premium accommodations with modern amenities and high-quality facilities',
            ),

            const SizedBox(height: 8),

            // How to Scan Section
            Container(
              width: double.infinity,
              color: _cardBackground,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: _primaryBlue,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'How to Scan',
                        style: TextStyle(
                          color: _darkText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInstructionStep(
                    '1',
                    'Tap the camera icon or "Start Scanning" button',
                  ),
                  const SizedBox(height: 12),
                  _buildInstructionStep(
                    '2',
                    'Allow camera permission when prompted',
                  ),
                  const SizedBox(height: 12),
                  _buildInstructionStep(
                    '3',
                    'Point your camera at any QR code above',
                  ),
                  const SizedBox(height: 12),
                  _buildInstructionStep(
                    '4',
                    'Boardinghouses will automatically load!',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: _primaryBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: _primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: const TextStyle(
                color: _secondaryText,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQRCard({
    required String title,
    required String subtitle,
    required String qrData,
    required String priceRange,
    required IconData icon,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _divider,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: _primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _darkText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: _secondaryText,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // QR Code
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _divider,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Colors.black,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // QR Code ID
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    qrData,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _secondaryText,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Price Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    priceRange,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _primaryBlue,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _secondaryText,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Scan Hint
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        size: 16,
                        color: _secondaryText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Scan using your phone',
                        style: TextStyle(
                          fontSize: 13,
                          color: _secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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