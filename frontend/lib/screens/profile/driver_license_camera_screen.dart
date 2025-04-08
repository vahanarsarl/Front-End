import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vahanar_front/providers/auth_provider.dart';
import 'package:vahanar_front/widgets/bottom_nav_bar.dart';

class DriverLicenseCameraScreen extends StatefulWidget {
  const DriverLicenseCameraScreen({super.key});

  @override
  _DriverLicenseCameraScreenState createState() => _DriverLicenseCameraScreenState();
}

class _DriverLicenseCameraScreenState extends State<DriverLicenseCameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isFirstSideCaptured = false;
  File? _firstSideImage;
  File? _secondSideImage;
  bool _isImageBlurry = false;
  bool _showMessage = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _initializeCamera();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required to scan your driver license')),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<bool> _checkIfImageIsBlurry(File imageFile) async {
    // Temporairement, on retourne false pour tester si la déclaration et l'appel fonctionnent
    return false;
  }

  Future<void> _captureImage() async {
    if (_isLoading) return;

    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      final imageFile = File(image.path);

      // Log pour vérifier le chemin de l'image capturée
      print('Captured image path: ${imageFile.path}');

      final isBlurry = await _checkIfImageIsBlurry(imageFile);
      if (isBlurry) {
        if (mounted) {
          setState(() {
            _isImageBlurry = true;
          });
        }
        return;
      }

      setState(() {
        _isImageBlurry = false;
        if (!_isFirstSideCaptured) {
          _firstSideImage = imageFile;
          _isFirstSideCaptured = true;
          _showMessage = true;
          Future.delayed(const Duration(seconds: 4), () {
            if (mounted) {
              setState(() {
                _showMessage = false;
              });
            }
          });
        } else {
          _secondSideImage = imageFile;
          _uploadImages();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing image: $e')),
        );
      }
    }
  }

  Future<void> _uploadImages() async {
    if (_firstSideImage == null || _secondSideImage == null) return;

    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      bool success = await authProvider.uploadDriverLicense(_firstSideImage!, _secondSideImage!);

      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProvider.error ?? 'Failed to upload driver license')),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Driver license successfully added')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Driver License',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'LeagueSpartan-Bold',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2A4D50),
        elevation: 0,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Camera preview prend maintenant tout l'espace disponible
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CameraPreview(_controller!),
                ),
                
                // Overlay pour guider l'utilisateur
                Positioned(
                  top: 30.h,
                  left: 20.w,
                  right: 20.w,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      _isFirstSideCaptured ? 'Scan the back side' : 'Scan the front side',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontFamily: 'LeagueSpartan',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                
                // Cadre de scan
                Center(
                  child: Container(
                    width: 300.w,
                    height: 200.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.w),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                
                // Messages d'information
                if (_showMessage)
                  Positioned(
                    top: 250.h,
                    left: 20.w,
                    right: 20.w,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Please add the other side of your driver license.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'LeagueSpartan',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                
                if (_isImageBlurry)
                  Positioned(
                    top: 250.h,
                    left: 20.w,
                    right: 20.w,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Image is blurry. Please retake the photo.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'LeagueSpartan',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _captureImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43919D),
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                _isLoading
                    ? 'Uploading...'
                    : _isFirstSideCaptured
                        ? 'Finish'
                        : 'Capture',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const BottomNavBar(selectedIndex: 2),
        ],
      ),
    );
  }
}