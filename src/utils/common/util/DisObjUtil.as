package utils.common.util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class DisObjUtil {
		/**
		 * 获取舞台上的层次路径
		 * @param d
		 * @return
		 */
		public static function getPath(d:DisplayObject):String {
			if (d == null)return "null";
			var s:String = d.name;
			var p:DisplayObject = d.parent;
			while (p != null) {
				s = p.name + "." + s;
				p = p.parent;
			}
			return s;
		}

		public static function toStageCenter(diso:DisplayObject):void {
			diso.x = 0;
			diso.y = 0;
			var rec:Rectangle = diso.getBounds(diso.stage);
			diso.x = -rec.x - rec.width / 2 + diso.stage.stageWidth / 2;
			diso.y = -rec.y - rec.height / 2 + diso.stage.stageHeight / 2;
		}

		public static function toStageXCenter(diso:DisplayObject):void {
			diso.x = 0;
			var rec:Rectangle = diso.getBounds(diso.stage);
			diso.x = -rec.x - rec.width / 2 + diso.stage.stageWidth / 2;
		}

		public static function toStageYCenter(diso:DisplayObject):void {
			diso.y = 0;
			var rec:Rectangle = diso.getBounds(diso.stage);
			diso.y = -rec.y - rec.height / 2 + diso.stage.stageHeight / 2;
		}

		public static function toParent0Point(diso:DisplayObject):void {
			var rec:Rectangle = diso.getBounds(diso.parent);
			diso.x -= rec.x + rec.width / 2;
			diso.y -= rec.y + rec.height / 2;
		}

		/**
		 * 放置到父剪辑的中心.在父剪辑的可见区域中
		 * @param diso
		 */
		public static function toParentCenter(diso:DisplayObject):void {
			var recp:Rectangle = new Rectangle();
			if (diso.parent != null) {
				recp = diso.parent.getBounds(diso.parent);
			}
			var rec:Rectangle = diso.getBounds(diso);
			diso.x = (recp.width) / 2 + recp.x - (rec.width / 2 + rec.x);
			diso.y = (recp.height) / 2 + recp.y - (rec.height / 2 + rec.y);
		}

		public static function toCenterInRect(c:DisplayObject, w:Number, h:Number):void {
			c.x = (w - c.width) / 2;
			c.y = (h - c.height) / 2;
		}

		public static function getChildByType(s:Class, b:DisplayObjectContainer):DisplayObject {
			for (var i:int = 0; i < b.numChildren; i++) {
				if (b.getChildAt(i) is s) {
					return b.getChildAt(i);
				}
			}
			return null;
		}

		public static function drawBtnToBmp(btn:SimpleButton):void {
			var bm:BitmapData = new BitmapData(btn.upState.width, btn.upState.height, true, 0);
			var v:Rectangle = btn.upState.getBounds(btn.upState);
			var m:Matrix = new Matrix();
			m.translate(-v.left, -v.top);
			bm.draw(btn.upState, m);
			btn.upState = new Bitmap(bm);
			btn.upState.x = v.left;
			btn.upState.y = v.top;
		}

		public static function removeMe(dc:DisplayObject):void {
			if (dc != null && dc.stage != null && dc.parent != null) {
				dc.parent.removeChild(dc);
			}
		}

		public static function toTop(dc:DisplayObject):void {
			if (dc != null && dc.stage != null && dc.parent != null) {
				dc.parent.swapChildren(dc, dc.parent.getChildAt(dc.parent.numChildren - 1));
			}
		}

		public static function removeAllChildren(dc:DisplayObjectContainer):void {
			while (dc && dc.numChildren) {
				dc.removeChildAt(0);
			}
		}

		public static function getNoneInteractiveBG(w:Number, h:Number, al:Number = 0.2):Sprite {
			var sp:Sprite = new Sprite();
			sp.mouseChildren = false;
			sp.mouseEnabled = true;
			sp.useHandCursor = false;
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function ():void {
			}, false, 0, true);
			sp.graphics.beginFill(0, al);
			sp.graphics.drawRect(0, 0, w, h);
			sp.graphics.endFill();
			return sp;
		}

		public static function getFrameByLable(s:String, mc:MovieClip):int {
			var ls:Array = mc.currentLabels;
			if (ls == null)return 1;
			for (var i:int = 0; i < ls.length; i++) {
				var m:FrameLabel = ls[i];
				if (m == null)return 1;
				if (m.name == s) {
					return m.frame;
				}
			}
			return -1;
		}

		public static function disable(s:InteractiveObject):void {
			if (s == null)return;
			s.mouseEnabled = false;
			s.filters = [FilterUtil.getGrayFilter()];
		}

		public static function enable(s:InteractiveObject):void {
			if (s == null)return;
			s.mouseEnabled = true;
			s.filters = [];
		}

		public static function hilight(mc1:Sprite):void {
			var rec:Rectangle = mc1.getBounds(mc1);
			var mc:Sprite = new Sprite();
			mc1.addChild(mc);
			mc.graphics.clear();
			mc.graphics.beginFill(0, 0.2);
			mc.graphics.drawRect(rec.x - 1, rec.y - 1, rec.width + 2, rec.height + 2);
			mc.graphics.endFill();
			mc.graphics.beginFill(0xff0000, 0.2);
			mc.graphics.drawCircle(0, 0, 2);
			mc.graphics.endFill();
		}

		public static function drawPoint(m:Sprite):void {
			m.graphics.beginFill(0xff0000);
			m.graphics.drawCircle(0, 0, 10);
			m.graphics.endFill();
		}
	}
}
