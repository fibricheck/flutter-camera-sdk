package com.fibricheck.camera_sdk;

import android.content.Context;
import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import java.util.Map;

public class FlutterFibriCheckViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;

    FlutterFibriCheckViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @NonNull
    @Override
    public PlatformView create(@Nullable Context context, int viewId, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;

        return new FlutterFibriCheckView(context, messenger, viewId, creationParams);
    }
}
