.class public Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;
.super Landroid/content/ContentProvider;
.source "BTestPidCpuUsageProvider.java"


# static fields
.field private static final AUTHORITY:Ljava/lang/String; = "com.boyaa.test.cpu.provider"

.field private static final GET_PIDS_INFO:I = 0x1

.field private static final GET_PID_CPU_USAGE:I = 0x0

.field private static final TAG:Ljava/lang/String; = "CpuUsageProvider"

.field private static final matcher:Landroid/content/UriMatcher;


# instance fields
.field private isFirstQuery:Z

.field private mContext:Landroid/content/Context;

.field private mPids:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List",
            "<",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation
.end field

.field private mProcessNames:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .registers 4

    .prologue
    .line 36
    new-instance v0, Landroid/content/UriMatcher;

    const/4 v1, -0x1

    invoke-direct {v0, v1}, Landroid/content/UriMatcher;-><init>(I)V

    sput-object v0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->matcher:Landroid/content/UriMatcher;

    .line 38
    sget-object v0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->matcher:Landroid/content/UriMatcher;

    const-string v1, "com.boyaa.test.cpu.provider"

    const-string v2, "getPidCpuUsage"

    const/4 v3, 0x0

    invoke-virtual {v0, v1, v2, v3}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    .line 40
    sget-object v0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->matcher:Landroid/content/UriMatcher;

    const-string v1, "com.boyaa.test.cpu.provider"

    const-string v2, "getPidsInfo"

    const/4 v3, 0x1

    invoke-virtual {v0, v1, v2, v3}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    .line 41
    return-void
.end method

.method public constructor <init>()V
    .registers 2

    .prologue
    .line 19
    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V

    .line 26
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->isFirstQuery:Z

    return-void
.end method

