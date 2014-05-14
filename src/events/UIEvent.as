package events {

	import flash.events.Event;

	/**
	 * Created by 同步周报阅读器事件.
	 * User: zhishaofei
	 * Date: 14-05-13
	 * Time: 下午4:37
	 */
	public class UIEvent extends Event {
		public static var PAGE_EVENT:String = "PAGE_EVENT";
		public static var SINGLEPAGE_EVENT:String = "SINGLEPAGE_EVENT";
		public static var DOUBLEPAGE_EVENT:String = "DOUBLEPAGE_EVENT";
		public function UIEvent(t:String, _data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(t, bubbles, cancelable);
			this.data = _data;
		}

		private var _data:Object = {};

		public function get data():Object {
			return _data;
		}

		public function set data(data:Object):void {
			_data = data;
		}

		override public function toString():String {
			return formatToString("UIEvent:", "type", "bubbles", "cancelable", "data");
		}

		override public function clone():Event {
			return new UIEvent(type, data, bubbles, cancelable);
		}
	}
}
