package {

	import core.BookManager;
	import core.PageContainer;

	import data.ConfigManager;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.IME;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	import scenes.LayerManager;

	[SWF(backgroundColor="0xF0F0F0", width=1000, height=600, frameRate="60")]
	public class TBZBMain extends Sprite {
		public static var st:Stage;

		public function TBZBMain() {
			if (stage) {
				init(null);
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		private function init(e:Event):void {
			PageContainer.stageW = stage.stageWidth;
			PageContainer.stageH = stage.stageHeight;
			trace(PageContainer.stageW, PageContainer.stageH);
			TBZBMain.st = stage;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			IME.enabled = false;
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			var cmi:ContextMenuItem = new ContextMenuItem("20140513", true, false);
			contextMenu.customItems.push(cmi);
//			contextMenu = contextMenu;
			var viewContainer:Sprite = new Sprite();
			addChild(viewContainer);
			LayerManager.initView(viewContainer);
			ConfigManager.init();
			BookManager.init();
			ConfigManager.loadBookData();
			BookManager.onResizeHandler(null);
		}
	}
}
