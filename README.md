## Bilibili评论统计工具



[工具说明](https://chaosinism.github.io/posts/comment-analyzer/)

[下载地址](https://github.com/Chaosinism/BilibiliCommentAnalyzer/releases)

![界面截图](https://chaosinism.github.io/posts/comment-analyzer/1.png)

目前的主要功能：
 - 统计指定视频的楼层数，并计数缺失的楼层，来推断有多少评论被举报或删除。
 - 展示评论的时间分布。
 - 按评论条数对评论人排序，并链接到他们的个人空间页面。
 - 导出包含所有评论信息的JSON文件。
 
已知的限制：
 - 无法得知评论消失的原因（相关API已被B站取消）。
 - 下载评论需要一定时间——评论文件并不小，1000条评论就有可能超过1M大小，请尽量避免分析评论数量极多的视频。
 
未知的限制：
 - 尚不知道B站是否\如何限制API的频繁调用。
