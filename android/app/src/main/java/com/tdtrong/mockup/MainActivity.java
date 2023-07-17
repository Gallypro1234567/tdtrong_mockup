package com.tdtrong.mockup;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.vtcc.fingerscan.ui.FingerScan;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler {
    private final String methodChannel= "com.tdtrong.mockup.finger_scan";
    private static final int REQUEST_FINGERSCAN = 100;
    MethodChannel.Result res = null;
    JSONObject data = null;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel channel =
                new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), methodChannel);
        channel.setMethodCallHandler(this);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method){
            case "start_finger_scan":
                res = result;
                openFingerScan(call, result);
                break;
            default:break;

        }
    }

    private void openFingerScan(MethodCall call, MethodChannel.Result result) {
        Activity activity = this;
        if(activity == null){
            result.error("ACTIVITY_NOT_AVAILABLE", "Browser cannot be opened " +
                    "without foreground activity", null);
            return;
        }
        Intent intent = new Intent(getActivity(), FingerScan.class);
        if(intent != null){
            intent.putExtra("DNI", "12345678");
            intent.putExtra("finger_code", "L1");
            intent.putExtra("api_url", "http://169.255.187.90:8223/ApigwGateway/CoreService/UserRouting");
            intent.putExtra("sessionId", "62860a4-86b2-4450-bd02-a0445ebbad90");
            intent.putExtra("token", "axRsWOGs0fmrG1Ca5Svd9w==");
            intent.putExtra("username", "TESTNT_BRT");
            intent.putExtra("wsCode", "WSETZ_enhanceImage");
            intent.putExtra("wsCodeLiveness", "WSETZ_liveNessDetection");
        }
        startActivityForResult(intent, REQUEST_FINGERSCAN);
    }
    @SuppressLint("SetTextI18n")
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Log.d("TESTTEST", String.valueOf(requestCode));
        JSONObject obj = new JSONObject();
        if (requestCode == REQUEST_FINGERSCAN) {
            if (resultCode == RESULT_OK) {
                try {
                    assert data != null;
                    obj.put("code",data.getStringExtra("error_code"));
                    obj.put("message",data.getStringExtra("description"));
                    obj.put("dni",data.getStringExtra("code"));
                    obj.put("finger_code",data.getStringExtra("finger_code"));
                    obj.put("wsq_base64",data.getStringExtra("wsq_base64"));
                    obj.put("transaction_id",data.getStringExtra("transaction_id"));
                    obj.put("image_path",data.getStringExtra("image_path"));
                } catch (JSONException e) {
                    throw new RuntimeException(e);
                }
            }
            res.success(obj.toString());
        }

    }
}
