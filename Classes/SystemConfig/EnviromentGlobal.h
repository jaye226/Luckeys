
#define KAIKAIBA_ENVIRONMENT 1 //iOS网络框架环境 0:int 内网环境 1:stg1 外网环境

/*********************内网环境*********************/
#if KAIKAIBA_ENVIRONMENT==0

#define HeadHost @"http://"

#define SeverHost @"192.168.1.101:8080/luckeys"

#define localSeverHose "localhost:8081/luckeys"

/*********************外网环境*********************/
#elif KAIKAIBA_ENVIRONMENT==1

#define HeadHost @"http://"

#define SeverHost @"120.55.241.27:8080/luckeys"

#define localSeverHose "localhost:8080/luckeys"

#endif

#define kRequest_TimeOut    @"网络不太给力,请稍后尝试"
#define kRequestUrl         @"kRequestUrl"
#define kRequestBody        @"kRequestBody"


#pragma mark -API url
/*********************接口定义*********************/

/** 请求当前页key */
#define kLKCurPage   @"curPage"

/** 每页请求的数据条数 */
#define kLKPageSize  @"15"

/**
 *  获取验证码
 *
 *  url带参 userPhone
 */
#define kURL_GetPhoneCode   @"user/registered?"

/**
 *  注册
 *
 *  body带参  codes,userPhone,password
 */
#define kURL_Register       @"user/registeredUser"

/**
 *  登录
 *
 *  url带参   userName,password
 */
#define kURL_Login          @"/user/doLogin?"

/**
 *  上传DeviceToken
 *  body：iosDeviceToken，userUuid
 */
#define kURL_AddDeviceToken @"user/addDeviceToken"

/**
 *  更新头像
 *  userUuid
 */
#define kURL_UploadPhoto     @"/user/updateHead"

/**
 *   忘记密码
 *   body带参 codes,userPhone,password
 */
#define kURL_ResetPassword    @"/user/resetPassword"

/**
 *  首页数据
 *
 *  body带参 startIndex，pageSize，cityName(默认深圳)
 */
#define kURL_HomePageData     @"activity/queryIosPage"

/**
 *  个人中奖信息
 */
#define kURL_GetPrize          @"activity/queryWinByUserId"

/**
 *  修改个人信息
 */
#define kURL_ModifyPersonData  @"user/updateUser"

/**
 *  分类数据
 *  body : activityTypeUuid,orderBy,startIndex,pageSize,cityName
 */
#define KURL_TypeList       @"activity/queryIosPage"

/**
 *  商品详情
 *
 *  body带参 activityUuid，userUuid
 */
#define kURL_ActivityDetail   @"activity/queryIosActivityById"

/**
 *  收藏或取消
 *  body : activityUuid,iLike(0：收藏，1：取消)
 */
#define kURL_CollectionActivity   @"activity/operCollection"

/**
 *  收藏列表
 *  body: startIndex,pageSize
 */
#define kURL_CollectionList   @"activity/queryCollectPage"

/**
 *  活动抽奖码列表
 *
 *  body带参 activityUuid
 */
#define kURL_QueryCodeList   @"activity/queryCodeList"

/**
 *  投注
 *
 *  body带参 codeUuid,userUuid
 */
#define kURL_BetCode   @"activity/betCode"

/**
 *  中奖信息列表
 *
 *  url带参 codeUuid
 */
#define kURL_QueryWinByUserId   @"activity/queryWinByUserId"

/**
 *  历史投注信息
 *
 *  body带参 codeUuid
 */
#define kURL_QueryBetByUserId   @"activity/queryBetByUserId"

/**
 *  活动评论列表
 *
 *  body带参 codeUuid,curPage,pageSize
 */
#define kURL_CommentPage   @"activity/queryCommentPage"

/**
 *  活动评论
 *
 *  body带参 activityUuid,description,userUuid
 */
#define kURL_AddComment   @"activity/addComment"

/**
 *  是否有用
 *
 *  body带参 commentUuid,userUuid
 */
#define kURL_AddUse     @"activity/addUse"

/** 
 *  获取个人信息
 *  body 带参userUuid
 */
#define kURL_UserInfo @"user/queryIosUserById"

/**
 *  对中奖人点赞
 *
 *  body带参 userUuid,codeUuid
 */
#define kURL_PraiseWin     @"activity/praiseWin"

/**
 *  详情点赞人列表
 *
 *  body带参 codeUuid
 */
#define kURL_QueryPraisePage    @"activity/queryPraisePage"

/**
 *  获取城市列表
 *
 *  body带参 curPage、pageSize
 */
#define kURL_QueryIosCityPage    @"city/queryIosList"

/**
 *  分享评论
 *
 *  body带参 activityUuid、userUuid、comment
 */
#define kURL_ShareActivity    @"activity/shareActivity"

/**
 *  生成预付订单
 *
 *  body带参activityName、description、unitPrice、bets
 */
#define kUrl_PrepaidOrders    @"activity/pay"

/**
 *  朋友圈
 *
 *  body带参userUuid、pageSize、curPage
 */
#define kUrl_QuerySharePage    @"activity/querySharePage"

/**
 *  微信支付成功
 *
 *  body带参prepayId、activityUuid
 */
#define kUrl_PaySuccess    @"activity/paySuccess"

/**
 *  支付宝
 *
 *  body带参activityName、unitPrice、bets、description
 */
#define kUrl_Alipay    @"activity/alipay"

/**
 *  未完成订单
 *
 *  body带参userUuid
 */
#define kUrl_QueryOrderList    @"activity/queryOrderList"

