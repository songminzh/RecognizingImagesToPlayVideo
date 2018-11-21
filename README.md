![卧闻海棠花](https://upload-images.jianshu.io/upload_images/2251123-7af2c7a08693ad96.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


ARKit为iOS系统提供了对图像的识别功能。可通过检测用户环境中的已知2D图像，使用其位置放置AR内容。其中的AR内容可以是一个立体模型，也可以是一张图片或一个视频。

这一功能必将使得未来的app更加有趣，也让我们有了新的实现形式，让我们来尝试一下基于ARkit的图片识别功能在app内播放视频吧。

> 环境：iOS 11.3+ | Xcode 10.0+ 
> Framework：ARkit

`注意`
>在本项目中，由于要用到相机，所以需要到info.plist中添加Privacy - Camera Usage Description

至此，我们就能简单地实现利用ARKit识别图像并播放对应的视频。

其中的视频文件可前往[这里](http://img.dpm.org.cn/Uploads/File/2018/04/19/haitang.mp4)下载，当然，你也可以相应修改项目中配置更换你的目标图像和视频文件。
