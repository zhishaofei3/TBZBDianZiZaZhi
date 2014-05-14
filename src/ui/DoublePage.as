package ui {
	import data.infos.PageInfo;

	import events.UIEvent;

	import utils.common.component.display.AbstractDisplayObject;

	public class DoublePage extends AbstractDisplayObject {
		private var pageInfo1:PageInfo;
		private var pageInfo2:PageInfo;

		private var doubePage1:Page;
		private var doubePage2:Page;

		public function DoublePage() {
			initBg();
		}

		private function initBg():void {

		}

		public function setSize(w:Number, h:Number):void {
			if (doubePage1) {
				doubePage1.setSize(w / 2, h);
			}
			if (doubePage2) {
				doubePage2.setSize(w / 2, h);
				doubePage2.x = doubePage1.x + doubePage1.width;
			}
		}

		private var thumbnailImgLoadCount:int = 0;
		private var bigImgLoadCount:int = 0;

		private function onPageEventHandler(e:UIEvent):void {
			switch (e.data.type) {
				case "thumbnailImgLoadComplete":
					thumbnailImgLoadCount++;
					if (thumbnailImgLoadCount == 2) {
						thumbnailImgLoadCount = 0;
						dispatchEvent(new UIEvent(UIEvent.DOUBLEPAGE_EVENT, {type: "thumbnailImgLoadComplete", thumbnailBmp: e.data.data, pageNum: e.data.pageNum}));
					}
					break;
				case "bigImgLoadComplete":
					bigImgLoadCount++;
					if (bigImgLoadCount == 2) {
						bigImgLoadCount = 0;
						dispatchEvent(new UIEvent(UIEvent.DOUBLEPAGE_EVENT, {type: "bigImgLoadComplete", bigImgBmp: e.data.data, pageNum: e.data.pageNum}));
					}
					break;
			}
		}

		private function createPages():void {
			doubePage1 = new Page();
			doubePage1.addEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
			addChild(doubePage1);
			doubePage2 = new Page();
			doubePage2.addEventListener(UIEvent.PAGE_EVENT, onPageEventHandler);
			addChild(doubePage2);
		}

		public function setPageAndPageInfo(p1Num:int, p2Num:int, pInfo1:PageInfo, pInfo2:PageInfo):void {
			pageInfo1 = pInfo1;
			pageInfo2 = pInfo2;
			createPages();
			doubePage1.setPageAndPageInfo(p1Num, pInfo1);
			doubePage2.setPageAndPageInfo(p2Num, pInfo2);
		}
	}
}
