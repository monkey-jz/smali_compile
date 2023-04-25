package com.boyaa.cpu_usage;

import android.app.ActivityManager;
import android.app.Application;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.Process;
import android.util.Log;
import java.util.List;
import java.util.Locale;

public class BTestApplication extends Application {

    private static final String PACK_NAME = "com.boyaa.perfor.pt" ;
    private static final String ACTIVITY_NAME =  PACK_NAME + ".MainActivity" ;
    private static final String MAIN_SERVICE_ACTION =  "com.boyaa.mainservice" ;

    @Override
    public void onCreate() {

        super.onCreate();

        //避免多进程时多次执行
        if(isMainProcess(this)){
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    Log.i("STF_RAINBOWPT :","BTestApplication onCreate ........");
                    if(isInstallApp(getApplicationContext())){
                        Intent intent = new Intent();
                        ComponentName componentName = new ComponentName(PACK_NAME, ACTIVITY_NAME);
                        intent.setComponent(componentName);
                        intent.putExtra("packageName",getPackageName());
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);
                    }else{
                        Log.i("STF_RAINBOWPT : " ,"RAINBOWPT apk is not installed");
                    }
                }
            },1000);
        }
    }

    public  boolean isInstallApp(Context context) {
        final PackageManager packageManager = context.getPackageManager();
        List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);
        if (pinfo != null) {
            for (int i = 0; i < pinfo.size(); i++) {
                String pn = pinfo.get(i).packageName.toLowerCase(Locale.ENGLISH);
                if (pn.equals(PACK_NAME)) {
                    return true;
                }
            }
        }
        return false;
    }

    public boolean isMainProcess(Context context){

        ActivityManager am = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> processInfos = am.getRunningAppProcesses();
        String mainProcessName = getPackageName();
        int myPid = Process.myPid();
        for (ActivityManager.RunningAppProcessInfo info : processInfos) {
            if (info.pid == myPid && mainProcessName.equals(info.processName)) {
                return true;
            }
        }
        return false;
    }

}





