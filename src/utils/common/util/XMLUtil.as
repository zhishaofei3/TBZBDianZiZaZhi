package utils.common.util {

	/**
	 * @author WWJ
	 */
	public class XMLUtil {

		public static function parseURLCode(s : String,...args) : XML {
			for (var i : int = 0;i < args.length; i++) {
				var ss : String = args[i];
				var s1 : String = "&lt;" + ss + "\/&gt;";
				var s2 : String = "&lt;" + ss + "&gt;";
				var s3 : String = "&lt;\/" + ss + "&gt;";
				var r1 : RegExp = new RegExp(s1, "g");
				var r2 : RegExp = new RegExp(s2, "g");
				var r3 : RegExp = new RegExp(s3, "g");
				s = s.replace(r1, "<" + ss + "/>");
				s = s.replace(r2, "<" + ss + ">");
				s = s.replace(r3, "</" + ss + ">");
			}
			return new XML(s).copy();
		}
	}
}
