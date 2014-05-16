package ui {
	import com.greensock.TweenMax;

	import core.PageContainer;

	import data.ZoomMode;
	import data.infos.PageInfo;

	import events.UIEvent;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import utils.common.component.display.AbstractDisplayObject;

	public class DoublePage extends AbstractDisplayObject {
		private var pageInfo1:PageInfo;
		private var pageInfo2:PageInfo;

		private var doublePage1:Page;
		private var doublePage2:Page;

		private var page:Page;

		private var _myZoomMode:String;
		private var isZooming:Boolean;

		private var offsetX:Number;
		private var offsetY:Number;
		private var preDownTime:int;

		public function DoublePage() {
			initBg();
		}

		private function initBg():void {
		}

		public function setSize(w:Number, h:Number):void {
			if (doublePage1) {
				doublePage1.setSize(w / 2, h);
			}
			if (doublePage2) {
				doublePage2.setSize(w / 2, h);
				doublePage2.x = doublePage1.x + doublePage1.width;
			}
		}

		private function onPageEventHandler(e:UIEvent):void {
			switch (e.data.type) {
				case "thumbnailImgLoadComplete":
					dispatchEvent(new UIEvent(UIEvent.DOUBLEPAGE_EVENT, {type: "thumbnailImgLoadComplete", thumbnailBmp: e.data.thumbnailBmp, pageNum: e.data.pageNum}));
					break;
				case "bigImgLoadComplete":
					dispatchEvent(new UIEvent(UIEvent.DOUBLEPAGE_EVENT, {type: "bigImgLoadComplete", bigImgBmp: e.data.bigImgBmp, pageNum: e.data.pageNum}));
					break;
				case "bigImgLoadError":
					e.target.setTip("doublePage bigImgLoadError");
					break;
				case "thumbnailImgLoadError":
					e.target.setTip("doublePage thumbnailImgLoadError");
					break;
			}
		}

		private function createPages():void {
			doublePage1 = new Page();
			doublePage1.name = "doublePage1";
			doublePage1.addEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
			doublePage1.addEventListener(MouseEvent.CLICK, onChoosePageHandler);
			addChild(doublePage1);
			doublePage2 = new Page();
			doublePage2.name = "doublePage2";
			doublePage2.addEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
			doublePage2.addEventListener(MouseEvent.CLICK, onChoosePageHandler);
			addChild(doublePage2);
			_myZoomMode = ZoomMode.SC_NORMAL;
		}

		private function onChoosePageHandler(e:MouseEvent):void {
			doublePage1.removeEventListener(MouseEvent.CLICK, onChoosePageHandler);
			doublePage2.removeEventListener(MouseEvent.CLICK, onChoosePageHandler);
			doublePage1.visible = doublePage2.visible = false;
			trace("我隐藏了它");
			page = e.currentTarget as Page;
			page.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			page.visible = true;
			addChild(page);
			onZoomHandler(e);
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

		private function onZoomHandler(e:MouseEvent):void {
			if (isZooming) {
				return;
			}
			if (_myZoomMode == ZoomMode.SC_NORMAL) {
				zoomAtPoint(page, new Point(e.currentTarget.mouseX, e.currentTarget.mouseY));//放大至1.8倍
				_myZoomMode = ZoomMode.SC_1_5;
				trace("自定义位置的放大 扩展至屏幕");
			} else {
				_myZoomMode = ZoomMode.SC_NORMAL;
				var stageCenterPoint:Point = new Point(TBZBMain.st.stageWidth / 2, TBZBMain.st.stageHeight / 2);
				trace(stageCenterPoint);
				trace(page.globalToLocal(stageCenterPoint));
				zoomAtPoint(page, this.globalToLocal(stageCenterPoint), "1");//还原1
				trace("恢复");
			}
		}

		private function zoomAtPoint(target:DisplayObject, point:Point, sc:Object = null):void {
			var scale:Number;
			var needExitZoomMode:Boolean;
			if (sc is String) {
				scale = Number(sc);
			} else if (sc is Number) {
				scale = target.scaleX + sc;
			} else {
				scale = stage.stageWidth / page.width;//和单页模式不同的是，这里扩大到flash的舞台宽
			}
			if (scale < 1) {
				scale = 1;
				trace("缩放的比1小，所以还原了");
			} else if (scale > 3) {
				scale = 3;
				trace("最多只能放大3倍");
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
				xx = page.name == "doublePage1" ? 0 : doublePage1.width;
				yy = 0;
				scale = 1;
				needExitZoomMode = true;
				doublePage1.visible = true;
				doublePage2.visible = true;
			}
			target.scaleX = bfsx;
			target.scaleY = bfsy;
			isZooming = true;
			trace("isZooming = true 2");
			TweenMax.to(target, 0.3, {scaleX: scale, scaleY: scale, x: xx, y: yy, onComplete: function ():void {
				isZooming = false;
				trace("isZooming = false 2");
				trace(doublePage2.visible);
				if (needExitZoomMode) {
					exitZoomMode();
				}
			}});
		}

		private function exitZoomMode():void {
			if (page) {
				page.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
				page.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
				page = null;
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			setTimeout(function ():void {
				doublePage1.addEventListener(MouseEvent.CLICK, onChoosePageHandler);
				doublePage2.addEventListener(MouseEvent.CLICK, onChoosePageHandler);
			}, 0);
			_myZoomMode = ZoomMode.SC_NORMAL;
			trace("经过我了");
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

		public function zoomIn():void {
			if (isZooming) {
				return;
			}
			trace("缩放增加0.5");
			if (!page) {
				page = doublePage1;
				doublePage1.removeEventListener(MouseEvent.CLICK, onChoosePageHandler);
				doublePage2.removeEventListener(MouseEvent.CLICK, onChoosePageHandler);
				doublePage1.visible = doublePage2.visible = false;
				trace("我隐藏了它");
				page.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
				page.visible = true;
				addChild(page);
			}
			var stageCenterPoint:Point = new Point(PageContainer.stageW / 2, PageContainer.stageH / 2);
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

		private function onMouseMoveHandler(e:MouseEvent):void {
			if (_myZoomMode != ZoomMode.SC_NORMAL) {
				page.x = e.stageX - offsetX;
				page.y = e.stageY - offsetY;
				e.updateAfterEvent();
			}
		}

		public function setPageAndPageInfo(p1Num:int, pInfo1:PageInfo, pInfo2:PageInfo = null):void {//电子书总数可能是单页
			if (pInfo2) {
				pageInfo1 = pInfo1;
				pageInfo2 = pInfo2;
				createPages();
				doublePage1.setPageAndPageInfo(p1Num, pInfo1);
				doublePage2.setPageAndPageInfo(p1Num + 1, pInfo2);
			} else {
				pageInfo1 = pInfo1;
				pageInfo2 = pInfo2;
				createPages();
				doublePage1.setPageAndPageInfo(p1Num, pInfo1);
			}
		}

		public function clear():void {
			if (doublePage1) {
				TweenMax.killTweensOf(doublePage1);
				doublePage1.removeEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
				doublePage1.destroy();
				removeChild(doublePage1);
				doublePage1 = null;
			}
			if (doublePage2) {
				TweenMax.killTweensOf(doublePage2);
				doublePage2.removeEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
				doublePage2.destroy();
				removeChild(doublePage2);
				doublePage2 = null;
			}
			if (page) {
				page.removeEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
				page.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
				page.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				page = null;
			}
		}

		public function resize():void {
			if (doublePage1) {
				doublePage1.resize();
			}
			if (doublePage2) {
				doublePage2.resize();
			}
			if (page) {

			}
		}

		public function get myZoomMode():String {
			return _myZoomMode;
		}
	}
}
