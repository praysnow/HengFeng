//
//  HFInterFace.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 24/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

@interface HFInterFace : NSObject

/* HOST */

#define HOST [HFNetwork network].ServerAddress

/* Login InterFace */
#define LOGIN_INTERFACE @"/webService/WisdomClassWS.asmx?op=CheckUser"
#define DAOXUEAN_INTERFACE @"/webService/WisdomClassWS.asmx?op=GetDaoXueRenWuByTpID"
#define DAOXUETANG_INTERFACE @"/webService/WisdomClassWS.asmx?op=GetCourseResByTpID"
#define GETTASKLIST @"/webService/HuDongKeTang/TeacherInfo.asmx?op=getTaskList"

/*
 Notification
 //开始侧滑
 */

#define START_SLIDE @"START_SLIDE"


/* login name cache user default */

/*  UserDefault  */

#define ADDRESS_HOST @"address_host"

#define LOGIN_INFO_CACHE @"LOGIN_INFO_CACHE"

typedef NS_ENUM(NSUInteger, MATMatchDetailDataLoadedType) {
    MATMatchDetailDataLoadedTypeNone = 0,
    MATMatchDetailDataLoadedTypeHeader = 1 << 0,
    MATMatchDetailDataLoadedTypeVideoLive = 1 << 1,
};

/**
  获取指令值的key
 **/
 #define CommandCode  @"CommandCode"
/**
 * 获取指令值的key
 */
#define RECEVIEDVALUE  @"value"
/**
 * True指令
 */
#define COMMANDTRUE  @"True"
/**
 * true指令
 */
#define COMMAND_SMALL_TRUE  @"true"
/**
 * false指令
 */
#define COMMAND_SMALL_FALSE  @"false"
/**
 * False指令
 */
#define COMMAND_BIG_FALSE  @"False"
/**
 * 获取指令值的key
 */
#define COMMAND_KEY  @"key"
/**
 * 来自教师端的指令
 */
#define COMMAND_SEND_TO_CTRL  @"SendToCtrl"
/**
 * 取得教师信息
 */
#define COMMAND_SEND_TO_TEACHER_INFO  @"SendTeacherInfo"
/**
 * 在线学生列表
 */
#define COMMAND_LIST_USERS  @"ListUsers"
/**
 * 开始抢答
 */
#define START_AWSER  @"13"
/**
 * 结束抢答
 */
#define END_AWSER  @"14"
/**
 * 开始举手
 */
#define START_HANDS_UP  @"15"
/**
 * 开始教学分享
 */
#define START_TESCH_SHARE  @"16"
/**
 * 结束教学分享
 */
#define END_TESCHER_SHARE  @"17"
/**
 * 锁屏
 */
#define LOCK_SCREEN  @"18"
/**
 * 解锁屏
 */
#define UNLOCK_SCREEN  @"19"
/**
 * 关闭截屏遮罩
 */
#define CLOSE_SCREEN  @"24"
/**
 * 打开ppt
 */
#define OPENPPE_PPE  @"32"
/**
 * 课堂测试查看结果
 */
#define CLASS_TEST_SHOW_RESULT  @"37"
/**
 * 课堂测试互评
 */
#define CLASS_TEST_RECOMMEND_ESCH  @"38"
/**
 * 课堂测试一键收卷
 */
#define CLASS_TEST_END  @"39"
/**
 * 课堂测试 删除
 */
#define CLASS_TEST_DELETE  @"40"
/**
 * 截屏
 */
#define SCREEN_CAPTURE  @"43"
/**
 * 发送截屏结果计时
 */
#define SCREEN_CAPTURE_TIME  @"44"
/**
 * 发送截屏结果不计时
 */
#define SCREEN_CAPTURE_UNTIME  @"45"
/**
 * 截屏结果 打开图片
 */
#define OPEN_PICTURE  @"46"
/**
 * 截屏结果 打开图片
 */
#define OPEN_PICTURE_DECOND  @"47"
/**
 * 停止截屏
 */
#define STOP_SCREEN_CAPTURE  @"49"
/**
 * 上屏
 */
#define UP_SCREEN  @"60"
/**
 * 移动直播开始
 */
#define START_LIVE  @"61"
/**
 * 移动直播停止
 */
