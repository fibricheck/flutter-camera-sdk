import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class IOSCompositionWidget extends StatelessWidget {
  const IOSCompositionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'FLFibriCheckView';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{"frame": "1"};

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}

class TogetherWidget extends StatelessWidget {
  const TogetherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      // return widget on Android.
      case TargetPlatform.iOS:
        return IOSCompositionWidget();
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }
}
