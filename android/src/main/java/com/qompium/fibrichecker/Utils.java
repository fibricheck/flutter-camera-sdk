package com.qompium.fibrichecker;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;

public class Utils {
    public static Activity getActivity(Context context) {
        if (context == null) {
            return null;
        } else if (context instanceof Activity) {
            return (Activity) context;
        } else if (context instanceof ContextWrapper) {
            return getActivity(((ContextWrapper) context).getBaseContext());
        }

        return null;
    }
}
