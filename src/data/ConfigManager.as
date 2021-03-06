package data {
	import core.BookManager;

	import data.infos.BookInfo;
	import data.infos.OtherBookInfo;
	import data.infos.PageInfo;

	import events.TBZBEvent;

	import flash.external.ExternalInterface;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;

	import utils.common.util.LoadUtil;
	import utils.common.util.MethodUtil;

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

		public static function loadBookData(id:String):void {
			var loadUtil:LoadUtil = new LoadUtil();
			loadUtil.load("loadBookData", "/Flash/GetContent?id=" + id, null, URLRequestMethod.POST, "data");
//			loadUtil.load("loadBookData", "http://new.51tbzb.cn/tbzbv1/index?action=getContent&id=1109&device=IPad", null, URLRequestMethod.POST, "data");
			loadUtil.addEventListener("loadBookData", MethodUtil.create(onLoadBookDataComplete, id));
		}

		private static function onLoadBookDataComplete(e:TBZBEvent, id:String):void {
			var o:Object = e.data as Object;
			if (o.status == 1) {
				var bdata:Object = o.data;
//				bdata = {
//					"list": [
//						"http://misimg.51tbzb.cn/test/00f48ab097a343c57c30ac14fea6a2ee.jpg",
//						"http://misimg.51tbzb.cn/test/0a0420b8b11823cc32a9ccdbee60492f.jpg",
//						"http://misimg.51tbzb.cn/test/0abfb34b397164d29597685cc9acc296.jpg",
//						"http://misimg.51tbzb.cn/test/0acca5d61c8d06b37fb26b367d60af2d.jpg",
//						"http://misimg.51tbzb.cn/test/0aeea79f9f1c2cadf4ce3f175c575672.jpg",
//						"http://misimg.51tbzb.cn/test/0af219d27c5eedcaa095381fb21a9348.jpg",
//						"http://misimg.51tbzb.cn/test/0b3b1c4ea1a89b605d7ff0b2430cc7c5.jpg"
//					],
//					"thumb": [
//						"http://misimg.51tbzb.cn/PdfInfoFiles/thumbnail/248_363/2013-09-13/00f48ab097a343c57c30ac14fea6a2ee.jpg",
//						"http://misimg.51tbzb.cn/PdfInfoFiles/thumbnail/248_363/2013-09-13/0a0420b8b11823cc32a9ccdbee60492f.jpg",
//						"http://misimg.51tbzb.cn/PdfInfoFiles/thumbnail/248_363/2013-09-13/0abfb34b397164d29597685cc9acc296.jpg",
//						"http://misimg.51tbzb.cn/PdfInfoFiles/thumbnail/248_363/2013-09-13/0acca5d61c8d06b37fb26b367d60af2d.jpg",
//						"http://misimg.51tbzb.cn/PdfInfoFiles/thumbnail/248_363/2013-09-13/0aeea79f9f1c2cadf4ce3f175c575672.jpg",
//						"http://misimg.51tbzb.cn/PdfInfoFiles/thumbnail/248_363/2013-09-13/0af219d27c5eedcaa095381fb21a9348.jpg",
//						"http://misimg.51tbzb.cn/PdfInfoFiles/thumbnail/248_363/2013-09-13/0b3b1c4ea1a89b605d7ff0b2430cc7c5.jpg"
//					],
//					"Year": "2014",
//					"PerNum": "16",
//					"SubjectName": "语文",
//					"Version": "语文社S版",
//					"GradeName": "初一"
//				};
//				ConfigManager.pageMode = PageMode.SINGLE;
				ConfigManager.pageMode = PageMode.DOUBLE;
				var bookInfo:BookInfo = new BookInfo();
				bookInfo.id = id;
				bookInfo.perNum = bdata.perNum;
				bookInfo.year = bdata.year;//2014//16
				bookInfo.subjectName = bdata.subjectName;//语文
				bookInfo.version = bdata.version;//语文社S版
				bookInfo.gradeName = bdata.gradeName;//初一
				for (var i:String in bdata.neighbor) {//附近的书
					bookInfo.neighbor.push(new OtherBookInfo(bdata.neighbor[i].id, bdata.gradeName, bdata.version, bdata.subjectName, bdata.neighbor[i].year, bdata.neighbor[i].perNum));
				}
				bookInfo.answer = new PageInfo(bdata.answerThumb, bdata.answer);
				for (i in bdata.list) {
					bookInfo.pageInfoList.push(new PageInfo(bdata.thumb[i], bdata.list[i]));
				}
				bookInfo.totalPageNum = bdata.list.length;
				BookManager.setBookConfig(bookInfo);
			}
		}

		public static function get appData():AppData {
			return _appData;
		}
	}
}
