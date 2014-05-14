package utils.common.util {
    import flash.text.TextField;

    /**
     * @author WWJ
     */
    public class StringUtil {
        private static var t:TextField = new TextField();

        public static function transHtml(s:String):String {
            t.htmlText = s;
            return t.text;
        }

        public static function ip2long(ip:String):Number {
            var ips:Array = ip.split(".");
            return 16777216 * Number(ips[0]) + 65536 * Number(ips[1]) + 256 * Number(ips[2]) + Number(ips[3]);
        }

        public static function long2ip(n:Number):String {
            var mask1:Array = [0x000000FF, 0x0000FF00, 0x00FF0000, 0xFF000000];
            var num:Number;
            var ip:String = "";
            for (var i:int = 0; i < 4; i++) {
                num = (n & mask1[i]) >>> (i * 8);
                if (i > 0) {
                    ip = ip + ".";
                }
                ip = ip + num;
            }
            return ip;
        }

        /**
         * remove the blankspaces of left and right in targetString
         */
        public static function trim(targetString:String):String {
            return trimLeft(trimRight(targetString));
        }

        /**
         * remove only the blankspace on targetString's left
         */
        public static function trimLeft(targetString:String):String {
            if (targetString == null) {
                return null;
            }
            var reg:RegExp = /^\s*/;
            return targetString.replace(reg, "");
        }

        /**
         * remove only the blankspace on targetString's right
         */
        public static function trimRight(targetString:String):String {
            if (targetString == null) {
                return null;
            }
            var reg:RegExp = /\s*$/;
            return targetString.replace(reg, "");
        }

        public static function split(input:String, s:String):Array {
            var ar:Array = [];
            var last:int = 0;
            do {
                var id:int = input.indexOf(s, last);
                if (id != -1) {
                    ar.push(input.substring(last, id));
                    last = id + 1;
                } else {
                    ar.push(input.substring(last));
                    break;
                }
                if (last == input.length) {
                    break;
                }
            } while (true);
            return ar;
        }

        /**
         *
         * @param input
         * @return
         */
        public static function isEmail(input:String):Boolean {
            var pattern:RegExp = /^[\w-]+(\.[\w-]+)*@([a-z0-9-]+(\.[a-z0-9-]+)*?\.[a-z]{2,6}|(\d{1,3}\.){3}\d{1,3})(:\d{4})?$/i;
            var result:Object = pattern.exec(input);
            if (result == null) {
                return false;
            }
            return true;
        }

        /**
         * 判断字符是否为null或者为empty
         *
         * @param input 要检测的字符串
         * @return  如果为null或empty，返回为true,否则为false
         */
        public static function isNullOrEmpty(input:String):Boolean {
            if (input == null)
                return true;
            if (trim(input) == "")
                return true;
            return false;
        }

        public static function isValidString(input:String, regStr:String):Boolean {
            var pattern:RegExp = new RegExp(regStr);
            var result:Object = pattern.exec(input);
            if (result == null) {
                return false;
            }
            return true;
        }

        /*
         * 测量输入长度
         */
        public static function getStringLenForAsia(txt:String):Number {
            var len:Number;
            len = 0;
            for (var i:int = 0; i < txt.length; i++) {
                if (txt.charCodeAt(i) >= 0x4e00 && txt.charCodeAt(i) <= 0x9fa5) {
                    len += 2;
                } else {
                    len += 1;
                }
            }
            return len;
        }

        /**
         * 返回混合字符串中理应长度的索引
         * @param txt
         * @param b
         * @return
         */
        public static function getIndex(txt:String, b:int):int {
            var len:Number;
            len = 0;
            for (var i:int = 0; i < txt.length; i++) {
                if (txt.charCodeAt(i) >= 0x4e00 && txt.charCodeAt(i) <= 0x9fa5) {
                    len += 2;
                } else {
                    len += 1;
                }
                if (len > b) {
                    return i - 1;
                }
                if (len == b) {
                    return i;
                }
            }
            return b;
        }
    }
}
