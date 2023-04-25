package com.boyaa.cpu_usage;

import android.app.ActivityManager;
import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Context;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.net.Uri;
import android.util.Log;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.List;

public class BTestPidCpuUsageProvider extends ContentProvider {
    private static final UriMatcher matcher;

    private static final String TAG = "CpuUsageProvider";
    private static final String AUTHORITY = "com.boyaa.test.cpu.provider";
    private static final int GET_PID_CPU_USAGE = 0;
    private static final int GET_PIDS_INFO = 1;
    private boolean isFirstQuery = true;
    private Context mContext;
    private List<Integer> mPids;
    private List<String> mProcessNames;

    /*
	 * Static code block, when the class is loaded, execute
	*/
    static {
        //init UriMatcher
        matcher = new UriMatcher(UriMatcher.NO_MATCH);
        //Get the cpu usage rate of the specified process
        matcher.addURI(AUTHORITY, "getPidCpuUsage", GET_PID_CPU_USAGE);
        //Get the process ID and process name of all processes in the application.
        matcher.addURI(AUTHORITY, "getPidsInfo", GET_PIDS_INFO);
    }


    @Override
    public boolean onCreate() {
        mContext = getContext();
        return true;
    }

    @Override
    public Cursor query(Uri uri,String[] projection, String selection,String[] selectionArgs,String sortOrder) {
        MatrixCursor matrixCursor = null;
        switch (matcher.match(uri)) {
            case GET_PID_CPU_USAGE:
                if(isFirstQuery){
                    if(mPids == null){
                        List<List> pidsAndprocessNames = getPidsAndprocessNames();
                        mPids =  pidsAndprocessNames.get(0);
                        isFirstQuery = false;
                    }
                }
                double[] pidsCpuUsageDouble = readPidCpu(mPids);
                String [] pidsCpuUsageString  = conver2StringArray(pidsCpuUsageDouble);
                String pidCpuUsage = "";
                for (int i = 0; i < pidsCpuUsageString.length; i++) {
                    pidCpuUsage += pidsCpuUsageString[i] + ",";
                }
                String [] columName = {"pid_cpu_usage"};
                matrixCursor = new MatrixCursor(columName);
                matrixCursor.addRow(new String []{pidCpuUsage});
                break;
            case GET_PIDS_INFO:
                List<List> pidsAndprocessNames = getPidsAndprocessNames();
                mPids =  pidsAndprocessNames.get(0);
                mProcessNames = pidsAndprocessNames.get(1);
                String pids = "";
                String processNames = "";
                for (int i = 0; i < mPids.size(); i++) {
                    String pid = String.valueOf(mPids.get(i));
                    pids += pid + ",";
                    processNames += mProcessNames.get(i) + ",";
                }
                String [] columNameInfo = {"pids","processNames"};
                matrixCursor = new MatrixCursor(columNameInfo);
                matrixCursor.addRow(new String[]{pids,processNames} );
                break;
            default:
                throw new IllegalArgumentException("Unknown URI: " + uri);
        }
        return matrixCursor;
    }

    @Override
    public String getType(Uri uri) {
        return null;
    }


    @Override
    public Uri insert(Uri uri, ContentValues values) {
        return null;
    }

    @Override
    public int delete(Uri uri,String selection, String[] selectionArgs) {
        return 0;
    }

    @Override
    public int update(Uri uri,ContentValues values,String selection,String[] selectionArgs) {
        return 0;
    }

    /**
     * Android 7.0 ie N can only read this application /proc/{pid}/stat file
     */
    public double [] readPidCpu(List<Integer> pids){

        double [] pidCpuUsage = new double[pids.size()];
        double processCpu = 0.00;
        for (int i = 0; i < pids.size(); i++) {
            String cpuStatPath = "/proc/" + pids.get(i) + "/stat";
            RandomAccessFile reader = null;
            try {
                reader = new RandomAccessFile(cpuStatPath, "r");
                String line = "";
                StringBuffer stringBuffer = new StringBuffer();
                stringBuffer.setLength(0);
                while ((line = reader.readLine()) != null) {
                    stringBuffer.append(line + "\n");
                }
                String[] toks = stringBuffer.toString().split(" ");
                processCpu = Double.parseDouble(toks[13]) + Double.parseDouble(toks[14]);
                pidCpuUsage[i] = processCpu;

            } catch (Exception e) {
                e.printStackTrace(); }finally {
                if(reader != null){
                    try {
                        reader.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        return pidCpuUsage;
    }

    //You can only get the app by getting the PID through the service.
    public List<List> getPidsAndprocessNames(){

        List<List> pidsAndProcessNames = new ArrayList<>();
        List<Integer> pids = new ArrayList<>();
        List<String> processNames = new ArrayList<>();
        ActivityManager am =(ActivityManager)mContext.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> rap = am.getRunningAppProcesses();
        for (int i = 0; i <rap.size() ; i++) {

            String processName = rap.get(i).processName;
            Log.i(TAG,"processName be test : " + processName);
            //Filter out the progress of statistics
            if (processName.contains(getContext().getPackageName()) && !processName.contains("BTestPidCpuUsageProvider")){
                pids.add(rap.get(i).pid);
                processNames.add(rap.get(i).processName);
            }
        }
        pidsAndProcessNames.add(pids);
        pidsAndProcessNames.add(processNames);
        return pidsAndProcessNames;
    }

    private String[] conver2StringArray(double[] pidsCpuUsageDouble) {
        String [] stringArrary = new String[pidsCpuUsageDouble.length];
        for (int i = 0; i < pidsCpuUsageDouble.length; i++) {
            stringArrary[i] = String.valueOf(pidsCpuUsageDouble[i]);
        }
        return stringArrary;
    }

    //You can obtain the PID of the specified package name by performing content filtering on the command line.
    public List<String[]> getAppProcessInfoByPackage(String packageName) {
        List<String[]> appProcessList = new ArrayList<String[]>();
        BufferedReader bd = null;
        try {
            ProcessBuilder execBuilder = new ProcessBuilder("sh", "-c", "ps");
            execBuilder.redirectErrorStream(true);
            Process exec = execBuilder.start();
            bd = new BufferedReader(new InputStreamReader(exec.getInputStream()));
            String line = null;
            while ((line = bd.readLine()) != null) {
                Log.i(TAG, "get app process info by package ps result: " + line);
                String[] array = line.split("\\s+");
                if (array[array.length-1].contains(packageName)) {
                    appProcessList.add(array);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (bd != null) {
                try {
                    bd.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return appProcessList;
    }
}
