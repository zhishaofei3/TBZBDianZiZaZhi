package ui {

	import com.greensock.TweenMax;

	import data.ZoomMode;
	import data.infos.PageInfo;

	import events.UIEvent;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import utils.common.component.display.AbstractDisplayObject;

	public class SinglePage extends AbstractDisplayObject {
		private var pageNum:int;
		private var pageInfo:PageInfo;
		private var page:Page;

		private var myZoomMode:String;

		private var isZooming:Boolean;

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
			page.addEventListener(MouseEvent.CLICK, onZoomHandler);
			addChild(page);
			myZoomMode = ZoomMode.SC_NORMAL;
		}

		private function onZoomHandler(e:MouseEvent):void {
			if (isZooming) {
				return;
			}
			if (myZoomMode == ZoomMode.SC_NORMAL) {
				scaleAtPoint(page, new Point(e.currentTarget.mouseX, e.currentTarget.mouseY));
			} else {
				isZooming = true;
				TweenMax.to(page, 0.5, {scaleX: 1, scaleY: 1, x: 0, y: 0, onComplete: function ():void {
					isZooming = false;
					myZoomMode = ZoomMode.SC_NORMAL;
				}});
			}
		}

		private function scaleAtPoint(target:DisplayObject, point:Point):void {
			TweenMax.killTweensOf(target);
			var bfsx:Number = target.scaleX;
			var bfsy:Number = target.scaleY;
			var stagePoint:Point = target.localToGlobal(point);
			var scale:Number = 1.8;
			target.scaleX = scale;
			target.scaleY = scale;
			var currentStagePoint:Point = target.localToGlobal(point);
			var yy:Number = target.y - (currentStagePoint.y - stagePoint.y);
			target.x = 0;
			var rec:Rectangle = target.getBounds(target.stage);
			var xx:Number = -rec.x - rec.width / 2 + target.stage.stageWidth / 2;
			target.scaleX = bfsx;
			target.scaleY = bfsy;
			isZooming = true;
			TweenMax.to(target, 0.5, {scaleX: scale, scaleY: scale, x: xx, y: yy, onComplete: function ():void {
				isZooming = false;
				myZoomMode = ZoomMode.SC_1_5;
			}});
		}

		public function zoomIn():void {

		}

		public function zoomOut():void {

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
				page.removeEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
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
	}
}
