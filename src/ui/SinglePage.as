package ui {

	import data.infos.PageInfo;

	import events.UIEvent;

	import utils.common.component.display.AbstractDisplayObject;

	public class SinglePage extends AbstractDisplayObject {
		private var pageNum:int;
		private var pageInfo:PageInfo;
		private var page:Page;

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
			addChild(page);
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
	}
}
