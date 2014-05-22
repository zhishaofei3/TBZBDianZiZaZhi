package core {

	import data.ConfigManager;
	import data.PageMode;
	import data.infos.BookInfo;

	import events.UIEvent;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.ui.Keyboard;

	import scenes.LayerManager;

	public class BookManager {
		private static var pageContainer:PageContainer;
		private static var toolBarManager:ToolBarManager;
		public static var bookInfo:BookInfo;

		public function BookManager() {
		}

		public static function init():void {
			ExternalInterface.addCallback("showAnswer", showAnswer);
			initUI();
			TBZBMain.st.addEventListener(Event.RESIZE, onResizeHandler);
		}

		public static function showAnswer():void {
			if (pageContainer) {
				ConfigManager.pageMode = PageMode.SINGLE;
				pageContainer.showAnswer();
//				toolBarManager.setCurrentPage(PageContainer.currentPageNum);
			}
		}

		public static function onResizeHandler(e:Event):void {
			PageContainer.stageW = TBZBMain.st.stageWidth;
			PageContainer.stageH = TBZBMain.st.stageHeight;
			pageContainer.resize();
			toolBarManager.resize();
			LayerManager.bgContainer.width = PageContainer.stageW;
			LayerManager.bgContainer.height = PageContainer.stageH;
		}

		private static function initUI():void {
			toolBarManager = new ToolBarManager();
			toolBarManager.addEventListener(UIEvent.TOOLBARMANAGER_EVENT, onToolBarEvent);
			initBook();
		}

		public static function initBook():void {
			pageContainer = new PageContainer();
			pageContainer.addEventListener(UIEvent.PAGECONTAINER_EVENT, onPageContainerEvent);
			LayerManager.bookContainer.addChild(pageContainer);
			TBZBMain.st.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		}

		private static function onKeyDownHandler(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case Keyboard.LEFT:
					pageContainer.prev();
					break;
				case Keyboard.RIGHT:
					pageContainer.next();
					break;
				default :
					break;
			}
		}

		private static function onPageContainerEvent(e:UIEvent):void {
			switch (e.data.type) {
				case "page":
					toolBarManager.setCurrentPage(e.data.page);
					ExternalInterface.call("flashCallJs", "fanye", e.data.page);
					break;
			}
		}

		public static function setBookConfig(bInfo:BookInfo):void {
			bookInfo = bInfo;
			toolBarManager.setTotalPage(bInfo.totalPageNum);
			toolBarManager.setBookName(bInfo.gradeName + "(" + bInfo.version + ")" + " " + bInfo.year + "年 第" + bInfo.perNum + "期");
			toolBarManager.setNeighbor(bInfo.neighbor);
			pageContainer.initData(bInfo);
			toolBarManager.setCurrentPage(PageContainer.currentPageNum);
			if (bookInfo.answer.bigURL == "") {
				toolBarManager.setDatiBtnVisible(false);
			} else {
				toolBarManager.setDatiBtnVisible(true);
			}
		}

		private static function onToolBarEvent(e:UIEvent):void {
			switch (e.data.type) {
				case "dati":
					ExternalInterface.call("flashCallJs", "dati");
					if (ConfigManager.pageMode == PageMode.SINGLE) {
						return;
					}
					ConfigManager.pageMode = PageMode.SINGLE;
					toolBarManager.changeModeTypeString();
					toolBarManager.setCurrentPage(PageContainer.currentPageNum);
					pageContainer.refrush();
					break;
				case "single":
					ConfigManager.pageMode = PageMode.SINGLE;
					toolBarManager.setCurrentPage(PageContainer.currentPageNum);
					toolBarManager.changeModeTypeString();
					pageContainer.refrush();
					ExternalInterface.call("flashCallJs", "exitDati");
					break;
				case "double":
					if (PageContainer.currentPageNum % 2 == 0) {//偶数页先变成 单数页
						PageContainer.currentPageNum--;
					}
					toolBarManager.setCurrentPage(PageContainer.currentPageNum);
					ConfigManager.pageMode = PageMode.DOUBLE;
					toolBarManager.changeModeTypeString();
					pageContainer.refrush();
					ExternalInterface.call("flashCallJs", "exitDati");
					break;
				case "zoomIn":
					pageContainer.zoomIn();
					break;
				case "zoomOut":
					pageContainer.zoomOut();
					break;
				case "huanyuan":
					pageContainer.huanyuan();
					break;
				case "prev":
					pageContainer.prev();
					ExternalInterface.call("flashCallJs", "prev");
					break;
				case "next":
					pageContainer.next();
					ExternalInterface.call("flashCallJs", "next");
					break;
				case "logo":
					break;
				case "page":
					var p:int = e.data.data;
					if (p % 2 == 0) {//偶数页先变成 单数页
						p--;
					}
					PageContainer.currentPageNum = p;
					toolBarManager.setCurrentPage(PageContainer.currentPageNum);
					pageContainer.refrush();
					break;
				default:
					break;
			}
		}
	}
}
