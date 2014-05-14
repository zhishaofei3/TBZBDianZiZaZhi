package utils.common.component.loading {
    import utils.common.component.display.AbstractDisplayObject;

    import flash.display.BlendMode;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class SimpleLoading extends AbstractDisplayObject {
        private var _progress:Number = 0;
        private var h:Number;
        private var w:Number;
        private var t:TextField;

        public function SimpleLoading(w:Number = 100, h:Number = 20) {
            super();
            this.w = w;
            this.h = h;
            t = new TextField();
            addChild(t);
            t.autoSize = TextFieldAutoSize.CENTER;
            t.blendMode = BlendMode.INVERT;
            redraw();
        }

        public function get progress():Number {
            return _progress;
        }

        public function set progress(value:Number):void {
            value = value > 1 ? 1 : value;
            value = value < 0 ? 0 : value;
            _progress = value;
            redraw()
        }

        private function redraw():void {
            t.text = "" + Math.floor(progress * 100) + "%";
            t.x = (w - t.width) / 2;
            graphics.clear();
            graphics.lineStyle(1);
            //
            graphics.beginFill(0xcccccc);
            graphics.drawRect(0, 0, w, h);
            graphics.endFill();
            graphics.beginFill(0x0000ff);
            graphics.drawRect(0, 0, progress * w, h);
            graphics.endFill();
        }
    }
}
