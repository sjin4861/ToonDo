import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:native_image_cropper/native_image_cropper.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart';

class ImageCropScreen extends StatefulWidget {
  final File imageFile;

  const ImageCropScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  late CropController _controller;
  Uint8List? _imageBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _controller = CropController();
  }

  Future<void> _loadImage() async {
    try {
      final bytes = await widget.imageFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _controller.bytes = bytes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지를 불러올 수 없습니다: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _cropAndSave() async {
    try {
      final croppedBytes = await _controller.crop();
      
      if (croppedBytes.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('크롭에 실패했습니다.')),
          );
        }
        return;
      }

      // 임시 파일로 저장
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(croppedBytes);

      if (mounted) {
        Navigator.of(context).pop(tempFile.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('크롭 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '이미지 편집',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading || _imageBytes == null
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Column(
              children: [
                Expanded(
                  child: CropPreview(
                    controller: _controller,
                    bytes: _imageBytes!,
                    mode: CropMode.oval, // 원형 크롭
                    dragPointSize: 12, // 드래그 포인트 크기 줄임
                    hitSize: 24, // 히트 영역은 유지
                    maskOptions: const MaskOptions(
                      backgroundColor: Colors.black54,
                      borderColor: Colors.white,
                      strokeWidth: 1.5,
                      aspectRatio: 1.0, // 정사각형 비율
                      minSize: 100,
                    ),
                    dragPointBuilder: (size, position) {
                      // 현대적인 작은 드래그 포인트 디자인
                      return Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.a24),
                    child: AppButton(
                      label: '완료',
                      onPressed: _cropAndSave,
                      isFullWidth: true,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

