package core {

	import data.ConfigManager;
	import data.PageMode;
	import data.infos.BookInfo;

	import flash.events.Event;

	import scenes.LayerManager;

	public class BookManager {
		private static var pageContainer:PageContainer;
		private static var bookInfo:BookInfo;
		public function BookManager() {
		}

		private static function onResizeHandler(e:Event):void {
			PageContainer.stageW = TBZBMain.st.stageWidth;
			PageContainer.stageH = TBZBMain.st.stageHeight;
			pageContainer.resize();
			LayerManager.bgContainer.width = PageContainer.stageW;
			LayerManager.bgContainer.height = PageContainer.stageH;
		}

		public static function init():void {
			initUI();
			TBZBMain.st.addEventListener(Event.RESIZE, onResizeHandler);
		}

		private static function initUI():void {
//			ConfigManager.pageMode = PageMode.SINGLE;
			ConfigManager.pageMode = PageMode.DOUBLE;
			initBook();
		}

		public static function initBook():void {
			pageContainer = new PageContainer();
			LayerManager.bookContainer.addChild(pageContainer);
		}

		public static function setBookConfig(bInfo:BookInfo):void {
			bookInfo = bInfo;
			pageContainer.initData(bInfo);
		}

	}
}