#define END_LIVE  @"62"
/**
 * 计时下发
 */
#define SEND_DOWN_TIME  @"80"
/**
 * 不计时下发
 */
#define SEND_DOWN_UNTIME  @"81"
/**
 * 截屏 不计时下发
 */
#define SEND_DOWN_UNTIME_SECOND  @"89"
/**
 * 获取班级信息
 */
#define GET_CLASS_INFO  @"111"
/**
 * 批注
 */
#define RECOMMEND  @"112"
/**
 * 关闭批注
 */
#define CLOSE_RECOMMEND  @"113"
/**
 * 写批注
 */
#define WRITER_RECOMMEND  @"114"
/**
 * 截屏测验随机抽取
 */
 #define SCREEN_CAPTURE_RANDOM  @"115"
/**
 * 结束截屏打开的子窗体
 */
#define CLOSE_CAPTURE_WINDOW  @"116"
/**
 * 下发指令
 */
#define GET_INFO_CLASS  @"117"
/**
 * 投票
 */
#define RECOMMEND_VOTE  @"118"

/**
 * 随机提问
 */
 #define START_ASK_RANDOM  @"120"
/**
 * 停止提问
 */
 #define END_ASK_RANDOM @"121"
/**
 * 关闭举手
 */
#define CLOSE_HANDS_UP  @"122"
/**
 * 单选多选切换
 */
#define SINGLE_OR_DOUBLE_CHANGLE  @"123"
/**
 * 开始投票/重新投票124
 */
#define START_OR_RESTART_VOTE  @"124"
/**
 *查看投票结果125
 */
#define SHOW_RESULT_VOTE  @"125"
/**
 *投票未提交126
 */
#define UN INPUT_VOTE_RESULT  @"126"
/**
 *导学案详情测试计时下发
 */
#define DAOXUEAN_DETAIL_TIME  @"127"
/**
 *导学案详情测试不计时下发
 */
#define DAOXUEAN_DETAIL_UNTIME  @"128"
/**
 *结束我的资源详情下发
 */
#define DAOXUEAN_DETAIL_SEND_STOP  @"129"
/**
 *ppt右翻页132
 */
#define PPT_RIGHT_PAGE  @"130"
/**
 *ppt左翻页133
 */
#define PPT_LEFT_PAGE  @"131"
/**
 *关闭ppt134
 */
#define PPT_CLOSE_PAGE  @"132"
/**
 *结束我的资源下发
 */
#define STOP_MY_SOURCE_SEND  @"134"
/**
 * 停止投票
 */
#define STOP_VOTE_STATUE  @"135"
/**
 *我的资源详情查看结果
 */
#define MY_SOURCE_SEND_INFO_SHOW  @"136"
/**
 *结束我的资源详情查看结果
 */
#define STOP_MY_SOURCE_SEND_INFO @"137"
/**
 *截屏下发 互评
 */
#define SCREEN_CAPTURE_RECOMMEND  @"138"
/**
 *截屏下发 查看互评结果
 */
#define SCREEN_CAPTURE_RECOMMEND_RESULT  @"139"
/**
 *结束上屏
 */
#define STOP_UP_SCREEN  @"140"
/**
 *教学点评
 */
#define TERCH_RECOMMEND  @"133"
/**
 *关闭教学点评
 */
#define CLOSE_TERCH_RECOMMEND  @"134"
/**
 *随堂测验结束
 */
#define CLASSING_TEST_END  @"StopPaperSky"
/**
 *教师端发送课堂测试内容
 */
#define TEACHER_CLIENT_SEND_CLASS_TEST_CONTENT  @"SendPaperSky"
/**
 *加载网页数据
 */
#define LOADING_WEBVIEW_DATA  @"ShowParamsUrl"
/**
 *加载网页数据
 */
#define CLOSE_WEBVIEW_DATA  @"ClosePageUrl"
/**
 *下发截屏成功
 */
#define SEND_CAPTURE_SCUESS  @"PadViewImage"
/**
 *截屏测验提交
 */
#define CAPTURE_TEST_IMAGE_COMMIT  @"CommitViewImage"
/**
 *截屏测验学生提交视频数据
 */
#define CAPTURE_TEST_VIDEO_COMMIT  @"SendTeacherMovie"
/**
 *截屏测验学生提交图片数据
 */
