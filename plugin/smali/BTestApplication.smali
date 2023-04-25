.class public Lcom/boyaa/cpu_usage/BTestApplication;
.super Landroid/app/Application;
.source "BTestApplication.java"


# static fields
.field private static final ACTIVITY_NAME:Ljava/lang/String; = "com.boyaa.perfor.pt.MainActivity"

.field private static final MAIN_SERVICE_ACTION:Ljava/lang/String; = "com.boyaa.mainservice"

.field private static final PACK_NAME:Ljava/lang/String; = "com.boyaa.perfor.pt"


# direct methods
.method public constructor <init>()V
    .registers 1

    .prologue
    .line 16
    invoke-direct {p0}, Landroid/app/Application;-><init>()V

    return-void
.end method


# virtual methods
.method public isInstallApp(Landroid/content/Context;)Z
    .registers 7

    .prologue
    const/4 v2, 0x0

    .line 49
    invoke-virtual {p1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    .line 50
    invoke-virtual {v0, v2}, Landroid/content/pm/PackageManager;->getInstalledPackages(I)Ljava/util/List;

    move-result-object v3

    .line 51
    if-eqz v3, :cond_29

    move v1, v2

    .line 52
    :goto_c
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v0

    if-ge v1, v0, :cond_29

    .line 53
    invoke-interface {v3, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/pm/PackageInfo;

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    sget-object v4, Ljava/util/Locale;->ENGLISH:Ljava/util/Locale;

    invoke-virtual {v0, v4}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v0

    .line 54
    const-string v4, "com.boyaa.perfor.pt"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2a

    .line 55
    const/4 v2, 0x1

    .line 59
    :cond_29
    return v2

    .line 52
    :cond_2a
    add-int/lit8 v0, v1, 0x1

    move v1, v0

    goto :goto_c
.end method

.method public isMainProcess(Landroid/content/Context;)Z
    .registers 7

    .prologue
    .line 64
    const-string v0, "activity"

    invoke-virtual {p0, v0}, Lcom/boyaa/cpu_usage/BTestApplication;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/ActivityManager;

    .line 65
    invoke-virtual {v0}, Landroid/app/ActivityManager;->getRunningAppProcesses()Ljava/util/List;

    move-result-object v0

    .line 66
    invoke-virtual {p0}, Lcom/boyaa/cpu_usage/BTestApplication;->getPackageName()Ljava/lang/String;

    move-result-object v1

    .line 67
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v2

    .line 68
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_18
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_32

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/ActivityManager$RunningAppProcessInfo;

    .line 69
    iget v4, v0, Landroid/app/ActivityManager$RunningAppProcessInfo;->pid:I

    if-ne v4, v2, :cond_18

    iget-object v0, v0, Landroid/app/ActivityManager$RunningAppProcessInfo;->processName:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_18

    .line 70
    const/4 v0, 0x1

    .line 73
    :goto_31
    return v0

    :cond_32
    const/4 v0, 0x0

    goto :goto_31
.end method

.method public onCreate()V
    .registers 5

    .prologue
    .line 25
    invoke-super {p0}, Landroid/app/Application;->onCreate()V

    .line 28
    invoke-virtual {p0, p0}, Lcom/boyaa/cpu_usage/BTestApplication;->isMainProcess(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_18

    .line 29
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    new-instance v1, Lcom/boyaa/cpu_usage/BTestApplication$1;

    invoke-direct {v1, p0}, Lcom/boyaa/cpu_usage/BTestApplication$1;-><init>(Lcom/boyaa/cpu_usage/BTestApplication;)V

    const-wide/16 v2, 0x3e8

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 46
    :cond_18
    return-void
.end method
