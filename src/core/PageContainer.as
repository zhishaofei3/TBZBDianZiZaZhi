package core {
	import data.ConfigManager;
	import data.PageMode;
	import data.ZoomMode;
	import data.infos.BookInfo;

	import events.UIEvent;

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

		public function PageContainer() {
		}

		public function initData(bInfo:BookInfo):void {
			bookInfo = bInfo;
			currentPageNum = 1;
			createPage();
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

		private function createPage():void {
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
					bookInfo.pageInfoList[e.data.pageNum - 1].thumbnailImgBmp = e.data.thumbnailBmp;//缓存
					resize();
					break;
				case "bigImgLoadComplete":
					bookInfo.pageInfoList[e.data.pageNum - 1].bigImgBmp = e.data.bigImgBmp;
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
					resize();
					break;
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
				singlePage.setSize(w, h);
				DisObjUtil.toStageCenter(this);
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
				doublePage.setSize(w, h);
				this.x = (stageW - w) / 2;
				DisObjUtil.toStageYCenter(this);
			}
			singlePage.resize();
			doublePage.resize();
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
				dispatchEvent(new UIEvent(UIEvent.PAGECONTAINER_EVENT, {type: "page", page: PageContainer.currentPageNum}));
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
	}
}