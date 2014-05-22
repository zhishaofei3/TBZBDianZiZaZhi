package data.infos {
	public class OtherBookInfo {
		private var _id:String;
		private var _perNum:String;
		private var _year:String;

		public function OtherBookInfo(i:String, p:String, y:String) {
			id = i;
			perNum = p;
			year = y;
		}

		public function get year():String {
			return _year;
		}

		public function set year(value:String):void {
			_year = value;
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
		}

		public function get perNum():String {
			return _perNum;
		}

		public function set perNum(value:String):void {
			_perNum = value;
		}
	}
}
