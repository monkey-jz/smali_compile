.class Lcom/boyaa/cpu_usage/BTestApplication$1;
.super Ljava/lang/Object;
.source "BTestApplication.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/boyaa/cpu_usage/BTestApplication;->onCreate()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/boyaa/cpu_usage/BTestApplication;


# direct methods
.method constructor <init>(Lcom/boyaa/cpu_usage/BTestApplication;)V
    .registers 2

    .prologue
    .line 29
    iput-object p1, p0, Lcom/boyaa/cpu_usage/BTestApplication$1;->this$0:Lcom/boyaa/cpu_usage/BTestApplication;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 5

    .prologue
    .line 32
    const-string v0, "STF_RAINBOWPT :"

    const-string v1, "BTestApplication onCreate ........"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 33
    iget-object v0, p0, Lcom/boyaa/cpu_usage/BTestApplication$1;->this$0:Lcom/boyaa/cpu_usage/BTestApplication;

    iget-object v1, p0, Lcom/boyaa/cpu_usage/BTestApplication$1;->this$0:Lcom/boyaa/cpu_usage/BTestApplication;

    invoke-virtual {v1}, Lcom/boyaa/cpu_usage/BTestApplication;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/boyaa/cpu_usage/BTestApplication;->isInstallApp(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_3c

    .line 34
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    .line 35
    new-instance v1, Landroid/content/ComponentName;

    const-string v2, "com.boyaa.perfor.pt"

    const-string v3, "com.boyaa.perfor.pt.MainActivity"

    invoke-direct {v1, v2, v3}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 36
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    .line 37
    const-string v1, "packageName"

    iget-object v2, p0, Lcom/boyaa/cpu_usage/BTestApplication$1;->this$0:Lcom/boyaa/cpu_usage/BTestApplication;

    invoke-virtual {v2}, Lcom/boyaa/cpu_usage/BTestApplication;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 38
    const/high16 v1, 0x10000000

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 39
    iget-object v1, p0, Lcom/boyaa/cpu_usage/BTestApplication$1;->this$0:Lcom/boyaa/cpu_usage/BTestApplication;

    invoke-virtual {v1, v0}, Lcom/boyaa/cpu_usage/BTestApplication;->startActivity(Landroid/content/Intent;)V

    .line 43
    :goto_3b
    return-void

    .line 41
    :cond_3c
    const-string v0, "STF_RAINBOWPT : "

    const-string v1, "RAINBOWPT apk is not installed"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_3b
.end method
