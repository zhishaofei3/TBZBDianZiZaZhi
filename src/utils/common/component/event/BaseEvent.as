package utils.common.component.event {
    import flash.events.Event;

    /**
     * @author WWJ
     */
    public class BaseEvent extends Event {
        private var _data:Object = new Object();

        public function BaseEvent(type:String, data:Object=null) {
            super(type, bubbles, cancelable);
            this._data = data;
        }

        public function get data():Object {
            return _data;
        }

        public function set data(data:Object):void {
            _data = data;
        }
    }
}
