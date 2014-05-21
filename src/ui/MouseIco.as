package ui {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Mouse;

	import utils.common.util.DisObjUtil;

	public class MouseIco {
		public static var content:Sprite;
		public static var st:Stage;

		public static function addMouseIco(sp:Sprite):void {
			Mouse.hide();
			sp.mouseChildren = false;
			sp.mouseEnabled = false;
			DisObjUtil.removeAllChildren(content);
			content.removeEventListener(Event.ENTER_FRAME, mouseIcoMove);
			content.addChild(sp);
			content.addEventListener(Event.ENTER_FRAME, mouseIcoMove);
		}

		public static function delMouseIco():void {
			Mouse.show();
			DisObjUtil.removeAllChildren(content);
			content.removeEventListener(Event.ENTER_FRAME, mouseIcoMove);
		}

		private static function mouseIcoMove(e:Event):void {
			content.x = TBZBMain.st.mouseX;
			content.y = TBZBMain.st.mouseY;
		}
	}
}
