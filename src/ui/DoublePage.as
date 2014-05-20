package ui {
	import com.greensock.TweenMax;

	import core.PageContainer;

	import data.ZoomMode;
	import data.infos.PageInfo;

	import events.UIEvent;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
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

		private var centerLine:Shape;

		public function DoublePage() {
			myZoomMode = ZoomMode.SC_NORMAL;
			initBg();
			createCenterLine();
		}

		private function initBg():void {
			this.filters = [new GlowFilter(0x000000, 0.6, 15, 15)];
		}

		public function setSize(w:Number, h:Number):void {
			if (doublePage1) {
				doublePage1.setSize(w / 2, h);
			}
			if (centerLine && doublePage1) {
				centerLine.x = doublePage1.x + doublePage1.width;
				centerLine.y = h;
			}
			if (doublePage2) {
				doublePage2.setSize(w / 2, h);
				doublePage2.x = centerLine.x + centerLine.width;
			}
			addChild(centerLine);
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
			doublePage1.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOverIcoHandler);
			doublePage1.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutIcoHandler);
			doublePage1.addEventListener(MouseEvent.CLICK, onChoosePageHandler);
			addChild(doublePage1);
			doublePage2 = new Page();
			doublePage2.name = "doublePage2";
			doublePage2.addEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
			doublePage2.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOverIcoHandler);
			doublePage2.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutIcoHandler);
			doublePage2.addEventListener(MouseEvent.CLICK, onChoosePageHandler);
			addChild(doublePage2);
			addChild(centerLine);
			myZoomMode = ZoomMode.SC_NORMAL;
		}

		private function onMouseOutIcoHandler(e:MouseEvent):void {
			MouseIco.delMouseIco();
		}

		private function onMouseOverIcoHandler(e:MouseEvent):void {
			if (myZoomMode == ZoomMode.SC_NORMAL) {
				MouseIco.addMouseIco(new UI_ZoomIn());
			} else {
				MouseIco.addMouseIco(new UI_ZoomOut());
			}
		}

		public function huanyuan():void {
			var stageCenterPoint:Point = new Point(TBZBMain.st.stageWidth / 2, TBZBMain.st.stageHeight / 2);
			trace(stageCenterPoint);
			if (page) {
				trace(page.globalToLocal(stageCenterPoint));
				zoomAtPoint(page, page.globalToLocal(stageCenterPoint), "1");//还原1
				trace("恢复");
			}
			myZoomMode = ZoomMode.SC_NORMAL;
		}

		private function onChoosePageHandler(e:MouseEvent):void {
			page = e.currentTarget as Page;
			if (isZooming || page.isLoading) {
				return;
			}
			doublePage1.removeEventListener(MouseEvent.CLICK, onChoosePageHandler);
			doublePage2.removeEventListener(MouseEvent.CLICK, onChoosePageHandler);
			doublePage1.visible = doublePage2.visible = false;
			trace("我隐藏了它");
			page.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			page.visible = true;
			addChild(page);
			onZoomHandler(e);
		}

		private function onMouseDownHandler(e:MouseEvent):void {
			if (isZooming || page.isLoading) {
				return;
			}
			preDownTime = getTimer();
			offsetX = e.stageX - page.x;
			offsetY = e.stageY - page.y;
			page.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}

		private function onMouseUpHandler(e:MouseEvent):void {
			if (isZooming || page.isLoading) {
				return;
			}
			page.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			var nowTime:int = getTimer();
			var offsetXEnd:Number = e.stageX - page.x;
			var offsetYEnd:Number = e.stageY - page.y;
			if ((nowTime - preDownTime < 200) && (offsetXEnd - offsetX < 50 && offsetYEnd - offsetY < 50)) {
				onZoomHandler(e);
			} else {
				toXCenter(page);
			}
			trace("page.y " + page.y);
			trace("page.height " + page.height);
		}

		private function onZoomHandler(e:MouseEvent):void {
			if (myZoomMode == ZoomMode.SC_NORMAL) {
				zoomAtPoint(page, new Point(e.currentTarget.mouseX, e.currentTarget.mouseY));//放大至1.8倍
				myZoomMode = ZoomMode.SC_1_5;
				trace("自定义位置的放大 扩展至屏幕");
			} else {
				var stageCenterPoint:Point = new Point(TBZBMain.st.stageWidth / 2, TBZBMain.st.stageHeight / 2);
				trace(stageCenterPoint);
				trace(page.globalToLocal(stageCenterPoint));
				zoomAtPoint(page, page.globalToLocal(stageCenterPoint), "1");//还原1
				trace("恢复");
				myZoomMode = ZoomMode.SC_NORMAL;
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
			var bfX:Number = target.x;
			var bfY:Number = target.y;
			target.x = 0;
			var rec:Rectangle = target.getBounds(target.stage);
			var xx:Number = -rec.x - rec.width / 2 + target.stage.stageWidth / 2;
			if (scale == 1) {//对准y
				if (page.name == "doublePage1") {
					xx = 0;
				} else {
					xx = centerLine.x + centerLine.width;
				}
				doublePage1.scaleX = 1;
				doublePage1.scaleY = 1;
				doublePage2.scaleX = 1;
				doublePage2.scaleY = 1;
				doublePage1.x = 0;
				doublePage1.y = 0;
				centerLine.x = doublePage1.x + doublePage1.width;
				doublePage2.x = centerLine.x + centerLine.width;
				doublePage2.y = 0;
				dispatchEvent(new UIEvent(UIEvent.DOUBLEPAGE_EVENT, {type: "reCenter"}));
				target.y = bfY;
				yy = 0;
				needExitZoomMode = true;
				doublePage1.visible = true;
				doublePage2.visible = true;
			}
			target.x = bfX;
			target.scaleX = bfsx;
			target.scaleY = bfsy;
			isZooming = true;
			TweenMax.to(target, 0.3, {scaleX: scale, scaleY: scale, x: xx, y: yy, onComplete: function ():void {
				isZooming = false;
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
			myZoomMode = ZoomMode.SC_NORMAL;
			trace("经过我了");
		}

		private function toXCenter(diso:DisplayObject):void {
			TweenMax.killTweensOf(diso);
			var xx:Number;
			if (page.width < stage.stageWidth) {//暂时测试
				var oldX:Number = diso.x;
				diso.x = 0;
				var rec:Rectangle = diso.getBounds(diso.stage);
				xx = -rec.x - rec.width / 2 + diso.stage.stageWidth / 2;
				diso.x = oldX;
			} else {
				xx = diso.x;
			}
			isZooming = true;
			TweenMax.to(diso, 0.3, {x: xx, onComplete: function ():void {
				isZooming = false;
				trace("结束");
			}});
		}

		public function zoomIn():void {
			if (isZooming) {
				return;
			}
			if (page && page.isLoading) {
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
			zoomAtPoint(page, page.globalToLocal(stageCenterPoint), 0.5);//缩放增加0.5
			myZoomMode = ZoomMode.SC_MORE;
		}

		public function zoomOut():void {
			if (isZooming) {
				return;
			}
			if (page) {
				if (page.isLoading) {
					return;
				}
				trace("缩放减少0.5");
				var stageCenterPoint:Point = new Point(TBZBMain.st.stageWidth / 2, TBZBMain.st.stageHeight / 2);
				trace(stageCenterPoint);
				trace(page.globalToLocal(stageCenterPoint));
				zoomAtPoint(page, page.globalToLocal(stageCenterPoint), -0.5);//缩放减少0.5
				myZoomMode = ZoomMode.SC_MORE;
			}
		}

		private function onMouseMoveHandler(e:MouseEvent):void {
			if (myZoomMode != ZoomMode.SC_NORMAL) {
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
			myZoomMode = ZoomMode.SC_NORMAL;
		}

		public function resize():void {
			if (doublePage1) {
				doublePage1.resize();
			}
			if (doublePage2) {
				doublePage2.resize();
			}
		}

		public function get myZoomMode():String {
			return _myZoomMode;
		}

		public function set myZoomMode(value:String):void {
			_myZoomMode = value;
		}

		public function onMouseWheel(e:MouseEvent):void {
			if (page) {
				if (myZoomMode != ZoomMode.SC_NORMAL) {
					page.y += e.delta * 7;
				}
				if (page.y > 0) {
					page.y = 0;
				}
			}
		}

		private function createCenterLine():void {
			centerLine = new Shape();
			centerLine.graphics.beginFill(0xdd0000);
			centerLine.graphics.drawRect(0, 0, 1, 1);
			centerLine.graphics.endFill();
		}

		public function reset():void {
			if (page) {
				page.scaleX = 1;
				page.scaleY = 1;
				page.y = 0;
				toXCenter(page);
			}
		}
	}
}
