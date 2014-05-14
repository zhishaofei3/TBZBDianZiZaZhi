package utils.common.component.loader {
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.media.Sound;
    import flash.net.URLRequest;

    /**
     * ...
     * @author wk
     */
    internal class BinSoundLoader {
        private var receivefunc:Function;
        private var file:String;

        public function BinSoundLoader(file:String, receivefunc:Function) {
            this.file = file;
            this.receivefunc = receivefunc;
        }

        public function load():void {
            if (!file || file == "") {
                return;
            }
            var request:URLRequest = new URLRequest(file);
            var soundFactory:Sound = new Sound();
            soundFactory.addEventListener(Event.COMPLETE, completeHandler);
            soundFactory.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            soundFactory.load(request);
        }

        private function ioErrorHandler(e:IOErrorEvent):void {
            if (e) {
                e.target.removeEventListener(Event.COMPLETE, completeHandler);
                e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            }
            if (this.receivefunc != null) {
                this.receivefunc.apply(null, [null]);
            }
        }

        private function completeHandler(e:Event):void {
            e.target.removeEventListener(Event.COMPLETE, completeHandler);
            e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            complete(Sound(e.target));
        }

        private function complete(s:Sound):void {
            if (this.receivefunc != null) {
                this.receivefunc.apply(null, [s]);
            }
            this.receivefunc = null;
        }
    }
}
