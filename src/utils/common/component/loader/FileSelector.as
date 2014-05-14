package utils.common.component.loader {
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.net.FileReference;

    public class FileSelector {
        private static var loadFR:FileReference = new FileReference();
        private static var saveFR:FileReference = new FileReference();
        private static var nameFR:FileReference = new FileReference();
        private static var m:int = init();
        private static var handleFunc:Function;

        private static function init():int {
            loadFR.addEventListener(Event.SELECT, _loadSelect);
            nameFR.addEventListener(Event.SELECT, _nameSelect);
            return 0;
        }

        private static function _nameSelect(event:Event):void {
            handleFunc(nameFR.name);
        }

        private static function _loadSelect(event:Event):void {
            loadFR.load();
        }

        private static function load(f:Function):void {
            handleFunc = f;
            loadFR.browse()
        }

        /**
         * 保存文本文件
         * @param b
         */
        public static function saveTxt(b:String):void {
            saveFR.save(b);
        }

        /**
         * 加载文本文件
         * @param f     接收函数,参数为(文件名:String,内容:String)
         */
        public static function loadTxt(f:Function):void {
            loadFR.addEventListener(Event.COMPLETE, _loadTxtComplete);
            load(f);
        }

        private static function _loadTxtComplete(event:Event):void {
            var s:String = String(loadFR.data);
            handleFunc(loadFR.name, s);
        }

        /**
         * 加载显示对象
         * @param f     接收函数,参数为(文件名:String,内容:DisplayObject)
         */
        public static function loadDisplayObject(f:Function):void {
            loadFR.addEventListener(Event.COMPLETE, _loadDOComplete);
            load(f);
        }

        private static function _loadDOComplete(event:Event):void {
            var l:Loader = new Loader();
            l.contentLoaderInfo.addEventListener(Event.COMPLETE, __loadDOComplete);
            l.loadBytes(loadFR.data);
        }

        private static function __loadDOComplete(event:Event):void {
            handleFunc(loadFR.name, LoaderInfo(event.target).loader.content);
        }

        public static function selectFile(func:Function):void {
            handleFunc = func;
            nameFR.browse();
        }
    }
}
