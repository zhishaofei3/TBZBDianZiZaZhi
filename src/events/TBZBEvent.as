package events {

	import flash.events.Event;

	/**
	 * Created by 同步周报阅读器事件.
	 * User: zhishaofei
	 * Date: 12-4-18
	 * Time: 下午6:13
	 */
	public class TBZBEvent extends Event {
		public function TBZBEvent(t:String, _data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
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
			return formatToString("TBZBEvent:", "type", "bubbles", "cancelable", "data");
		}

		override public function clone():Event {
			return new TBZBEvent(type, data, bubbles, cancelable);
		}
	}
}
