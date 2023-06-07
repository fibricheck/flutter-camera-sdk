package com.fibricheck.camera_sdk;

import android.content.Context;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

import java.security.InvalidParameterException;
import java.util.Map;

import com.fibricheck.camera_sdk.Utils;

public class FlutterFibriCheckViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;

    FlutterFibriCheckViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @NonNull
    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(@Nullable Context context, int viewId, @Nullable Object args) {
        if(args != null && !(args instanceof Map<?,?>)) {
            throw new InvalidParameterException("args should be of type Map<String,Object>");
        }

        final Map<String, Object> creationParams = args == null ? null : (Map<String,Object>)args;

        return new FlutterFibriCheckView(Utils.getActivity(context), messenger, viewId, creationParams);
    }
}
