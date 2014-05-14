/**
 * 单页 一次性用品
 * Created with IntelliJ IDEA.
 * User: zhishaofei
 * Date: 2014/5/13
 * Time: 14:19
 */
package ui {
	import data.infos.PageInfo;

	import events.UIEvent;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;

	import utils.common.component.display.AbstractDisplayObject;
	import utils.common.util.DisObjUtil;

	public class Page extends AbstractDisplayObject {
		private var thumbnailBmp:Bitmap;
		private var bigImgBmp:Bitmap;

		private var nativeW:int;
		private var nativeH:int;
		private var whb:Number;

		private var thumbnailBmpContainer:Sprite;
		private var bigImgBmpContainer:Sprite;

		private var pageInfo:PageInfo;
		private var pageNum:int;

		private var thumbnailLoader:Loader;
		private var bigImgLoader:Loader;

		private var loading:UI_LoadingBar;

		public function Page() {
			loading = new UI_LoadingBar();
			thumbnailBmpContainer = new Sprite();
			bigImgBmpContainer = new Sprite();
			addChild(thumbnailBmpContainer);
			addChild(bigImgBmpContainer);
		}

		private function onThumbnailImgLoadComplete(e:Event):void {
			thumbnailBmp = e.target.content;
			nativeW = thumbnailBmp.width;
			nativeH = thumbnailBmp.height;
			whb = nativeW / nativeH;
			thumbnailBmpContainer.addChild(thumbnailBmp);
			dispatchEvent(new UIEvent(UIEvent.PAGE_EVENT, {type: "thumbnailImgLoadComplete", thumbnailBmp: thumbnailBmp, pageNum: pageNum}));
			loadBigImg();
		}

		private function loadBigImg():void {
			var bigImgURLRequest:URLRequest = new URLRequest(pageInfo.bigURL);
			bigImgLoader = new Loader();
			bigImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBigImgLoadComplete1);
			bigImgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onBigImgLoadProgress);
			bigImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onBigImgLoadError);
			bigImgLoader.load(bigImgURLRequest);
			addChild(loading);
			DisObjUtil.toParentCenter(loading);
		}

		private function onBigImgLoadComplete1(e:Event):void {
			removeChild(loading);
			bigImgBmp = e.target.content;
			whb = bigImgBmp.width / bigImgBmp.height;//更新宽高比 理论上一样
			bigImgBmpContainer.addChild(bigImgBmp);
			dispatchEvent(new UIEvent(UIEvent.PAGE_EVENT, {type: "bigImgLoadComplete", bigImgBmp: bigImgBmp, pageNum: pageNum}));
		}

		private function onBigImgLoadProgress(e:ProgressEvent):void {
			var jd:String = (e.bytesLoaded / e.bytesTotal * 100).toFixed(1);
			loading.loadingBar.width = int(jd);
			loading.pText.text = jd + "%";
		}

		private function onBigImgLoadError(e:IOErrorEvent):void {
			removeChild(loading);
			trace("加载onBigImg IOError");
			dispatchEvent(new UIEvent(UIEvent.PAGE_EVENT, {type: "bigImgLoadError"}));
		}

		private function onThumbnailImgIOError(e:IOErrorEvent):void {
			trace("加载onThumbnailImg IOError");
			dispatchEvent(new UIEvent(UIEvent.PAGE_EVENT, {type: "thumbnailImgLoadError"}));
			loadBigImg();
		}

		public function setSize(w:Number, h:Number):void {
			thumbnailBmpContainer.width = w;
			thumbnailBmpContainer.height = h;
			bigImgBmpContainer.width = w;
			bigImgBmpContainer.height = h;
		}

		public function setPageAndPageInfo(pNum:int, pInfo:PageInfo):void {
			pageNum = pNum;
			pageInfo = pInfo;
			if (pageInfo.bigImgBmp) {
				trace("加载了缓存中的大图");
				bigImgBmpContainer.addChild(pageInfo.bigImgBmp);
				dispatchEvent(new UIEvent(UIEvent.PAGE_EVENT, {type: "bigImgLoadComplete", bigImgBmp: pageInfo.bigImgBmp, pageNum: pageNum}));
				return;
			} else if (pageInfo.thumbnailImgBmp) {
				trace("加载了缓存中的小图");
				thumbnailBmpContainer.addChild(pageInfo.thumbnailImgBmp);
				dispatchEvent(new UIEvent(UIEvent.PAGE_EVENT, {type: "thumbnailImgLoadComplete", thumbnailBmp: pageInfo.thumbnailImgBmp, pageNum: pageNum}));
				loadBigImg();
			}
			var thumbnailURLRequest:URLRequest = new URLRequest(pageInfo.thumbnailURL);
			thumbnailLoader = new Loader();
			thumbnailLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbnailImgLoadComplete);
			thumbnailLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onThumbnailImgIOError);
			thumbnailLoader.load(thumbnailURLRequest);
		}

		override public function destroy():void {
			if (thumbnailLoader) {
				thumbnailLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onThumbnailImgLoadComplete);
				thumbnailLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onThumbnailImgIOError);
				try {
					thumbnailLoader.close();
				} catch (e:Error) {
				}
				thumbnailLoader.unload();
				thumbnailLoader = null;
			}
			if (bigImgLoader) {
				bigImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onThumbnailImgLoadComplete);
				bigImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onThumbnailImgIOError);
				try {
					bigImgLoader.close();
				} catch (e:Error) {
				}
				bigImgLoader.unload();
				bigImgLoader = null;
			}
			if (thumbnailBmp) {
				thumbnailBmp = null;
			}
			if (bigImgBmp) {
				bigImgBmp = null;
			}
			thumbnailBmpContainer = null;
			bigImgBmpContainer = null;
			pageInfo = null;
			loading = null;
		}

		public function setTip(s:String):void {
			var tf:TextField = new TextField();
			tf.text = s;
			addChild(tf);
		}
	}
}
