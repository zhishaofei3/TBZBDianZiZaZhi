/**
 * 计算贝塞尔曲线的方法
 */
package utils.common.util {
    import flash.geom.Point;

    public class BezierUtil {

        private static function pointOnCubicBezier3(cp:Array, t:Number):Point {
            var ax:Number, bx:Number, cx:Number;
            var ay:Number, by:Number, cy:Number;
            var tSquared:Number, tCubed:Number;
            var result:Point = new Point();
            /* 計算多項式係數 */
            cx = 3.0 * (cp[1].x - cp[0].x);
            bx = 3.0 * (cp[2].x - cp[1].x) - cx;
            ax = cp[3].x - cp[0].x - cx - bx;

            cy = 3.0 * (cp[1].y - cp[0].y);
            by = 3.0 * (cp[2].y - cp[1].y) - cy;
            ay = cp[3].y - cp[0].y - cy - by;
            /* 計算位於參數值 t 的曲線點 */
            tSquared = t * t;
            tCubed = tSquared * t;
            result.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + cp[0].x;
            result.y = (ay * tCubed) + (by * tSquared) + (cy * t) + cp[0].y;
            return result;
        }

        public static function computeBezier(cp:Array, numberOfPoints:int):Array {
            var curve:Array = new Array();
            var dt:Number = 0;
            dt = 1.0 / ( numberOfPoints - 1 );
            var f:Function = pointOnCubicBezier2;
            if (cp.length == 4) {
                f = pointOnCubicBezier3;
            }
            for (var i:int = 0; i < numberOfPoints; i++) {
                curve[i] = f(cp, i * dt);
            }
            return curve;
        }

        private static function pointOnCubicBezier2(cp:Array, t:Number):Point {
            var x:Number = (cp[0].x + cp[2].x - 2 * cp[1].x) * t * t + (2 * cp[1].x - 2 * cp[0].x) * t + cp[0].x;
            var y:Number = (cp[0].y + cp[2].y - 2 * cp[1].y) * t * t + (2 * cp[1].y - 2 * cp[0].y) * t + cp[0].y;
            return new Point(x, y);
        }
    }
}
