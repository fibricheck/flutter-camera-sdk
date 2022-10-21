package com.fibricheck.camera_sdk;

import android.util.Log;

import com.google.gson.Gson;
import com.qompium.fibrichecker.listeners.IFibriListener;
import com.qompium.fibrichecker.measurement.MeasurementData;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.EventChannel;

public class FlutterFibriListener implements EventChannel.StreamHandler, IFibriListener {
    private static final String TAG = "FlutterFibriCheckView";

    //Events
    private static final String EVENT_TYPE = "eventType";

    private static final String EVENT_SAMPLE_READY = "onSampleReady";
    private static final String EVENT_FINGER_DETECTED = "onFingerDetected";
    private static final String EVENT_FINGER_REMOVED = "onFingerRemoved";
    private static final String EVENT_CALIBRATION_READY = "onCalibrationReady";
    private static final String EVENT_HEARTBEAT = "onHeartBeat";
    private static final String EVENT_TIME_REMAINING = "onTimeRemaining";
    private static final String EVENT_MEASUREMENT_FINISHED = "onMeasurementFinished";
    private static final String EVENT_MEASUREMENT_START = "onMeasurementStart";
    private static final String EVENT_FINGER_DETECTION_TIME_EXPIRED = "onFingerDetectionTimeExpired";
    private static final String EVENT_PULSE_DETECTED = "onPulseDetected";
    private static final String EVENT_PULSE_DETECTION_TIME_EXPIRED = "onPulseDetectionTimeExpired";
    private static final String EVENT_MOVEMENT_DETECTED = "onMovementDetected";
    private static final String EVENT_MEASUREMENT_PROCESSED = "onMeasurementProcessed";

    private EventChannel.EventSink events;
    private SampleReadyCallBack sampleReadyCallBack;

    FlutterFibriListener(SampleReadyCallBack sampleReadyCallBack) {
        this.sampleReadyCallBack = sampleReadyCallBack;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.events = events;
    }

    @Override
    public void onCancel(Object arguments) {
        events = null;
    }

    @Override
    public void onSampleReady(final double ppg, double raw) {
        sampleReadyCallBack.onSampleReady(ppg);

        HashMap<String, Object> params = new HashMap<>();
        params.put("ppg", ppg);
        params.put("raw", raw);

        publishEvent(EVENT_SAMPLE_READY, params);
    }

    @Override
    public void onFingerDetected() {
        publishEvent(EVENT_FINGER_DETECTED, new HashMap<>());
    }

    @Override
    public void onFingerRemoved(double y, double v, double stdDevY) {
        HashMap<String, Object> params = new HashMap<>();
        params.put("y", y);
        params.put("v", v);
        params.put("stdDevY", stdDevY);

        publishEvent(EVENT_FINGER_REMOVED, params);
    }

    @Override
    public void onCalibrationReady() {
        publishEvent(EVENT_CALIBRATION_READY, new HashMap<>());
    }

    @Override
    public void onHeartBeat(int value) {
        HashMap<String, Object> params = new HashMap<>();
        params.put("heartRate", value);

        publishEvent(EVENT_HEARTBEAT, params);
    }

    @Override
    public void timeRemaining(int seconds) {
        HashMap<String, Object> params = new HashMap<>();
        params.put("seconds", seconds);

        publishEvent(EVENT_TIME_REMAINING, params);
    }

    @Override
    public void onMeasurementFinished() {
        publishEvent(EVENT_MEASUREMENT_FINISHED, new HashMap<>());
    }

    @Override
    public void onMeasurementStart() {
        publishEvent(EVENT_MEASUREMENT_START, new HashMap<>());
    }

    @Override
    public void onFingerDetectionTimeExpired() {
        publishEvent(EVENT_FINGER_DETECTION_TIME_EXPIRED, new HashMap<>());
    }

    @Override
    public void onPulseDetected() {
        publishEvent(EVENT_PULSE_DETECTED, new HashMap<>());
    }

    @Override
    public void onPulseDetectionTimeExpired() {
        publishEvent(EVENT_PULSE_DETECTION_TIME_EXPIRED, new HashMap<>());
    }

    @Override
    public void onMovementDetected() {
        publishEvent(EVENT_MOVEMENT_DETECTED, new HashMap<>());
    }

    @Override
    public void onMeasurementProcessed(MeasurementData measurementData) {
        Log.i(TAG, "Measurement processed with Heartbeat: " + measurementData.heartrate);

        HashMap<String, Object> params = new HashMap<>();

        try {
            Gson gson = new Gson();
            JSONObject jsonObject = new JSONObject(gson.toJson(measurementData));
            String measurementJson = jsonObject.toString();

            params.put("measurement", measurementJson);
            publishEvent(EVENT_MEASUREMENT_PROCESSED, params);
        } catch (JSONException | NullPointerException ex) {
            Log.e(TAG, ex.toString());
        }
    }

    private void publishEvent(String eventType, @NonNull HashMap<String, Object> params) {
        if (events == null)
            return;

        params.put(EVENT_TYPE, eventType);
        events.success(params);
    }
}
