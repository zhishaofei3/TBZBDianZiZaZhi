package core {
	import data.ConfigManager;
	import data.PageMode;
	import data.infos.BookInfo;

	import events.UIEvent;

	import flash.events.Event;

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

		private var currentPageNum:int;

		public function PageContainer() {
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		private function onStage(e:Event):void {
			stageW = stage.stageWidth;
			stageH = stage.stageHeight;
		}

		public function initData(bInfo:BookInfo):void {
			bookInfo = bInfo;
			currentPageNum = 0;
			createPage();
			this.x = (stage.stageWidth - BookWidth * 2) * 0.5;
			this.y = (stage.stageHeight - BookHeight) * 0.5;
			resize();
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0, 0, 10, 10);
			graphics.endFill();
		}

		private function createPage():void {
			singlePage = new SinglePage();
			singlePage.addEventListener(UIEvent.SINGLEPAGE_EVENT, onSingleEventHandler);
			addChild(singlePage);
//			singlePage.setPageInfo(pageInfo);
			doublePage = new DoublePage();
			doublePage.addEventListener(UIEvent.DOUBLEPAGE_EVENT, onDoubleEventHandler);
			addChild(doublePage);
			doublePage.setPageAndPageInfo(currentPageNum, currentPageNum + 1, bookInfo.pageInfoList[currentPageNum], bookInfo.pageInfoList[currentPageNum + 1]);
		}

		private function onSingleEventHandler(e:UIEvent):void {
			switch (e.data.type) {
				case "thumbnailImgLoadComplete":
					bookInfo.pageInfoList[e.data.pageNum].thumbnailImgBmp = e.data.thumbnailBmp;//缓存
					resize();
					break;
				case "bigImgLoadComplete":
					bookInfo.pageInfoList[e.data.pageNum].bigImgBmp = e.data.bigImgBmp;
					resize();
					break;
			}
		}

		private function onDoubleEventHandler(e:UIEvent):void {
			switch (e.data.type) {
				case "thumbnailImgLoadComplete":
					bookInfo.pageInfoList[e.data.pageNum].thumbnailImgBmp = e.data.thumbnailBmp;
					resize();
					break;
				case "bigImgLoadComplete":
					bookInfo.pageInfoList[e.data.pageNum].bigImgBmp = e.data.bigImgBmp;
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
				DisObjUtil.toStageCenter(this);
			}
		}
	}
}