.method private conver2StringArray([D)[Ljava/lang/String;
    .registers 6

    .prologue
    .line 174
    array-length v0, p1

    new-array v1, v0, [Ljava/lang/String;

    .line 175
    const/4 v0, 0x0

    :goto_4
    array-length v2, p1

    if-ge v0, v2, :cond_12

    .line 176
    aget-wide v2, p1, v0

    invoke-static {v2, v3}, Ljava/lang/String;->valueOf(D)Ljava/lang/String;

    move-result-object v2

    aput-object v2, v1, v0

    .line 175
    add-int/lit8 v0, v0, 0x1

    goto :goto_4

    .line 178
    :cond_12
    return-object v1
.end method


# virtual methods
.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .registers 5

    .prologue
    .line 106
    const/4 v0, 0x0

    return v0
.end method

.method public getAppProcessInfoByPackage(Ljava/lang/String;)Ljava/util/List;
    .registers 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List",
            "<[",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .prologue
    .line 183
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 184
    const/4 v2, 0x0

    .line 186
    :try_start_6
    new-instance v0, Ljava/lang/ProcessBuilder;

    const/4 v1, 0x3

    new-array v1, v1, [Ljava/lang/String;

    const/4 v4, 0x0

    const-string v5, "sh"

    aput-object v5, v1, v4

    const/4 v4, 0x1

    const-string v5, "-c"

    aput-object v5, v1, v4

    const/4 v4, 0x2

    const-string v5, "ps"

    aput-object v5, v1, v4

    invoke-direct {v0, v1}, Ljava/lang/ProcessBuilder;-><init>([Ljava/lang/String;)V

    .line 187
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/lang/ProcessBuilder;->redirectErrorStream(Z)Ljava/lang/ProcessBuilder;

    .line 188
    invoke-virtual {v0}, Ljava/lang/ProcessBuilder;->start()Ljava/lang/Process;

    move-result-object v0

    .line 189
    new-instance v1, Ljava/io/BufferedReader;

    new-instance v4, Ljava/io/InputStreamReader;

    invoke-virtual {v0}, Ljava/lang/Process;->getInputStream()Ljava/io/InputStream;

    move-result-object v0

    invoke-direct {v4, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    invoke-direct {v1, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    :try_end_33
    .catch Ljava/io/IOException; {:try_start_6 .. :try_end_33} :catch_8f
    .catchall {:try_start_6 .. :try_end_33} :catchall_80

    .line 191
    :cond_33
    :goto_33
    :try_start_33
    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_70

    .line 192
    const-string v2, "CpuUsageProvider"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "get app process info by package ps result: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v2, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 193
    const-string v2, "\\s+"

    invoke-virtual {v0, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    .line 194
    array-length v2, v0

    add-int/lit8 v2, v2, -0x1

    aget-object v2, v0, v2

    invoke-virtual {v2, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_33

    .line 195
    invoke-interface {v3, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_65
    .catch Ljava/io/IOException; {:try_start_33 .. :try_end_65} :catch_66
    .catchall {:try_start_33 .. :try_end_65} :catchall_8d

    goto :goto_33

    .line 198
    :catch_66
    move-exception v0

    .line 199
    :goto_67
    :try_start_67
    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V
    :try_end_6a
    .catchall {:try_start_67 .. :try_end_6a} :catchall_8d

    .line 201
    if-eqz v1, :cond_6f

    .line 203
    :try_start_6c
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V
    :try_end_6f
    .catch Ljava/io/IOException; {:try_start_6c .. :try_end_6f} :catch_7b

    .line 210
    :cond_6f
    :goto_6f
    return-object v3

    .line 201
    :cond_70
    if-eqz v1, :cond_6f

    .line 203
    :try_start_72
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V
    :try_end_75
    .catch Ljava/io/IOException; {:try_start_72 .. :try_end_75} :catch_76

    goto :goto_6f

    .line 204
    :catch_76
    move-exception v0

    .line 205
    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_6f

    .line 204
    :catch_7b
    move-exception v0

    .line 205
    invoke-virtual {v0}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_6f

    .line 201
    :catchall_80
    move-exception v0

    move-object v1, v2

    :goto_82
    if-eqz v1, :cond_87

    .line 203
    :try_start_84
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V
    :try_end_87
    .catch Ljava/io/IOException; {:try_start_84 .. :try_end_87} :catch_88

    .line 206
    :cond_87
    :goto_87
    throw v0

    .line 204
    :catch_88
    move-exception v1

    .line 205
    invoke-virtual {v1}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_87

    .line 201
    :catchall_8d
    move-exception v0

    goto :goto_82

    .line 198
    :catch_8f
    move-exception v0

    move-object v1, v2

    goto :goto_67
.end method

.method public getPidsAndprocessNames()Ljava/util/List;
    .registers 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List",
            "<",
            "Ljava/util/List;",
            ">;"
        }
    .end annotation

    .prologue
    .line 153
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 154
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 155
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    .line 156
    iget-object v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->mContext:Landroid/content/Context;

    const-string v1, "activity"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/ActivityManager;

    .line 157
    invoke-virtual {v0}, Landroid/app/ActivityManager;->getRunningAppProcesses()Ljava/util/List;

    move-result-object v5

    .line 158
    const/4 v0, 0x0

    move v1, v0

    :goto_1f
    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v0

    if-ge v1, v0, :cond_79

    .line 160
    invoke-interface {v5, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/ActivityManager$RunningAppProcessInfo;

    iget-object v0, v0, Landroid/app/ActivityManager$RunningAppProcessInfo;->processName:Ljava/lang/String;

    .line 161
    const-string v6, "CpuUsageProvider"

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "processName be test : "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v6, v7}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 163
    invoke-virtual {p0}, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->getContext()Landroid/content/Context;

    move-result-object v6

    invoke-virtual {v6}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-eqz v6, :cond_75

    const-string v6, "BTestPidCpuUsageProvider"

    invoke-virtual {v0, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_75

    .line 164
    invoke-interface {v5, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/ActivityManager$RunningAppProcessInfo;

    iget v0, v0, Landroid/app/ActivityManager$RunningAppProcessInfo;->pid:I

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-interface {v3, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 165
    invoke-interface {v5, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/ActivityManager$RunningAppProcessInfo;

    iget-object v0, v0, Landroid/app/ActivityManager$RunningAppProcessInfo;->processName:Ljava/lang/String;

    invoke-interface {v4, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 158
    :cond_75
    add-int/lit8 v0, v1, 0x1

    move v1, v0

    goto :goto_1f

    .line 168
    :cond_79
    invoke-interface {v2, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 169
    invoke-interface {v2, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 170
    return-object v2
.end method

.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .registers 3

    .prologue
    .line 95
    const/4 v0, 0x0

    return-object v0
.end method

.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .registers 4

    .prologue
    .line 101
    const/4 v0, 0x0

    return-object v0
.end method

.method public onCreate()Z
    .registers 2

    .prologue
    .line 46
    invoke-virtual {p0}, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    iput-object v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->mContext:Landroid/content/Context;

    .line 47
    const/4 v0, 0x1

    return v0
.end method

.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .registers 14

    .prologue
    const/4 v7, 0x2

    const/4 v6, 0x1

    const/4 v1, 0x0

    .line 52
    .line 53
    sget-object v0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->matcher:Landroid/content/UriMatcher;

    invoke-virtual {v0, p1}, Landroid/content/UriMatcher;->match(Landroid/net/Uri;)I

    move-result v0

    packed-switch v0, :pswitch_data_fa

    .line 88
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Unknown URI: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 55
    :pswitch_25
    iget-boolean v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->isFirstQuery:Z

    if-eqz v0, :cond_3b

    .line 56
    iget-object v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->mPids:Ljava/util/List;

    if-nez v0, :cond_3b

    .line 57
    invoke-virtual {p0}, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->getPidsAndprocessNames()Ljava/util/List;

    move-result-object v0

    .line 58
    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/List;

    iput-object v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->mPids:Ljava/util/List;

    .line 59
    iput-boolean v1, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->isFirstQuery:Z

    .line 62
    :cond_3b
    iget-object v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->mPids:Ljava/util/List;

    invoke-virtual {p0, v0}, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->readPidCpu(Ljava/util/List;)[D

    move-result-object v0

    .line 63
    invoke-direct {p0, v0}, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->conver2StringArray([D)[Ljava/lang/String;

    move-result-object v3

    .line 64
    const-string v2, ""

    move v0, v1

    .line 65
    :goto_48
    array-length v4, v3

    if-ge v0, v4, :cond_67

    .line 66
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    aget-object v4, v3, v0

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, ","

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 65
    add-int/lit8 v0, v0, 0x1

    goto :goto_48

    .line 68
    :cond_67
    new-array v3, v6, [Ljava/lang/String;

    const-string v0, "pid_cpu_usage"

    aput-object v0, v3, v1

    .line 69
    new-instance v0, Landroid/database/MatrixCursor;

    invoke-direct {v0, v3}, Landroid/database/MatrixCursor;-><init>([Ljava/lang/String;)V

    .line 70
    new-array v3, v6, [Ljava/lang/String;

    aput-object v2, v3, v1

    invoke-virtual {v0, v3}, Landroid/database/MatrixCursor;->addRow([Ljava/lang/Object;)V

    .line 90
    :goto_79
    return-object v0

    .line 73
    :pswitch_7a
    invoke-virtual {p0}, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->getPidsAndprocessNames()Ljava/util/List;

    move-result-object v2

    .line 74
    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/List;

    iput-object v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->mPids:Ljava/util/List;

    .line 75
    invoke-interface {v2, v6}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/List;

    iput-object v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->mProcessNames:Ljava/util/List;

    .line 76
    const-string v4, ""

    .line 77
    const-string v0, ""

    move v2, v1

    move-object v3, v0

    .line 78
    :goto_94
    iget-object v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->mPids:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-ge v2, v0, :cond_e0

    .line 79
    iget-object v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->mPids:Ljava/util/List;

    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 80
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v4, ","

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 81
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v0, p0, Lcom/boyaa/cpu_usage/BTestPidCpuUsageProvider;->mProcessNames:Ljava/util/List;

    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v3, ","

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 78
    add-int/lit8 v0, v2, 0x1

    move v2, v0

    goto :goto_94

    .line 83
    :cond_e0
    new-array v2, v7, [Ljava/lang/String;

    const-string v0, "pids"

    aput-object v0, v2, v1

    const-string v0, "processNames"

    aput-object v0, v2, v6

    .line 84
    new-instance v0, Landroid/database/MatrixCursor;

    invoke-direct {v0, v2}, Landroid/database/MatrixCursor;-><init>([Ljava/lang/String;)V

    .line 85
    new-array v2, v7, [Ljava/lang/String;

    aput-object v4, v2, v1

    aput-object v3, v2, v6

    invoke-virtual {v0, v2}, Landroid/database/MatrixCursor;->addRow([Ljava/lang/Object;)V

    goto :goto_79

    .line 53
    nop

    :pswitch_data_fa
    .packed-switch 0x0
        :pswitch_25
        :pswitch_7a
    .end packed-switch
.end method

.method public readPidCpu(Ljava/util/List;)[D
    .registers 12
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List",
            "<",
            "Ljava/lang/Integer;",
            ">;)[D"
        }
    .end annotation

    .prologue
    const/4 v0, 0x0

    .line 119
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v1

    new-array v4, v1, [D

    .line 121
    :goto_7
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v1

    if-ge v0, v1, :cond_a0

    .line 122
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "/proc/"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-interface {p1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "/stat"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 123
    const/4 v3, 0x0

    .line 125
    :try_start_2b
    new-instance v2, Ljava/io/RandomAccessFile;

    const-string v5, "r"

    invoke-direct {v2, v1, v5}, Ljava/io/RandomAccessFile;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_32
    .catch Ljava/lang/Exception; {:try_start_2b .. :try_end_32} :catch_a3
    .catchall {:try_start_2b .. :try_end_32} :catchall_93

    .line 126
    :try_start_32
    const-string v1, ""

    .line 127
    new-instance v1, Ljava/lang/StringBuffer;

    invoke-direct {v1}, Ljava/lang/StringBuffer;-><init>()V

    .line 128
    const/4 v3, 0x0

    invoke-virtual {v1, v3}, Ljava/lang/StringBuffer;->setLength(I)V

    .line 129
    :goto_3d
    invoke-virtual {v2}, Ljava/io/RandomAccessFile;->readLine()Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_66

    .line 130
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v5, "\n"

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;
    :try_end_59
    .catch Ljava/lang/Exception; {:try_start_32 .. :try_end_59} :catch_5a
    .catchall {:try_start_32 .. :try_end_59} :catchall_a1

    goto :goto_3d

    .line 136
    :catch_5a
    move-exception v1

    .line 137
    :goto_5b
    :try_start_5b
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_5e
    .catchall {:try_start_5b .. :try_end_5e} :catchall_a1

    .line 138
    if-eqz v2, :cond_63

    .line 140
    :try_start_60
    invoke-virtual {v2}, Ljava/io/RandomAccessFile;->close()V
    :try_end_63
    .catch Ljava/io/IOException; {:try_start_60 .. :try_end_63} :catch_8e

    .line 121
    :cond_63
    :goto_63
    add-int/lit8 v0, v0, 0x1

    goto :goto_7

    .line 132
    :cond_66
    :try_start_66
    invoke-virtual {v1}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v3, " "

    invoke-virtual {v1, v3}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    .line 133
    const/16 v3, 0xd

    aget-object v3, v1, v3

    invoke-static {v3}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v6

    const/16 v3, 0xe

    aget-object v1, v1, v3

    invoke-static {v1}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v8

    add-double/2addr v6, v8

    .line 134
    aput-wide v6, v4, v0
    :try_end_83
    .catch Ljava/lang/Exception; {:try_start_66 .. :try_end_83} :catch_5a
    .catchall {:try_start_66 .. :try_end_83} :catchall_a1

    .line 138
    if-eqz v2, :cond_63

    .line 140
    :try_start_85
    invoke-virtual {v2}, Ljava/io/RandomAccessFile;->close()V
    :try_end_88
    .catch Ljava/io/IOException; {:try_start_85 .. :try_end_88} :catch_89

    goto :goto_63

    .line 141
    :catch_89
    move-exception v1

    .line 142
    invoke-virtual {v1}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_63

    .line 141
    :catch_8e
    move-exception v1

    .line 142
    invoke-virtual {v1}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_63

    .line 138
    :catchall_93
    move-exception v0

    move-object v2, v3

    :goto_95
    if-eqz v2, :cond_9a

    .line 140
    :try_start_97
    invoke-virtual {v2}, Ljava/io/RandomAccessFile;->close()V
    :try_end_9a
    .catch Ljava/io/IOException; {:try_start_97 .. :try_end_9a} :catch_9b

    .line 143
    :cond_9a
    :goto_9a
    throw v0

    .line 141
    :catch_9b
    move-exception v1

    .line 142
    invoke-virtual {v1}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_9a

    .line 147
    :cond_a0
    return-object v4

    .line 138
    :catchall_a1
    move-exception v0

    goto :goto_95

    .line 136
    :catch_a3
    move-exception v1

    move-object v2, v3

    goto :goto_5b
.end method

.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .registers 6

    .prologue
    .line 111
    const/4 v0, 0x0

    return v0
.end method
