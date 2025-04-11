import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

enum MediaType { image, video, unknown }

class MediaHelper {
  /// تحديد نوع الوسائط بناءً على امتداد الملف في URL
  static MediaType getMediaTypeFromExtension(String url) {
    // استخراج امتداد الملف من URL
    final extension = path.extension(url).toLowerCase();

    // امتدادات الصور الشائعة
    if (['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp']
        .contains(extension)) {
      return MediaType.image;
    }

    // امتدادات الفيديو الشائعة
    if (['.mp4', '.mov', '.avi', '.wmv', '.flv', '.webm', '.mkv', '.3gp']
        .contains(extension)) {
      return MediaType.video;
    }

    return MediaType.unknown;
  }

  /// تحديد نوع الوسائط من خلال استعلام HTTP HEAD
  static Future<MediaType> getMediaTypeFromHeaders(String url) async {
    try {
      // إرسال طلب HEAD للحصول على الترويسات فقط (أكثر كفاءة من GET)
      final response = await http.head(Uri.parse(url));

      if (response.statusCode == 200) {
        // فحص نوع المحتوى في ترويسة HTTP
        final contentType = response.headers['content-type'] ?? '';

        if (contentType.startsWith('image/')) {
          return MediaType.image;
        } else if (contentType.startsWith('video/')) {
          return MediaType.video;
        }
      }
    } catch (e) {
      debugPrint('خطأ في تحديد نوع الوسائط: $e');
    }

    return MediaType.unknown;
  }

  /// طريقة مركبة تجمع بين فحص الامتداد وترويسات HTTP
  static Future<MediaType> detectMediaType(String url) async {
    // أولاً، نحاول من خلال الامتداد (أسرع)
    final typeFromExtension = getMediaTypeFromExtension(url);

    if (typeFromExtension != MediaType.unknown) {
      return typeFromExtension;
    }

    // إذا كان الامتداد غير معروف، نحاول من خلال الترويسات
    return await getMediaTypeFromHeaders(url);
  }

  /// طريقة مساعدة لعرض الوسائط المناسبة
  static Widget buildMediaPreview(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return FutureBuilder<MediaType>(
      future: detectMediaType(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          switch (snapshot.data) {
            case MediaType.image:
              return Image.network(
                url,
                width: width,
                height: height,
                fit: fit,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              );

            case MediaType.video:
              return Container(
                width: width,
                height: height,
                color: Colors.black,
                child: const Center(
                  child: Icon(Icons.play_circle_fill,
                      color: Colors.white, size: 50),
                ),
              );

            case MediaType.unknown:
            default:
              return Container(
                width: width,
                height: height,
                color: Colors.grey[300],
                child: const Center(
                  child: Text('نوع ملف غير معروف'),
                ),
              );
          }
        }

        return const Center(child: Icon(Icons.error));
      },
    );
  }

  /// مثال على الاستخدام
  static void example() {
    // التحقق من نوع الوسائط
    final imageUrl = 'https://example.com/photo.jpg';
    final videoUrl = 'https://example.com/video.mp4';
    final unknownUrl = 'https://example.com/file.xyz';

    // استخدام الامتداد فقط
    final imageType = getMediaTypeFromExtension(imageUrl);
    print('نوع الصورة: $imageType'); // MediaType.image

    // استخدام الترويسات (أكثر دقة لكن أبطأ)
    getMediaTypeFromHeaders(videoUrl).then((type) {
      print('نوع الفيديو: $type'); // MediaType.video
    });

    // استخدام الطريقة المركبة
    detectMediaType(unknownUrl).then((type) {
      print('النوع غير المعروف: $type'); // سيحاول تحديده من الترويسات
    });
  }
}
