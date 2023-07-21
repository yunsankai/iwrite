package cn.unipus.iwrite

import android.app.Application
import com.apm.insight.NpthInit
import com.bytedance.apm.insight.ApmInsight
import com.bytedance.apm.insight.ApmInsightInitConfig

import com.bytedance.applog.AppLog
import com.bytedance.applog.InitConfig
import com.bytedance.applog.UriConfig
import com.bytedance.applog.encryptor.EncryptorUtil
import com.bytedance.mpaas.IEncryptor
import com.bytedance.applog.*;

/**
 * @Author: cuishuxiang
 * @Date: 2022/1/7 10:40 上午
 * @Description:
 */
class MyApplication : Application() {

    companion object {
        lateinit var context: Application

        @JvmStatic
        fun getApplication(): Application {
            return context;
        }
    }

    override fun onCreate() {
        super.onCreate()
        context = this
    }

}