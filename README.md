#WebViewProgressView
#这个是为了加载webview过程中显示一个进度条的类。

- (void)createProressLayer
{
CustomWebProgressLayer *layer = [[CustomWebProgressLayer alloc] init];
self.progressLayer = layer;
[layer release];

self.progressLayer.frame = CGRectMake(0, 64.f - 22.f, [ViewUtil screenWidth], 2.f);
}

webview start的时候加入下面的代码
[self.progressLayer startLoad];
webviw完成或失败的时候，调用下面的代码
[self.progressLayer finishedLoad];
