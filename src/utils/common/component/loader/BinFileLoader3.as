package utils.common.component.loader {
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;

    internal class BinFileLoader3 {
        private var receivefunc:Function;
        private var progressFunc:Function;
        private var file:String;
        private var loader:Loader;

        /**
         *
         * @param file  文件路径
         * @param receivefunc
         * @param progfunc
         */
        public function BinFileLoader3(file:String, receivefunc:Function, progfunc:Function) {
            this.file = file;
            this.receivefunc = receivefunc;
            this.progressFunc = progfunc;
        }

        public function load():void {
            if (file == null || file == "") {
                this.ioerror(null);
                return;
            }
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioerror);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
            loader.load(new URLRequest(file));
        }

        protected function ioerror(event:IOErrorEvent):void {
            if (this.receivefunc != null) {
                this.receivefunc.apply(null, [null]);
            }
            destroy();
        }

        protected function progress(event:ProgressEvent):void {
            if (this.progressFunc != null) {
                this.progressFunc.apply(null, [event]);
            }
        }

        protected function complete(evt:Event):void {
            var loadedSWF:DisplayObject = loader.contentLoaderInfo.content;
            if (this.receivefunc != null) {
                this.receivefunc.apply(null, [loadedSWF]);
            }
            destroy();
        }

        public function destroy():void {
            this.receivefunc = null;
            this.progressFunc = null;
            this.file = null;
            if (loader == null)return;
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioerror);
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete);
            loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
        }
    }
}
