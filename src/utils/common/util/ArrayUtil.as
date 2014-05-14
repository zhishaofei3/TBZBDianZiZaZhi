package utils.common.util {
    public class ArrayUtil {

        /**
         * 判断2个数组是否完全相同
         * @param ar
         * @param actframes
         * @return
         */
        public static function same(ar:Array, actframes:Array):Boolean {
            if (ar == null && actframes == null)return true;
            if (ar == null || actframes == null)return false;
            if (ar.length != actframes.length)return false;
            for (var i:int = 0; i < ar.length; i++) {
                if (ar[i] != actframes[i])return false;
            }
            return true;
        }

        /**
         * 过滤掉第一个属性为value的元素.不修改原数组
         * @param ar1
         * @param prop
         * @param value
         * @return Array
         */
        public static function filterFirst(ar1:Array, prop:String, value:Object):Array {
            var con:Array = ar1.slice();
            for (var i:uint = 0; i < con.length; i++) {
                if (con[i][prop] == value) {
                    con.splice(i, 1);
                    return con;
                }
            }
            return con;
        }


        /**
         * 过滤掉所有属性为value的元素.不修改原数组,
         * @param ar1
         * @param prop
         * @param value
         * @return Array 过滤后的新数组
         */
        public static function filter(ar1:Array, prop:String, value:Object):Array {
            var con:Array = ar1.slice();
            for (var i:uint = 0; i < con.length; i++) {
                if (con[i][prop] == value) {
                    con.splice(i, 1);
                    i--;
                }
            }
            return con;
        }

        /**
         * 过滤掉所有属性为value的元素.不修改原数组,
         * @param aArray
         * @param prop
         * @param value
         * @return Array 过滤后的新数组
         */
        public static function del(aArray:Array, prop:String, value:Object):void {
            for (var i:uint = 0; i < aArray.length; i++) {
                if (aArray[i][prop] == value) {
                    aArray.splice(i, 1);
                    i--;
                }
            }
        }

        /**
         * 查找数组中的元素的属性prop的值为value的元素
         * @param ar1
         * @param prop
         * @param value
         * @return Boolean
         */
        public static function isIn(ar1:Array, prop:String, value:Object):Boolean {
            var con:Array = ar1.slice();
            for (var i:uint = 0; i < con.length; i++) {
                if (con[i][prop] == value) {
                    return true;
                }
            }
            return false;
        }

        /**
         * 从数组中查找元素prop属性值为value的第一个元素
         * @param ar1
         * @param prop
         * @param value
         * @return Object
         */
        public static function find(ar1:Array, prop:String, value:Object):Object {
            for (var i:int = 0; i < ar1.length; i++) {
                if (ar1[i][prop] != null && ar1[i][prop] == value) {
                    return ar1[i];
                }
            }
            return null;
        }

        /**
         * 从数组中查找元素prop属性值为value的所有元素,不修改原数组
         * @param ar1
         * @param prop
         * @param value
         * @return Array
         */
        public static function findAll(ar1:Array, prop:String, value:Object):Array {
            var ar:Array = [];
            for (var i:int = 0; i < ar1.length; i++) {
                if (ar1[i][prop] != null && ar1[i][prop] == value) {
                    ar.push(ar1[i]);
                }
            }
            return ar;
        }

        public static function removeAllFromArray(arr:Array, obj:Object):void {
            for (var i:int = 0; i < arr.length; i++) {
                if (arr[i] == obj) {
                    arr.splice(i, 1);
                    i--;
                }
            }
        }

        /**
         * 把所有的元素都改成int型
         * 不修改原数组
         * @param ar
         */
        public static function toInt(ar:Array):Array {
            var ar1:Array = [];
            for (var i:int = 0; i < ar.length; i++) {
                if (ar[i] != "") {
                    ar1[i] = parseInt(ar[i]);
                }
            }
            return ar1;
        }

        /**
         * 得到最大公约数
         * @param s
         * @return
         */
        public static function getMin(s:Array):int {
            var mm:int = Math.abs(s.shift());
            while (s.length > 0) {
                mm = g(mm, Math.abs(s.shift()));
            }
            return mm;
        }

        private static function g(s1:int, s2:int):int {
            if (s1 == 0) {
                return s2;
            } else if (s2 == 0) {
                return s1;
            }
            if (s1 != s2) {
                if (s1 > s2) {
                    s1 -= s2;
                } else {
                    s2 -= s1;
                }
                return g(s1, s2);
            }
            return s1;
        }
    }
}
