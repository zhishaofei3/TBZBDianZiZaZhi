package utils.common.util {
    import flash.net.getClassByAlias;
    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    public class ObjectUtil {
        public static function getLinkageObj(obj:String):Object {
            var o:Class = getDefinitionByName(obj) as Class;
            if (o == null) {
                o = getClassByAlias(obj);
            }
            if (o == null) {
                return null;
            }
            return new o();
        }

        private static function regtype(tn:String):void {
            if (tn == null || tn == "null" || tn == "int" || tn == "string" || tn == "Number" || tn == "String" || tn == "Boolean" || tn == "Object")return;
            var type:Class;
            try {
                type = getClassByAlias(tn);
            } catch(err:Error) {
            }
            if (type != null)return;
            try {
                type = Class(getDefinitionByName(tn));
            } catch(err:Error) {
                return;
            }
            if (type == null)return;
            registerClassAlias(tn, type);
        }

        private static function registerClass(source:*):void {
            var tn:String = getQualifiedClassName(source);
            regtype(tn);
            if (tn == "Array" || tn == "flash.utils::Dictionary") {
                for (var ele:String in source) {
                    registerClass(source[ele]);
                }
            }
            var dxml:XML = describeType(source);
            for each(var acc:XML in dxml.accessor) {
                registerClass(source[acc.@name]);
            }
            for each(var acc1:XML in dxml.variable) {
                registerClass(source[acc1.@name]);
            }
            for each(var acc2:XML in dxml.implementsInterface) {
                regtype(acc2.@type);
            }
            regtype(dxml.extendsClass.@type);
        }

        public static function baseClone(source:*):* {
            registerClass(source);
            var copier:ByteArray = new ByteArray();
            copier.writeObject(source);
            copier.position = 0;
            return copier.readObject();
        }
    }
}
