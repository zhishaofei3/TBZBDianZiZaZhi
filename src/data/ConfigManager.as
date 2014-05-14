package data {
	import core.BookManager;

	import data.infos.BookInfo;
	import data.infos.PageInfo;

	import events.TBZBEvent;

	import flash.external.ExternalInterface;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;

	import utils.common.util.LoadUtil;

	/**
	 * 数据加载器
	 * Created by 同步周报阅读器.
	 * User: zhishaofei
	 * Date: 12-6-29
	 * Time: 上午11:10
	 */
	public class ConfigManager {
		private static var _appData:AppData = new AppData();
		public static var pageMode:String;
		public static var pageDict:Dictionary;

		public function ConfigManager() {
		}

		public static function init():void {
			initFlashVars();
			if (ExternalInterface.available) {
			}
		}

		private static function initFlashVars():void {
		}

		public static function loadBookData():void {
			var loadUtil:LoadUtil = new LoadUtil();
			loadUtil.load("loadBookData", "http://new.51tbzb.cn/testJson.php", null, URLRequestMethod.POST, "data");
			loadUtil.addEventListener("loadBookData", onLoadBookDataComplete);
		}

		private static function onLoadBookDataComplete(e:TBZBEvent):void {
			var o:Object = e.data as Object;
			if (o.status == 1) {
				var bdata:Object = o.data;
				var bookInfo:BookInfo = new BookInfo();
				bookInfo.bookName = bdata.bookName || "未命名书籍";
				for (var i:String in bdata.list) {
					bookInfo.pageInfoList.push(new PageInfo(bdata.thumb[i], bdata.list[i]));
				}
				bookInfo.pageTotalNum = bdata.list.length;
				BookManager.setBookConfig(bookInfo);
			}
		}

		public static function get appData():AppData {
			return _appData;
		}
	}
}
