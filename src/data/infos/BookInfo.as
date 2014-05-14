package data.infos {
	public class BookInfo {
		private var _pageTotalNum:int;
		private var _bookName:String;
		private var _pageInfoList:Vector.<PageInfo>;

		public function BookInfo() {
			_pageInfoList = new Vector.<PageInfo>();
		}

		public function get pageTotalNum():int {
			return _pageTotalNum;
		}

		public function set pageTotalNum(value:int):void {
			_pageTotalNum = value;
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
	}
}
