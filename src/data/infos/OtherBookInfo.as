package data.infos {
	public class OtherBookInfo {
		private var _id:String;
		private var _perNum:String;
		private var _year:String;
		private var _gradeName:String;
		private var _version:String;
		private var _subjectName:String;

		public function OtherBookInfo(i:String, g:String, v:String, s:String, y:String, p:String) {
			id = i;
			gradeName = g;
			version = v;
			subjectName = s;
			year = y;
			perNum = p;
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

		public function get gradeName():String {
			return _gradeName;
		}

		public function set gradeName(value:String):void {
			_gradeName = value;
		}

		public function get version():String {
			return _version;
		}

		public function set version(value:String):void {
			_version = value;
		}

		public function get subjectName():String {
			return _subjectName;
		}

		public function set subjectName(value:String):void {
			_subjectName = value;
		}
	}
}
