import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

enum ShareUrlResult { shared, copied, failed }

/// Shares a URL via the platform share sheet (Web Share API on web,
/// native share sheet on Android/iOS). Falls back to copying the URL to the
/// clipboard; returns [ShareUrlResult.failed] if neither is possible
/// (e.g. a non-secure context where both APIs are unavailable).
Future<ShareUrlResult> shareUrl(String url, {String? subject}) async {
  try {
    await Share.shareUri(Uri.parse(url));
    return ShareUrlResult.shared;
  } catch (_) {
    final copied = await copyToClipboard(url);
    return copied ? ShareUrlResult.copied : ShareUrlResult.failed;
  }
}

/// Copies [text] to the clipboard. On web uses a hidden textarea +
/// `execCommand('copy')` so it works even in non-secure contexts where
/// `navigator.clipboard` is unavailable.
Future<bool> copyToClipboard(String text) async {
  if (kIsWeb) {
    try {
      final textarea = html.TextAreaElement()
        ..value = text
        ..style.position = 'fixed'
        ..style.opacity = '0';
      html.document.body?.append(textarea);
      textarea.select();
      final ok = html.document.execCommand('copy');
      textarea.remove();
      return ok;
    } catch (_) {
      return false;
    }
  }
  try {
    await Clipboard.setData(ClipboardData(text: text));
    return true;
  } catch (_) {
    return false;
  }
}
