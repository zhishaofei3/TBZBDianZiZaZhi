package core {
	import data.ConfigManager;
	import data.PageMode;
	import data.infos.BookInfo;

	import events.UIEvent;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	import ui.DoublePage;
	import ui.SinglePage;

	import utils.common.component.display.AbstractDisplayObject;
	import utils.common.util.DisObjUtil;

	/**
	 * 电子书页容器
	 * Created by 同步周报阅读器.
	 * User: zhishaofei
	 * Date: 14-5-13
	 * Time: 上午12:30
	 */
	public class PageContainer extends AbstractDisplayObject {
		public static var BookWidth:int = 300;
		public static var BookHeight:int = 450;

		public static var DEFAULT_HEIGHT:int = 600;

		public static var stageW:int = 0;
		public static var stageH:int = 0;

		private var singlePage:SinglePage;
		private var doublePage:DoublePage;

		private var bookInfo:BookInfo;

		public static var currentPageNum:int;

		public static var uiZoomIn:UI_ZoomIn;
		public static var uiZoomOut:UI_ZoomOut;

		public function PageContainer() {
			uiZoomIn = new UI_ZoomIn();
			uiZoomOut = new UI_ZoomOut();
		}

		public function initData(bInfo:BookInfo):void {
			bookInfo = bInfo;
			currentPageNum = 1;
			createPage();
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
			this.x = (stage.stageWidth - BookWidth * 2) * 0.5;
			this.y = (stage.stageHeight - BookHeight) * 0.5;
			resize();
//			var info:PageInfo = new PageInfo("http://misimg.51tbzb.cn/PdfInfoFiles/thumbnail/248_363/2014-04-19/c47c619416e15f7c572fe148d643ae52.jpg?" + Math.random(), "http://misimg.51tbzb.cn/PdfInfoFiles/2014-04-19/3592_2014041916433200.jpg?" + Math.random());
//			doublePage.setPageAndPageInfo(currentPageNum, currentPageNum + 1, info, bookInfo.pageInfoList[currentPageNum + 1]);
			if (ConfigManager.pageMode == PageMode.SINGLE) {
				singlePage.setPageAndPageInfo(currentPageNum, bookInfo.pageInfoList[currentPageNum - 1]);
			} else {
//				doublePage.setPageAndPageInfo(currentPageNum, info, info);
				doublePage.setPageAndPageInfo(currentPageNum, bookInfo.pageInfoList[currentPageNum - 1], bookInfo.pageInfoList[currentPageNum]);
			}
		}

		private function onMouseWheelHandler(e:MouseEvent):void {
			singlePage.onMouseWheel(e);
			doublePage.onMouseWheel(e);
		}

		private function createPage():void {
			if(singlePage){
				singlePage.removeEventListener(UIEvent.SINGLEPAGE_EVENT, onSingleEventHandler);
				singlePage.clear();
				removeChild(singlePage);
			}
			if(doublePage){
				doublePage.removeEventListener(UIEvent.DOUBLEPAGE_EVENT, onDoubleEventHandler);
				doublePage.clear();
				removeChild(doublePage);
			}
			singlePage = new SinglePage();
			singlePage.addEventListener(UIEvent.SINGLEPAGE_EVENT, onSingleEventHandler);
			addChild(singlePage);
			doublePage = new DoublePage();
			doublePage.addEventListener(UIEvent.DOUBLEPAGE_EVENT, onDoubleEventHandler);
			addChild(doublePage);
		}

		public function refrush():void {
			singlePage.clear();
			doublePage.clear();
			if (ConfigManager.pageMode == PageMode.SINGLE) {
				singlePage.setPageAndPageInfo(currentPageNum, bookInfo.pageInfoList[currentPageNum - 1]);
			} else if (ConfigManager.pageMode == PageMode.DOUBLE) {
				if (currentPageNum != bookInfo.totalPageNum) {
					trace("是双页");
					doublePage.setPageAndPageInfo(currentPageNum, bookInfo.pageInfoList[currentPageNum - 1], bookInfo.pageInfoList[currentPageNum]);
				} else {
					trace("是最后的单页");
					doublePage.setPageAndPageInfo(currentPageNum, bookInfo.pageInfoList[currentPageNum - 1]);
				}
			}
		}

		private function onSingleEventHandler(e:UIEvent):void {
			switch (e.data.type) {
				case "thumbnailImgLoadComplete":
					if (e.data.pageNum == 0) {
						bookInfo.answer.thumbnailImgBmp = e.data.thumbnailImgBmp;
					} else {
						bookInfo.pageInfoList[e.data.pageNum - 1].thumbnailImgBmp = e.data.thumbnailBmp;//缓存
					}
					resize();
					break;
				case "bigImgLoadComplete":
					if (e.data.pageNum == 0) {
						bookInfo.answer.bigImgBmp = e.data.bigImgBmp;
					} else {
						bookInfo.pageInfoList[e.data.pageNum - 1].bigImgBmp = e.data.bigImgBmp;
					}
					resize();
					break;
			}
		}

		private function onDoubleEventHandler(e:UIEvent):void {
			switch (e.data.type) {
				case "thumbnailImgLoadComplete":
					bookInfo.pageInfoList[e.data.pageNum - 1].thumbnailImgBmp = e.data.thumbnailBmp;//缓存
					resize();
					break;
				case "bigImgLoadComplete":
					bookInfo.pageInfoList[e.data.pageNum - 1].bigImgBmp = e.data.bigImgBmp;
					if (e.data.pageNum == 1) {
						for (var i:int = 2; i < bookInfo.pageInfoList.length; i++) {//缓存剩余页的小图
							var thumbnailsLoader:Loader = new Loader();
							thumbnailsLoader.name = String(i);
							thumbnailsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadThumbnailComplete);
							thumbnailsLoader.load(new URLRequest(bookInfo.pageInfoList[i].thumbnailURL));
						}
						var answerThumbnailsLoader:Loader = new Loader();
						answerThumbnailsLoader.name = "answerThumbnail";
						answerThumbnailsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadThumbnailComplete);
						answerThumbnailsLoader.load(new URLRequest(bookInfo.answer.thumbnailURL));
					}
					resize();
					break;
				case "reCenter":
					resize();
			}
		}

		private function onLoadThumbnailComplete(e:Event):void {
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadThumbnailComplete);
			var index:String = loaderInfo.loader.name;
			if (index == "answerThumbnail") {
				bookInfo.answer.thumbnailImgBmp = loaderInfo.content as Bitmap;
			} else {
				bookInfo.pageInfoList[index].thumbnailImgBmp = loaderInfo.content as Bitmap;
			}
		}

		public function resize():void {
			var w:Number, h:Number;
			if (ConfigManager.pageMode == PageMode.SINGLE) {
				if (stageW > stageH) {
					h = stageH;
					w = h * 0.7;
					if (w > stageW) {
						w = stageW;
						h = w / 0.7;
					}
				} else {
					w = stageW;
					h = w / 0.7;
					if (h > stageH) {
						h = stageH;
						w = h * 0.7;
					}
				}
				if (singlePage) {
					singlePage.setSize(w, h);
					singlePage.reset();
				}
				DisObjUtil.toStageCenter(singlePage);
			} else if (ConfigManager.pageMode == PageMode.DOUBLE) {
				if (stageW > stageH) {
					h = stageH;
					w = h * 1.4;
					if (w > stageW) {
						w = stageW;
						h = w / 1.4;
					}
				} else {
					w = stageW;
					h = w / 1.4;
					if (h > stageH) {
						h = stageH;
						w = h * 1.4;
					}
				}
				if (doublePage) {
					doublePage.setSize(w, h);
					doublePage.reset();
				}
				this.x = (stageW - w) / 2;
				DisObjUtil.toStageYCenter(doublePage);
			}
			if (singlePage) {
				singlePage.resize();
			}
			if (doublePage) {
				doublePage.resize();
			}
		}

		public function prev():void {
			if (ConfigManager.pageMode == PageMode.SINGLE) {
				if (currentPageNum != 1) {
					currentPageNum--;
				}
			} else if (ConfigManager.pageMode == PageMode.DOUBLE) {
				if (currentPageNum > 2) {
					currentPageNum -= 2;
				}
			}
			dispatchEvent(new UIEvent(UIEvent.PAGECONTAINER_EVENT, {type: "page", page: PageContainer.currentPageNum}));
			refrush();
		}

		public function next():void {
			if (ConfigManager.pageMode == PageMode.SINGLE) {
				if (currentPageNum < bookInfo.totalPageNum) {
					currentPageNum++;
				}
			} else if (ConfigManager.pageMode == PageMode.DOUBLE) {
				if (currentPageNum + 2 <= bookInfo.totalPageNum) {
					currentPageNum += 2;
				} else {
					return;
				}
			}
			dispatchEvent(new UIEvent(UIEvent.PAGECONTAINER_EVENT, {type: "page", page: PageContainer.currentPageNum}));
			refrush();
		}

		public function zoomIn():void {
			if (ConfigManager.pageMode == PageMode.SINGLE) {
				singlePage.zoomIn();
			}
			if (ConfigManager.pageMode == PageMode.DOUBLE) {
				doublePage.zoomIn();
			}
		}

		public function zoomOut():void {
			if (ConfigManager.pageMode == PageMode.SINGLE) {
				singlePage.zoomOut();
			}
			if (ConfigManager.pageMode == PageMode.DOUBLE) {
				doublePage.zoomOut();
			}
		}

		public function huanyuan():void {
			if (ConfigManager.pageMode == PageMode.SINGLE) {
				singlePage.huanyuan();
			}
			if (ConfigManager.pageMode == PageMode.DOUBLE) {
				doublePage.huanyuan();
			}
		}

		public function showAnswer():void {
			singlePage.clear();
			doublePage.clear();
			singlePage.setPageAndPageInfo(0, bookInfo.answer);
		}
	}
}