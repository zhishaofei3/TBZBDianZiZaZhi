package data.infos {
	public class BookInfo {
		private var _totalPageNum:int;
		private var _bookName:String;
		private var _pageInfoList:Vector.<PageInfo>;
		private var _year:String;
		private var _perNum:String;
		private var _subjectName:String;
		private var _version:String;
		private var _gradeName:String;
		private var _answer:PageInfo;
		private var _neighbor:Vector.<OtherBookInfo>;
		private var _id:String;

		public function BookInfo() {
			_pageInfoList = new Vector.<PageInfo>();
			_neighbor = new Vector.<OtherBookInfo>();
		}

		public function get totalPageNum():int {
			return _totalPageNum;
		}

		public function set totalPageNum(value:int):void {
			_totalPageNum = value;
		}

		public function get bookName():String {
			return _bookName;
		}

		public function set bookName(value:String):void {
			_bookName = value;
		}

		public function get pageInfoList():Vector.<PageInfo> {
			return _pageInfoList;
		}

		public function set pageInfoList(value:Vector.<PageInfo>):void {
			_pageInfoList = value;
		}

		public function get year():String {
			return _year;
		}

		public function set year(value:String):void {
			_year = value;
		}

		public function get perNum():String {
			return _perNum;
		}

		public function set perNum(value:String):void {
			_perNum = value;
		}

		public function get subjectName():String {
			return _subjectName;
		}

		public function set subjectName(value:String):void {
			_subjectName = value;
		}

		public function get version():String {
			return _version;
		}

		public function set version(value:String):void {
			_version = value;
		}

		public function get gradeName():String {
			return _gradeName;
		}

		public function set gradeName(value:String):void {
			_gradeName = value;
		}

		public function get answer():PageInfo {
			return _answer;
		}

		public function set answer(value:PageInfo):void {
			_answer = value;
		}

		public function get neighbor():Vector.<OtherBookInfo> {
			return _neighbor;
		}

		public function set neighbor(value:Vector.<OtherBookInfo>):void {
			_neighbor = value;
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
		}
	}
}
