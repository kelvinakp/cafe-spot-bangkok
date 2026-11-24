import 'package:flutter/material.dart';

class CafeNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CafeNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  bool get _isAsset => url.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: url.isEmpty
            ? _fallback()
            : _isAsset
                ? Image.asset(
                    url,
                    width: width,
                    height: height,
                    fit: fit,
                    errorBuilder: (context, error, stackTrace) => _fallback(),
                  )
                : Image.network(
                    url,
                    width: width,
                    height: height,
                    fit: fit,
                    webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                    errorBuilder: (context, error, stackTrace) => _fallback(),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _loading();
                    },
                  ),
      ),
    );
  }

  Widget _loading() {
    return ColoredBox(
      color: const Color(0xFFEFEBE9),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.brown.shade400,
          ),
        ),
      ),
    );
  }

  Widget _fallback() {
    return const ColoredBox(
      color: Color(0xFFEFEBE9),
      child: Icon(Icons.local_cafe, color: Color(0xFF5D4037)),
    );
  }
}
