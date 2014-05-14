/**
 *
 */
package utils.common.util{
    import flash.geom.Point;

    public class MathUtil {
        public function MathUtil() {
        }

        /**
         * 根据两条由两点组成的线段得到交点,按数学中的坐标系计算
         * @param p1
         * @param p2
         * @param p3
         * @param p4
         * @return
         */
        public static function getPoint(p1:Point, p2:Point, p3:Point, p4:Point):Point {
            if (p1.equals(p3) || p1.equals(p4)) {
                return p1;
            }
            if (p2.equals(p3) || p2.equals(p4)) {
                return p2;
            }
            var k:Number;
            var b:Number;
            var p:Number;
            if (p1.x == p2.x) {
                k = 1;
                b = -p1.x;
                p = 1;
            }
            else if (p1.y == p2.y) {
                k = 0;
                b = p1.y;
                p = 2;
            }
            else {
                k = (p1.y - p2.y) / (p1.x - p2.x);
                b = p1.y - k * p1.x;
                p = 3;
            }
            if (p3.equals(p4)) {
                if (k * p3.x + b == p3.y) {
                    return p3.clone();
                }
            }
            //
            var k_:Number;
            var b_:Number;
            var p_:Number;
            if (p3.x == p4.x) {
                k_ = 1;
                b_ = -p3.x;
                p_ = 1;
            }
            else if (p3.y == p4.y) {
                k_ = 0;
                b_ = p3.y;
                p_ = 2;
            }
            else {
                k_ = (p3.y - p4.y) / (p3.x - p4.x);
                b_ = p3.y - k_ * p3.x;
                p_ = 3;
            }
            if (p1.equals(p2)) {
                if (k * p1.x + b == p1.y) {
                    return p1.clone();
                }
            }
            if (p == 1) {
                if (p_ == 1) {
                    if (b == b_) {
                        return new Point(-b, 0)
                    } else {
                        return null;
                    }
                }
                if (p_ == 2) {
                    return new Point(-b, b_)
                }
                if (p_ == 3) {
                    return new Point(-b, k_ * -b + b_);
                }
            }
            if (p == 2) {
                if (p_ == 1) {
                    return new Point(-b_, b);
                }
                if (p_ == 2) {
                    if (b == b_) {
                        return new Point(0, b);
                    } else {
                        return null;
                    }
                }
                if (p_ == 3) {
                    return new Point((b - b_) / k_, b)
                }
            }
            if (p == 3) {
                if (p_ == 1) {
                    return new Point(-b_, k * -b_ + b);
                }
                if (p_ == 2) {
                    return new Point((b_ - b) / k, b_)
                }
                if (p_ == 3) {
                    if(k_ - k==0){
                        return p1.clone();
                    }
                    var xx:Number = (b - b_) / (k_ - k);
                    return new Point(xx, k * xx + b);
                }
            }
            //
            return null;
        }

    }
}
