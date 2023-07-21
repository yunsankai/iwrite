package cn.unipus.unipus_iwrite.apm

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import cn.unipus.iwrite.GlobalConfig
import cn.unipus.iwrite.MyApplication
import com.apm.insight.NpthInit
import com.bytedance.apm.insight.ApmInsight
import com.bytedance.apm.insight.ApmInsightInitConfig
import com.bytedance.applog.AppLog
import com.bytedance.applog.InitConfig
import com.bytedance.applog.UriConfig
import com.bytedance.applog.encryptor.EncryptorUtil
import com.bytedance.mpaas.IEncryptor
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.lang.Exception
import java.util.*
import kotlin.collections.HashMap

/**
 * @Author: cuishuxiang
 * @Date: 2022/1/18 10:15 上午
 * @Description: 数据上报  flutter -> Android
 */
class DataRangerManager(flutterEngine: BinaryMessenger, context: Context) : MethodChannel.MethodCallHandler {

    private final val TAG = "DataRangerManager -> "

    private val mChannelName = "native_android_channel"

    private var mChannel: MethodChannel = MethodChannel(flutterEngine, mChannelName)

    private var mContext: Context = context


    private var isDebug = true

    private lateinit var mConfig: InitConfig


    //
    private lateinit var handler: Handler;


    init {
        mChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "onMethodCall call.method = ${call.method}")
        Log.d(TAG, "onMethodCall call.method = ${call.arguments.toString()}")

        if (call.method == "upload") {
            dealDataUpLoad(call)
        } else if (call.method == "isDebug"){
            dealIsDebug(call)
        }

        else {
            Log.d(TAG, "onMethodCall call.method 不支持的方法名 = ${call.arguments.toString()}")
        }
    }

    private fun dealIsDebug(call: MethodCall) {
        Log.d(TAG, "dealIsDebug 调用了。 ")
        if (call.arguments != null && call.arguments is Map<*, *>) {

            handler = Handler(Looper.getMainLooper());
            handler.postDelayed({
                var maps = call.arguments as Map<String, Any>

                if (maps.containsKey("isDebug")&&maps["isDebug"] is Boolean) {
                    GlobalConfig.isDebug = maps["isDebug"] as Boolean;
                    Log.d(TAG, "dealIsDebug GlobalConfig.isDebug = ${GlobalConfig.isDebug}")
                    if (!GlobalConfig.isDebug) {
                        //仅在正式环境初始化 apm
                        initDataRanger()

                        initApm()
                    }else{
                        Log.d(TAG, "dealIsDebug 测试包，不初始化 APM ")
                    }
                }
            }, 1000)
        }else{
            Log.d(TAG, "dealIsDebug 异常= ${call.arguments.toString()}")
        }
    }

    /**
     * flutter调 Android 原生，数据埋点上报
     */
    private fun dealDataUpLoad(call: MethodCall) {
        //数据上报
        if (call.arguments != null && call.arguments is Map<*, *>) {
            var maps = call.arguments as Map<String, Any>

            //调用原生上报
            val jsonObj = JSONObject()

            var eventName = ""
            try {
                for ((key, value) in maps) {
                    if (key == "event") {
                        eventName = value.toString()
                        continue
                    }
                    jsonObj.put(key, value)
                }

            } catch (e: Exception) {
                Log.e(TAG, "e = ${e.toString()}", e)
            }

            Log.d(TAG, "onMethodCall json数据为： ${jsonObj.toString()} , event = $eventName")

            //数据上报
            AppLog.onEventV3(eventName, jsonObj)
        }
    }


    /**
     * flutter 调 初始化（默认不初始化）
     */
    private fun initDataRanger() {
        // appid和渠道，appid如不清楚请联系客户成功经理
        mConfig = InitConfig(GlobalConfig.getDataFinderId(), "guanfang")
        mConfig.encryptor = IEncryptor { bytes: ByteArray?, i: Int -> EncryptorUtil.encrypt(bytes, i) }
        // 设置私有部署服务器地址
        // https://hive.data.fltrp.com 例如 https://yourdomain.com，注意域名后不要加“/”
        mConfig.uriConfig = UriConfig.createByDomain("https://hive.data.fltrp.com", null)
        // 是否在控制台输出日志，可用于观察用户行为日志上报情况
        if (GlobalConfig.isDebug) {
            mConfig.localTest = true
            mConfig.setLogger { s, throwable ->
                println("MyApplication $s ,  ${throwable?.toString()}")
//                XLog.d("$TAG  DataRanger_Fltrp 埋点：s  =$s    errorMsg = ${throwable?.message}")
            }
        }
//        mConfig.isAutoTrackEnabled = true
        // 开启AB测试
        mConfig.isAbEnable = true

        mConfig.setAutoStart(true)

        AppLog.init(MyApplication.getApplication(), mConfig)
    }


    private fun initApm() {
        val builder = ApmInsightInitConfig.builder()
        //设置分配的appid
        builder.aid("10000045")
        //是否开启卡顿功能
        builder.blockDetect(true)
        //是否开启严重卡顿功能
        builder.seriousBlockDetect(true)
        //是否开启流畅性和丢帧
        builder.fpsMonitor(true)
        //控制是否打开WebVeiw监控
        builder.enableWebViewMonitor(true)
        //控制是否打开内存监控
        builder.memoryMonitor(true)
        //是否打印日志，注：线上release版本要配置为false
        builder.debugMode(true)
        //配置数据上报的域名 （私有化部署才需要配置，内部有默认域名）
        builder.defaultReportDomain("https://hive.data.fltrp.com")
        ApmInsight.getInstance().init(MyApplication.getApplication(), builder.build())

        /**
         * ApmInsight崩溃监控初始化
         *
         * id     : 10000045
         * App Key:  ec6cfabd1cafac289f3bf8c1ad05420c
         * URL Scheme : rangersapplog.63f65ee2726d21db
         */


        val crash = NpthInit.init(MyApplication.getApplication(), mConfig)
//        crash.setCustomDataCallback(new AttachUserData() {
//            @Nullable
//            @Override
//            public Map<? extends String, ? extends String> getUserData(CrashType crashType) {
//                return null;
//            }
//        }).config().setChannel("");
        crash!!.config().setChannel("") //设置渠道...


        crash.setReportUrl("https://hive.data.fltrp.com") // 私有化部署专用, 否则不要动

//        crash.addTags(key, value); // 自定义筛选tag, 按需添加、可多次覆盖
    }
}