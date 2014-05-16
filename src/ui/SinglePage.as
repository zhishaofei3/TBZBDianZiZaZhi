package ui {

	import com.greensock.TweenMax;

	import data.ZoomMode;
	import data.infos.PageInfo;

	import events.UIEvent;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	import utils.common.component.display.AbstractDisplayObject;

	public class SinglePage extends AbstractDisplayObject {
		private var pageNum:int;
		private var pageInfo:PageInfo;
		private var page:Page;

		private var _myZoomMode:String;
		private var isZooming:Boolean;

		private var offsetX:Number;
		private var offsetY:Number;
		private var preDownTime:int;

		public function SinglePage() {
			initBg();
		}

		private function initBg():void {
		}

		public function setSize(w:Number, h:Number):void {
			if (page) {
				page.setSize(w, h);
			}
		}

		public function setPageAndPageInfo(pNum:int, pInfo:PageInfo):void {
			pageNum = pNum;
			pageInfo = pInfo;
			createPage();
			page.setPageAndPageInfo(pNum, pageInfo);
		}

		private function createPage():void {
			page = new Page();
			page.addEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
			page.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			addChild(page);
			_myZoomMode = ZoomMode.SC_NORMAL;
		}

		private function onMouseDownHandler(e:MouseEvent):void {
			preDownTime = getTimer();
			offsetX = e.stageX - page.x;
			offsetY = e.stageY - page.y;
			page.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}

		private function onMouseUpHandler(e:MouseEvent):void {
			page.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			var nowTime:int = getTimer();
			if (nowTime - preDownTime < 200) {
				onZoomHandler(e);
			} else {
				if (page.width < stage.stageWidth) {//暂时测试
					toCenter(page);
				}
			}
		}

		private function onMouseMoveHandler(e:MouseEvent):void {
			if (_myZoomMode != ZoomMode.SC_NORMAL) {
				page.x = e.stageX - offsetX;
				page.y = e.stageY - offsetY;
				e.updateAfterEvent();
			}
		}

		private function onZoomHandler(e:MouseEvent):void {
			if (isZooming) {
				return;
			}
			if (_myZoomMode == ZoomMode.SC_NORMAL) {
				zoomAtPoint(page, new Point(e.currentTarget.mouseX, e.currentTarget.mouseY));//放大至1.8倍
				_myZoomMode = ZoomMode.SC_1_5;
				trace("自定义位置的放大 放大1.8倍");
			} else {
				_myZoomMode = ZoomMode.SC_NORMAL;
				var stageCenterPoint:Point = new Point(TBZBMain.st.stageWidth / 2, TBZBMain.st.stageHeight / 2);
				trace(stageCenterPoint);
				trace(page.globalToLocal(stageCenterPoint));
				zoomAtPoint(page, this.globalToLocal(stageCenterPoint), "1");//还原1
				trace("恢复");
			}
		}

		private function toCenter(diso:DisplayObject):void {
			TweenMax.killTweensOf(diso);
			var oldX:Number = diso.x;
			diso.x = 0;
			var rec:Rectangle = diso.getBounds(diso.stage);
			var xx:Number = -rec.x - rec.width / 2 + diso.stage.stageWidth / 2;
			diso.x = oldX;
			isZooming = true;
			trace("isZooming = true 1");
			TweenMax.to(diso, 0.3, {x: xx, onComplete: function ():void {
				isZooming = false;
				trace("结束");
				trace("isZooming = false 1");
			}});
		}

		private function zoomAtPoint(target:DisplayObject, point:Point, sc:Object = null):void {
			var scale:Number;
			if (sc is String) {
				scale = Number(sc);
			} else if (sc is Number) {
				scale = target.scaleX + sc;
			} else {
				scale = 1.8;
			}
			if (scale < 1) {
				scale = 1;
				trace("缩放的比1小，所以还原了");
			} else if (scale > 3) {
				scale = 3;
				trace("最多只能放大3倍")
			}
			TweenMax.killTweensOf(target);
			var bfsx:Number = target.scaleX;
			var bfsy:Number = target.scaleY;
			var stagePoint:Point = target.localToGlobal(point);
			target.scaleX = scale;
			target.scaleY = scale;
			var currentStagePoint:Point = target.localToGlobal(point);
			var yy:Number = target.y - (currentStagePoint.y - stagePoint.y);
			//备份
			var oldX:Number = target.x;
			target.x = 0;
			var rec:Rectangle = target.getBounds(target.stage);
			var xx:Number = -rec.x - rec.width / 2 + target.stage.stageWidth / 2;
			target.x = oldX;
			if (scale == 1) {//对准y
				var oldY:Number = target.y;
				target.y = 0;
				var rec2:Rectangle = target.getBounds(target.stage);
				yy = -rec2.y - rec2.height / 2 + target.stage.stageHeight / 2;
				target.y = oldY;
			}
			target.scaleX = bfsx;
			target.scaleY = bfsy;
			isZooming = true;
			trace("isZooming = true 2");
			TweenMax.to(target, 0.3, {scaleX: scale, scaleY: scale, x: xx, y: yy, onComplete: function ():void {
				isZooming = false;
				trace("isZooming = false 2");
			}});
		}

		public function zoomIn():void {
			if (isZooming) {
				return;
			}
			trace("缩放增加0.5");
			var stageCenterPoint:Point = new Point(TBZBMain.st.stageWidth / 2, TBZBMain.st.stageHeight / 2);
			trace(stageCenterPoint);
			trace(page.globalToLocal(stageCenterPoint));
			zoomAtPoint(page, this.globalToLocal(stageCenterPoint), 0.5);//缩放增加0.5
			_myZoomMode = ZoomMode.SC_MORE;
		}

		public function zoomOut():void {
			if (isZooming) {
				return;
			}
			trace("缩放减少0.5");
			var stageCenterPoint:Point = new Point(TBZBMain.st.stageWidth / 2, TBZBMain.st.stageHeight / 2);
			trace(stageCenterPoint);
			trace(page.globalToLocal(stageCenterPoint));
			zoomAtPoint(page, this.globalToLocal(stageCenterPoint), -0.5);//缩放减少0.5
			_myZoomMode = ZoomMode.SC_MORE;
		}

		private function onPageEventHandler(e:UIEvent):void {
			switch (e.data.type) {
				case "thumbnailImgLoadComplete":
					dispatchEvent(new UIEvent(UIEvent.SINGLEPAGE_EVENT, {type: "thumbnailImgLoadComplete", thumbnailBmp: e.data.thumbnailBmp, pageNum: e.data.pageNum}));
					break;
				case "bigImgLoadComplete":
					dispatchEvent(new UIEvent(UIEvent.SINGLEPAGE_EVENT, {type: "bigImgLoadComplete", bigImgBmp: e.data.bigImgBmp, pageNum: e.data.pageNum}));
					break;
				case "bigImgLoadError":
					page.setTip("bigImgLoadError");
					break;
				case "thumbnailImgLoadError":
					page.setTip("thumbnailImgLoadError");
					break;
			}
		}

		public function clear():void {
			if (page) {
				TweenMax.killTweensOf(page);
				page.removeEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
				page.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
				page.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				page.destroy();
				removeChild(page);
				page = null;
			}
		}

		public function resize():void {
			if (page) {
				page.resize();
			}
		}

		public function get myZoomMode():String {
			return _myZoomMode;
		}
	}
}
