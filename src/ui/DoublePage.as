package ui {
	import data.infos.PageInfo;

	import events.UIEvent;

	import utils.common.component.display.AbstractDisplayObject;

	public class DoublePage extends AbstractDisplayObject {
		private var pageInfo1:PageInfo;
		private var pageInfo2:PageInfo;

		private var doublePage1:Page;
		private var doublePage2:Page;

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
				trace(doublePage2.x);
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
			doublePage1.addEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
			addChild(doublePage1);
			doublePage2 = new Page();
			doublePage2.addEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
			addChild(doublePage2);
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
				doublePage1.removeEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
				doublePage1.destroy();
				removeChild(doublePage1);
				doublePage1 = null;
			}
			if (doublePage2) {
				doublePage2.removeEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
				doublePage2.destroy();
				removeChild(doublePage2);
				doublePage2 = null;
			}
		}
	}
}
