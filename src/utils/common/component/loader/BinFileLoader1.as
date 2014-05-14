package utils.common.component.loader {
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;

    internal class BinFileLoader1 {
        private var file:String;
        private var sp:Sprite;
        private var loader:Loader;
        private var x:int;
        private var y:int;

        public function BinFileLoader1(file:String, container:Sprite, x:int, y:int) {
            this.file = file;
            this.x = x;
            this.y = y;
            sp = new Sprite();
            container.addChild(sp);
            sp.x = x;
            sp.y = y;
        }

        private static function ioerror(event:IOErrorEvent):void {
            if (event != null) {
                event.target.removeEventListener(IOErrorEvent.IO_ERROR, ioerror);
            }
        }

        public function load():void {
            if (file == null || file == "") {
                ioerror(null);
                return;
            }
            loader = new Loader();
            this.sp.addChild(loader);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioerror, false, 0, true);
            loader.load(new URLRequest(file));
        }
    }
}