#define CAPTURE_TEACHER_VIDEO_COMMIT  @"SendTeacherImage"
/**
 *教师端发送停止截屏
 */
#define CAPTURE_TEACHER_VIDEO_COMMIT_STOP  @"ForceCloseScreenTest"
/**
 *教师端发送停止教学分享
 */
#define CAPTURE_TEACHER_VIDEO_COMMIT_STOP_STATUS  @"EndBrocastDesktop"
/**
 *教师端发送开始教学分享
 */
#define CAPTURE_TEACHER_VIDEO_COMMIT_BEGIN  @"BrocastDesktop"
/**
 *教师端发送锁屏解锁指令
 */
#define LOCK_SCREEN_SENT  @"LockScreen"
/*
 *教师端发送开始抢答指令
 */
#define TEACHER_SENT_ANSWER_START  @"BeginRacing"
/**
 *教师端发送结束抢答指令
 */
#define TEACHER_SENT_ANSWER_STOP  @"EndRacing"
/**
 *教师端发送投票成功
 */
#define TEACHER_SENT_VOTE_SUCCESS  @"SendFormatQuestion"
/**
 *教师端发送投票结束
 */
#define TEACHER_SENT_VOTE_END  @"CloseFormatQuestion"
/**
 *教师端发送举手开始
 */
#define TEACHER_CLIENT_SEND_HANGSUP_START  @"TurnOnHandup"
/**
 *教师端发送举手开始
 */
#define TEACHER_CLIENT_SEND_HANGSUP_END  @"TurnOffHandup"
/**
 *清除举手
 */
#define TEACHER_CLIENT_SEND_HANGSUP_CLEAR  @"ClearAllHands"
/**
 *提交测试
 */
#define RECOMMEND_TEST  @"CommitTest"
/**
 *获取教师端socket状态
 */
#define GET_TEACHER_STATUS  @"ReponseXmlState"
/**
 *教师端关闭推流
 */
#define TEACHER_CLOSER_LIVEING  @"CloseRtmp"

//导学案类型
#define AfterClassExercise @"课后布置作业"
#define DAOXUEAN_AfterClassMaterialLearning @"课后资料学习"
#define DAOXUEAN_AfterClassMicrolecture @"课后微课学习"
#define DAOXUEAN_AfterClassYouke @"课后优课学习"
#define DAOXUEAN_BeforeClassExercise @"课前预习评测"
#define DAOXUEAN_BeforeClassMaterialLearning @"课前资料学习"
#define DAOXUEAN_BeforeClassYouke @"课前优课学习"
#define DAOXUEAN_BeforeMicrolecture @"课前微课学习"
#define DAOXUEAN_Cooperation @"合作探究"
#define DAOXUEAN_Ebook @"电子课本"
#define DAOXUEAN_Expansion @"拓展延伸"
#define DAOXUEAN_Flash @"FLASH学习资料"
#define DAOXUEAN_ImageHomework @"图片作业"
#define DAOXUEAN_InClassExercise @"课中达标检测"
#define DAOXUEAN_InClassMaterialLearning @"课中资料学习"
#define DAOXUEAN_InClassMicrolecture @"课中微课学习"
#define DAOXUEAN_InClassYouke @"课中优课学习"
#define DAOXUEAN_Key_Difficulty @"学习重点难点"
#define DAOXUEAN_KnowledgeBedding @"知识铺垫"
#define DAOXUEAN_LearningEvaluation @"导学评价"
#define DAOXUEAN_LearningReflection @"学生学习反思"
#define DAOXUEAN_LiveClass @"直播课堂"
#define DAOXUEAN_Method_Instruction @"学法指导"
#define DAOXUEAN_Microlecture @"微课学习"
#define DAOXUEAN_MindMap @"思维导图"
#define DAOXUEAN_Questionnaire_Vote @"调查问卷和投票"
#define DAOXUEAN_Scenario @"情景导入"
#define DAOXUEAN_StandardTest @"达标检测"
#define  DAOXUEAN_Target @"学习目标"
#define  DAOXUEAN_TeachingReflection @"教师教学反思"
#define  DAOXUEAN_TopicMap @"教具准备主题图"

@end
