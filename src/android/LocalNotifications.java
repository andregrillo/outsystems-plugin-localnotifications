package com.outsystems.localnotifications;

import android.app.AlarmManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.core.app.NotificationCompat;

import org.apache.cordova.*;
import android.Manifest;
import android.content.pm.PackageManager;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;

public class LocalNotifications extends CordovaPlugin {

    private static final int REQUEST_POST_NOTIFICATIONS = 100;
    private CallbackContext permissionCallbackContext;

    private static final String CHANNEL_ID = "LOCAL_NOTIFICATION_CHANNEL";

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if ("setLocalNotifications".equals(action)) {
            String title = args.getString(0);
            String subtitle = args.getString(1);
            int delayInSeconds = args.getInt(2);

            scheduleNotification(title, subtitle, delayInSeconds, callbackContext);
            return true;
        } else if ("checkPermissions".equals(action)) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                if (cordova.hasPermission(Manifest.permission.POST_NOTIFICATIONS)) {
                    callbackContext.success("granted");
                } else {
                    permissionCallbackContext = callbackContext;
                    cordova.requestPermission(this, REQUEST_POST_NOTIFICATIONS, Manifest.permission.POST_NOTIFICATIONS);
                }
            } else {
                callbackContext.success("granted");
            }
            return true;
        }

        callbackContext.error("Invalid action");
        return false;
    }

    private void scheduleNotification(String title, String subtitle, int delayInSeconds, CallbackContext callbackContext) {
        Context context = cordova.getContext();
        createNotificationChannel(context);

        Intent intent = new Intent(context, NotificationReceiver.class);
        intent.putExtra("title", title);
        intent.putExtra("subtitle", subtitle);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, (int) System.currentTimeMillis(), intent, PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT);

        long triggerAtMillis = System.currentTimeMillis() + (delayInSeconds * 1000);

        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        alarmManager.set(AlarmManager.RTC_WAKEUP, triggerAtMillis, pendingIntent);

        callbackContext.success("Local Notification set");
    }

    private void createNotificationChannel(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Local Notifications";
            String description = "Local notification channel";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);

            NotificationManager notificationManager = context.getSystemService(NotificationManager.class);
            if (notificationManager != null) {
                notificationManager.createNotificationChannel(channel);
            }
        }
    }

    @Override
    public void onRequestPermissionResult(int requestCode, String[] permissions, int[] grantResults) throws JSONException {
        if (requestCode == REQUEST_POST_NOTIFICATIONS) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                permissionCallbackContext.success("granted");
            } else {
                permissionCallbackContext.error("denied");
            }
            permissionCallbackContext = null;
        }
    }

    public static class NotificationReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String title = intent.getStringExtra("title");
            String subtitle = intent.getStringExtra("subtitle");

            NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                    .setSmallIcon(android.R.drawable.ic_dialog_info)
                    .setContentTitle(title)
                    .setContentText(subtitle)
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .setAutoCancel(true);

            NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            manager.notify((int) System.currentTimeMillis(), builder.build());
        }
    }
}
