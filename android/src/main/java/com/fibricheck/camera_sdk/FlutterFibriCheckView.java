package com.fibricheck.camera_sdk;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.Insets;
import android.os.Build;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowInsets;
import android.view.WindowMetrics;
import android.widget.LinearLayout;

import com.jjoe64.graphview.GraphView;
import com.jjoe64.graphview.Viewport;
import com.jjoe64.graphview.series.DataPoint;
import com.jjoe64.graphview.series.LineGraphSeries;
import com.qompium.fibricheck.camerasdk.FibriChecker;
import com.fibricheck.camera_sdk.Utils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Map;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class FlutterFibriCheckView implements PlatformView, MethodChannel.MethodCallHandler, SampleReadyCallBack {
    private static final String TAG = "FlutterFibriCheckView";
    private static final int SAMPLE_COUNT = 120;

    // Commands
    private static final String ALL_PROPERTIES_INITIALIZED = "allPropertiesInitialized";
    private static final String RESET_MODULE = "resetModule";

    //Properties
    private static final String SET_DRAWGRAPH = "setDrawGraph";
    private static final String SET_DRAWBACKGROUND = "setDrawBackground";
    private static final String SET_LINECOLOR = "setLineColor";
    private static final String SET_LINETHICKNESS = "setLineThickness";
    private static final String SET_GRAPHBACKGROUNDCOLOR = "setGraphBackgroundColor";
    private static final String SET_SAMPLETIME = "setSampleTime";
    private static final String SET_ACCENABLED = "setAccEnabled";
    private static final String SET_FINGERDETECTIONEXPIRYTIME = "setFingerDetectionExpiryTime";
    private static final String SET_FLASHENABLED = "setFlashEnabled";
    private static final String SET_GRAVENABLED = "setGravEnabled";
    private static final String SET_GYROENABLED = "setGyroEnabled";
    private static final String SET_MOVEMENTDETECTIONENABLED = "setMovementDetectionEnabled";
    private static final String SET_ROTATIONENABLED = "setRotationEnabled";
    private static final String SET_WAITFORSTARTRECORDINGSIGNAL = "setWaitForStartRecordingSignal";
    private static final String SET_PULSEDETECTIONEXPIRYTIME = "setPulseDetectionExpiryTime";

    private final Context context;

    @NonNull
    private final MethodChannel methodChannel;
    private final EventChannel eventChannel;
    private final FlutterFibriListener flutterFibriListener;

    private boolean drawGraphPoints = false;

    private LineGraphSeries<DataPoint> series;

    private ArrayList<Double> valueSR;

    private int xValue = 0;

    private GraphView graphView;

    private LinearLayout linearLayout;

    private FibriChecker fibriChecker;

    FlutterFibriCheckView(@NonNull Context context, BinaryMessenger messenger, int id, @Nullable Map<String, Object> creationParams) {
        this.context = context;

        String channelId = creationParams == null ? "" : (String) creationParams.get("channelId");
        String channelName = "com.fibricheck.camera_sdk/flutterFibriCheckView_" + channelId;

        methodChannel = new MethodChannel(messenger, channelName + "_method");
        methodChannel.setMethodCallHandler(this);

        flutterFibriListener = new FlutterFibriListener(this);

        eventChannel = new EventChannel(messenger, channelName  + "_event");
        eventChannel.setStreamHandler(flutterFibriListener);
    }

    @Override
    public View getView() {
        return createView();
    }

    @Override
    public void dispose() {
        fibriChecker.stop();
        methodChannel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
    }

    //region Props Setters

    public void setDrawGraph(boolean drawGraph) {
        drawGraphPoints = drawGraph;
    }

    public void setDrawBackground(boolean drawBackground) {
        series.setDrawBackground(drawBackground);
    }

    public void setLineColor(String lineColor) {
        series.setColor(Color.parseColor(lineColor));
    }

    public void setLineThickness(int lineThickness) {
        series.setThickness(lineThickness);
    }

    public void setGraphBackgroundColor(String graphBackgroundColor) {
        if (graphBackgroundColor == null || graphBackgroundColor.isEmpty())
        {
            series.setBackgroundColor(Color.TRANSPARENT);
        }
        else
        {
            series.setBackgroundColor(Color.parseColor(graphBackgroundColor));
        }
    }

    public void setSampleTime(int sampleTime) {
        fibriChecker.sampleTime = sampleTime;
        Log.i(TAG, "Sampletime set to: " + sampleTime);
    }

    public void setPulseDetectionExpiryTime(int pulseDetectionExpiryTime) {
        fibriChecker.pulseDetectionExpiryTime = pulseDetectionExpiryTime;
    }

    public void setAccEnabled(boolean accEnabled) {
        fibriChecker.accEnabled = accEnabled;
    }

    public void setFingerDetectionExpiryTime(int fingerDetectionExpiryTime) {
        fibriChecker.fingerDetectionExpiryTime = fingerDetectionExpiryTime;
    }

    public void setFlashEnabled(boolean flashEnabled) {
        fibriChecker.flashEnabled = flashEnabled;
    }

    public void setGravEnabled(boolean gravEnabled) {
        fibriChecker.gravEnabled = gravEnabled;
    }

    public void setGyroEnabled(boolean gyroEnabled) {
        fibriChecker.gyroEnabled = gyroEnabled;
    }

    public void setMovementDetectionEnabled(boolean movementDetectionEnabled) {
        fibriChecker.movementDetectionEnabled = movementDetectionEnabled;
    }

    public void setRotationEnabled(boolean rotationEnabled) {
        fibriChecker.rotationEnabled = rotationEnabled;
    }

    public void setWaitForStartRecordingSignal(boolean waitForStartRecordingSignal) {
        fibriChecker.waitForStartRecordingSignal = waitForStartRecordingSignal;
    }
    //endregion

    @Override
    public void onSampleReady(double ppg) {
        if (drawGraphPoints) {
            addGraphData(ppg);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case ALL_PROPERTIES_INITIALIZED:
                fibriChecker.initializeListeners();
                fibriChecker.start();
                result.success(true);
                break;
            case RESET_MODULE:
                fibriChecker.stop();
                result.success(true);
                break;
            case SET_DRAWGRAPH:
                boolean drawGraph = (boolean) call.arguments;
                setDrawGraph(drawGraph);
                result.success(true);
                break;
            case SET_DRAWBACKGROUND:
                boolean drawBackground = (boolean) call.arguments;
                setDrawBackground(drawBackground);
                result.success(true);
                break;
            case SET_LINECOLOR:
                String lineColor = (String) call.arguments;
                setLineColor(lineColor);
                result.success(true);
                break;
            case SET_LINETHICKNESS:
                int lineThickness = (int) call.arguments;
                setLineThickness(lineThickness);
                result.success(true);
                break;
            case SET_GRAPHBACKGROUNDCOLOR:
                String graphBackgroundColor = (String) call.arguments;
                setGraphBackgroundColor(graphBackgroundColor);
                result.success(true);
                break;
            case SET_SAMPLETIME:
                int sampleTime = (int) call.arguments;
                setSampleTime(sampleTime);
                result.success(true);
                break;
            case SET_ACCENABLED:
                boolean accEnabled = (boolean) call.arguments;
                setAccEnabled(accEnabled);
                result.success(true);
                break;
            case SET_FINGERDETECTIONEXPIRYTIME:
                int fingerDetectionExpiryTime = (int) call.arguments;
                setFingerDetectionExpiryTime(fingerDetectionExpiryTime);
                result.success(true);
                break;
            case SET_FLASHENABLED:
                boolean flashEnabled = (boolean) call.arguments;
                setFlashEnabled(flashEnabled);
                result.success(true);
                break;
            case SET_GYROENABLED:
                boolean gyroEnabled = (boolean) call.arguments;
                setGyroEnabled(gyroEnabled);
                result.success(true);
                break;
            case SET_MOVEMENTDETECTIONENABLED:
                boolean movementDetectionEnabled = (boolean) call.arguments;
                setMovementDetectionEnabled(movementDetectionEnabled);
                result.success(true);
                break;
            case SET_ROTATIONENABLED:
                boolean rotationEnabled = (boolean) call.arguments;
                setRotationEnabled(rotationEnabled);
                result.success(true);
                break;
            case SET_WAITFORSTARTRECORDINGSIGNAL:
                boolean waitForStartRecordingSignal = (boolean) call.arguments;
                setWaitForStartRecordingSignal(waitForStartRecordingSignal);
                result.success(true);
                break;
            case SET_GRAVENABLED:
                boolean gravEnabled = (boolean) call.arguments;
                setGravEnabled(gravEnabled);
                result.success(true);
                break;
            case SET_PULSEDETECTIONEXPIRYTIME:
                int pulseDetectionExpiryTime = (int) call.arguments;
                setPulseDetectionExpiryTime(pulseDetectionExpiryTime);
                result.success(true);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private LinearLayout createView() {

        Log.i(TAG, "Creating View instance");

        linearLayout = new LinearLayout(context);
        linearLayout.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
        linearLayout.setOrientation(LinearLayout.HORIZONTAL);

        valueSR = new ArrayList<>();
        graphView = createGraphView(context);

        linearLayout.addView(graphView);

        fibriChecker = new FibriChecker.FibriBuilder(context, linearLayout).build();
        fibriChecker.setFibriListener(flutterFibriListener);

        return linearLayout;
    }

    //region Graphs
    private GraphView createGraphView(Context context) {
        graphView = new GraphView(context);
        invalidateGraphView(graphView, context);

        Log.i(TAG, "W X H: " + graphView.getWidth() + " x " + graphView.getHeight());
        return graphView;
    }

    private void invalidateGraphView(GraphView graphView, Context context) {
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        graphView.setBackgroundColor(Color.TRANSPARENT);
        params.gravity = Gravity.CENTER_HORIZONTAL;
        graphView.setLayoutParams(params);
        setViewPortOptions(graphView);
        setSeries(graphView, context);
    }

    private void setViewPortOptions(GraphView graphView) {
        Viewport viewport = graphView.getViewport();
        viewport.setScalable(false);
        viewport.setScrollable(false);
        viewport.setXAxisBoundsManual(true);
        viewport.setYAxisBoundsManual(true);
        viewport.setMinX(0);
        viewport.setMaxX(SAMPLE_COUNT);
    }

    private void setSeries(GraphView graphView, Context context) {
        ArrayList<DataPoint> dataPoints = new ArrayList<>();

        // fill array wih empty values
        DataPoint[] data = new DataPoint[SAMPLE_COUNT];
        for (int i = 0; i < SAMPLE_COUNT; i++) {
            data[i] = new DataPoint(0, 0);
        }

        this.series = new LineGraphSeries<DataPoint>(data);

        series = new LineGraphSeries<>(dataPoints.toArray(new DataPoint[dataPoints.size()]));
        series.setColor(Color.BLUE);
        series.setThickness(8);
        series.setBackgroundColor(Color.TRANSPARENT);
        series.setDrawBackground(true);

        int width = getScreenWidth(context);
        boolean drawAsPath = width >= 1080;

        series.setDrawAsPath(drawAsPath);

        graphView.removeAllSeries();
        graphView.addSeries(series);
    }

    private int getScreenWidth(Context context) {
        Activity activity = Utils.getActivity(context);

        if (activity == null){
            return Resources.getSystem().getDisplayMetrics().widthPixels;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            WindowMetrics windowMetrics = activity.getWindowManager().getCurrentWindowMetrics();
            Insets insets = windowMetrics.getWindowInsets()
                    .getInsetsIgnoringVisibility(WindowInsets.Type.systemBars());
            return windowMetrics.getBounds().width() - insets.left - insets.right;
        } else {
            return getScreenWidthBelowAndroidR(activity);
        }
    }

    @TargetApi(Build.VERSION_CODES.Q)
    @SuppressWarnings("deprecation")
    private int getScreenWidthBelowAndroidR(@NonNull Activity activity) {
        DisplayMetrics displayMetrics = new DisplayMetrics();
        activity.getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        return displayMetrics.widthPixels;
    }

    private void addGraphData(double value) {
        calculateYaxisBoundaries(value);
        series.appendData(new DataPoint(++xValue, value), true, SAMPLE_COUNT);
    }

    private void calculateYaxisBoundaries(double value) {
        addValueToSR(value);
        graphView.getViewport().setMaxY(Collections.max(valueSR) + 0.2);
        graphView.getViewport().setMinY(Collections.min(valueSR) - 0.2);
    }

    private void addValueToSR(double value) {

        valueSR.add(value);
        if (valueSR.size() > SAMPLE_COUNT) {
            valueSR.remove(0);
        }
    }
    //endregion
}
