package utils.common.component.loader {
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    internal class TextFileLoader {
        private var file:String;
        private var receiveFunction:Function;

        public function TextFileLoader(file:String, ff:Function) {
            this.file = file;
            this.receiveFunction = ff;
        }

        public function load():void {
            var loader:URLLoader = new URLLoader();
            var request:URLRequest = new URLRequest(file);
            loader.addEventListener(Event.COMPLETE, onComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, ioerror);
            loader.load(request);
        }

        private function ioerror(event:IOErrorEvent):void {
            this.receiveFunction.apply(null, [null]);
        }

        private function onComplete(event:Event):void {
            var l:URLLoader = URLLoader(event.target);
            this.receiveFunction([l.data]);
            l.removeEventListener(Event.COMPLETE, onComplete);
            l.removeEventListener(IOErrorEvent.IO_ERROR, ioerror);
        }
    }
}
