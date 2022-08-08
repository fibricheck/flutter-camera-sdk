package com.fibricheck.camera_sdk;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * CameraSdkPlugin
 */
public class CameraSdkPlugin implements FlutterPlugin {
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        BinaryMessenger messenger = flutterPluginBinding.getBinaryMessenger();

        flutterPluginBinding
                .getPlatformViewRegistry()
                .registerViewFactory("fibricheckview", new FlutterFibriCheckViewFactory(messenger));
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
}
