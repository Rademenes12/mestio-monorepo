import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Widget that displays a report photo from either:
/// - Local file path (starts with '/' or contains ':')
/// - HTTP URL (starts with 'http')
/// - Supabase Storage path (e.g., 'estate-id/report-id/filename.jpg')
class ReportPhotoWidget extends StatefulWidget {
  const ReportPhotoWidget({
    super.key,
    required this.photoPath,
    this.height = 150,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.borderRadius = 8,
  });

  final String photoPath;
  final double height;
  final double width;
  final BoxFit fit;
  final double borderRadius;

  @override
  State<ReportPhotoWidget> createState() => _ReportPhotoWidgetState();
}

class _ReportPhotoWidgetState extends State<ReportPhotoWidget> {
  String? _signedUrl;
  bool _isLoading = true;
  String? _error;

  static const String _photoBucket = 'fixflow-report-photos';

  @override
  void initState() {
    super.initState();
    _resolvePhotoUrl();
  }

  @override
  void didUpdateWidget(ReportPhotoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoPath != widget.photoPath) {
      _resolvePhotoUrl();
    }
  }

  bool _isLocalFile(String path) {
    return path.startsWith('/') ||
        path.startsWith('file://') ||
        (Platform.isWindows && path.contains(':'));
  }

  bool _isHttpUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  Future<void> _resolvePhotoUrl() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final path = widget.photoPath;

    // Local file - use as is
    if (_isLocalFile(path)) {
      setState(() {
        _signedUrl = null; // Will use Image.file
        _isLoading = false;
      });
      return;
    }

    // HTTP URL - use as is
    if (_isHttpUrl(path)) {
      setState(() {
        _signedUrl = path;
        _isLoading = false;
      });
      return;
    }

    // Storage path - get signed URL
    try {
      final url = await Supabase.instance.client.storage
          .from(_photoBucket)
          .createSignedUrl(path, 3600); // 1 hour validity

      if (mounted) {
        setState(() {
          _signedUrl = url;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ [ReportPhotoWidget] Failed to get signed URL: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to load photo';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_error != null) {
      return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.broken_image, color: Colors.grey[400], size: 32),
              const SizedBox(height: 4),
              Text(
                _error!,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    // Local file
    if (_signedUrl == null && _isLocalFile(widget.photoPath)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Image.file(
          File(widget.photoPath),
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
          errorBuilder: (_, _, _) => _errorPlaceholder(),
        ),
      );
    }

    // Network URL (signed or HTTP)
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Image.network(
        _signedUrl!,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: widget.height,
            width: widget.width,
            color: Colors.grey[200],
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (_, _, _) => _errorPlaceholder(),
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Center(
        child: Icon(Icons.broken_image, color: Colors.grey[400], size: 32),
      ),
    );
  }
}
