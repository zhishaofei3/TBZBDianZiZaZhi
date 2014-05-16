package scenes {

	import core.PageContainer;

	import utils.common.util.DisObjUtil;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * 图层管理器
	 * Created by 同步周报阅读器.
	 * User: zhishaofei
	 * Date: 2014/5/13
	 * Time: 12:30
	 */
	public class LayerManager extends Sprite {
		public static var bgContainer:Sprite;//背景层
		public static var bookContainer:Sprite;//图书层
		public static var pageContainer:Sprite;//单页层
		public static var toolContainer:Sprite;//工具层
		public static var tipWindowContainer:Sprite;//提示层
		public static var testContainer:Sprite;//测试层
		public static var mouseIconContainer:Sprite;//光标层

		public function LayerManager() {
		}

		public static function initView(cont:Sprite):void {
			bgContainer = new Sprite();
			bgContainer.mouseEnabled = false;
			bgContainer.mouseChildren = false;
			bgContainer.graphics.beginFill(0xE8E8E8);
			bgContainer.graphics.drawRect(0, 0, PageContainer.stageW, PageContainer.stageH);
			bgContainer.graphics.endFill();
			cont.addChild(bgContainer);
			bookContainer = new Sprite();
			cont.addChild(bookContainer);
			pageContainer = new Sprite();
			cont.addChild(pageContainer);
			toolContainer = new Sprite();
			cont.addChild(toolContainer);
			tipWindowContainer = new Sprite();
			cont.addChild(tipWindowContainer);
			testContainer = new Sprite();
			cont.addChild(testContainer);
			mouseIconContainer = new Sprite();
			mouseIconContainer.mouseEnabled = false;
			mouseIconContainer.mouseChildren = false;
			cont.addChild(mouseIconContainer);
		}

		public static function clearContainer(container:DisplayObjectContainer):void {
			DisObjUtil.removeAllChildren(container);
		}
	}
}
