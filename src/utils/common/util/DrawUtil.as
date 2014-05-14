/**
 * 一些画图的方法
 */
package utils.common.util {
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.geom.Point;

    public class DrawUtil {

        public static function breakLineTo(gra:Graphics, p1:Point, p2:Point):void {
            gra.moveTo(p1.x, p1.y);
            gra.lineTo(p1.x, (p2.y - p1.y) / 2 + p1.y);
            gra.lineTo(p2.x, (p2.y - p1.y) / 2 + p1.y);
            gra.lineTo(p2.x, p2.y);
        }

        public static function breakDashLineTo(gra:Graphics, p1:Point, p2:Point):void {
            gra.moveTo(p1.x, p1.y);
            dashTo(gra, p1, new Point(p1.x, (p2.y - p1.y) / 2 + p1.y));
            dashTo(gra, new Point(p1.x, (p2.y - p1.y) / 2 + p1.y), new Point(p2.x, (p2.y - p1.y) / 2 + p1.y));
            dashTo(gra, new Point(p2.x, (p2.y - p1.y) / 2 + p1.y), p2);
        }

        public static function lineTo(gra:Graphics, p1:Point, p2:Point):void {
            gra.moveTo(p1.x, p1.y);
            gra.lineTo(p2.x, p2.y);
        }

        public static function dashTo(gra:Graphics, p1:Point, p2:Point, len:Number = 5, gap:Number = 5):void {
            var seglength:Number, deltax:Number, deltay:Number;
            var segs:Number, cx:Number, cy:Number;
            seglength = len + gap;
            deltax = p2.x - p1.x;
            deltay = p2.y - p1.y;
            var delta:Number = Math.sqrt((deltax * deltax) + (deltay * deltay));
            segs = Math.floor(Math.abs(delta / seglength));
            var radians:Number = Math.atan2(deltay, deltax);
            cx = p1.x;
            cy = p1.y;
            deltax = Math.cos(radians) * seglength;
            deltay = Math.sin(radians) * seglength;
            var n:Number;
            for (n = 0; n < segs; n++) {
                gra.moveTo(cx, cy);
                gra.lineTo(cx + Math.cos(radians) * len, cy + Math.sin(radians) * len);
                cx += deltax;
                cy += deltay;
            }
            gra.moveTo(cx, cy);
            delta = Math.sqrt((p2.x - cx) * (p2.x - cx) + (p2.y - cy) * (p2.y - cy));
            if (delta > len) {
                gra.lineTo(cx + Math.cos(radians) * len, cy + Math.sin(radians) * len);
            } else if (delta > 0) {
                gra.lineTo(cx + Math.cos(radians) * delta, cy + Math.sin(radians) * delta);
            }
            gra.moveTo(p2.x, p2.y);
        }

        public function DrawUtil() {
        }

        public static function createStageGrid(mc:Sprite, gridw:int):void {
            var w:int=mc.stage.stageWidth;
            var h:int=mc.stage.stageHeight;

            mc.graphics.lineStyle(1);
            for (var i:int = 0; i < Math.ceil(w/gridw); i++) {
                mc.graphics.moveTo(i * gridw,0);
                mc.graphics.lineTo(i * gridw, h);
            }
            for (var j:int = 0; j < Math.ceil(h / gridw); j++) {
                mc.graphics.moveTo(0, j * gridw);
                mc.graphics.lineTo(w, j * gridw);
            }
        }
    }
}
