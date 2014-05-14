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
	import flash.utils.setTimeout;

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

		private var loading:LoadingBar;

		public function Page() {
			loading = new LoadingBar();
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
			setTimeout(function ():void {
				loadBigImg();
			}, 1000);
		}

		private function loadBigImg():void {
			var bigImgURLRequest:URLRequest = new URLRequest(pageInfo.bigURL);
			bigImgLoader = new Loader();
			bigImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBigImgLoadComplete);
			bigImgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onBigImgLoadProgress);
			bigImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onBigImgLoadError);
			bigImgLoader.load(bigImgURLRequest);
			addChild(loading);
			DisObjUtil.toParentCenter(loading);
		}

		private function onBigImgLoadComplete(e:Event):void {
			removeChild(loading);
			bigImgBmp = e.target.content;
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
		}

		private function onThumbnailImgIOError(e:IOErrorEvent):void {
			trace("加载onThumbnailImg IOError");
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
			var thumbnailURLRequest:URLRequest = new URLRequest(pageInfo.thumbnailURL);
			thumbnailLoader = new Loader();
			thumbnailLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbnailImgLoadComplete);
			thumbnailLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onThumbnailImgIOError);
			thumbnailLoader.load(thumbnailURLRequest);
		}

		override public function destroy():void {
			thumbnailLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onThumbnailImgLoadComplete);
			thumbnailLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onThumbnailImgIOError);
			thumbnailLoader.unload();
			thumbnailLoader = null;
			bigImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbnailImgLoadComplete);
			bigImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onThumbnailImgIOError);
			bigImgLoader.unload();
			bigImgLoader = null;
		}
	}
}
