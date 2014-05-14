package data.infos {
	import flash.display.Bitmap;

	public class PageInfo {
		private var _thumbnailURL:String;
		private var _bigURL:String;
		private var _thumbnailImgBmp:Bitmap;
		private var _bigImgBmp:Bitmap;

		public function PageInfo(tURL:String, bURL:String) {
			thumbnailURL = tURL;
			_bigURL = bURL;
		}

		public function get thumbnailURL():String {
			return _thumbnailURL;
		}

		public function set thumbnailURL(value:String):void {
			_thumbnailURL = value;
		}

		public function get bigURL():String {
			return _bigURL;
		}

		public function set bigURL(value:String):void {
			_bigURL = value;
		}

		public function get thumbnailImgBmp():Bitmap {
			return _thumbnailImgBmp;
		}

		public function set thumbnailImgBmp(value:Bitmap):void {
			_thumbnailImgBmp = value;
		}

		public function get bigImgBmp():Bitmap {
			return _bigImgBmp;
		}

		public function set bigImgBmp(value:Bitmap):void {
			_bigImgBmp = value;
		}
	}
}
