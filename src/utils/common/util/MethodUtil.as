package utils.common.util {

	public class MethodUtil {
		public static function create(f : Function,... arg) : Function {
			var ff : Function = function(...p):void {
				f.apply(null, p.concat(arg));
			};
			return ff;
		}

		public static function simple(f : Function,... arg) : Function {
			var ff : Function = function(...p):void {
				f.apply(null, arg);
			};
			return ff;
		}
	}
}