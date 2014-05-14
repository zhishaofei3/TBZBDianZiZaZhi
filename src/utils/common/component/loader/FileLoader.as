package utils.common.component.loader {
    import flash.display.Sprite;

    public class FileLoader {
        /**
         * 加载显示对象直接addChild到container
         * @param file
         * @param container
         * @param x
         * @param y
         */
        public static function loadMovieAttach(file:String, container:Sprite, x:int = 0, y:int = 0):void {
            var l:BinFileLoader1 = new BinFileLoader1(file, container, x, y);
            l.load();
        }

        /**
         * 加载文本文件
         */
        public static function loadByteAndReceive(file:String, receiveFunc:Function):void {
            var l:TextFileLoader = new TextFileLoader(file, receiveFunc);
            l.load();
        }

        /**
         * 加载音效文件
         * @param    file            文件路径
         * @param    receivefunc        snd:Sound
         */
        public static function loadSoundAndReceive(file:String, receivefunc:Function):void {
            var l:BinSoundLoader = new BinSoundLoader(file, receivefunc);
            l.load();
        }

        /**
         * 加载影片文件
         * @param file      文件路径
         * @param receivefunc   mc:DisplayObject
         */
        public static function loadMovieAndReceive(file:String, receivefunc:Function, progFunc:Function = null):void {
            var l:BinFileLoader3 = new BinFileLoader3(file, receivefunc, progFunc);
            l.load();
        }
    }
}
