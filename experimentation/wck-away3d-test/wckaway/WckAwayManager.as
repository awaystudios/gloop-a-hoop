package wckaway
{

	import flash.geom.Rectangle;

	import shapes.ShapeBase;

	public class WckAwayManager implements IWckAwayInterface
	{
		private static var _instance:WckAwayManager;

		private var _view:IWckAwayInterface;

		public function WckAwayManager() {
		}

		public static function get instance():WckAwayManager {
			if( !_instance ) _instance = new WckAwayManager();
			return _instance;
		}

		public function set view( value:IWckAwayInterface ):void {
			_view = value;
		}

		public function addBoxSkin( body:ShapeBase, bounds:Rectangle ):void {
			if( !_view ) return;
			_view.addBoxSkin( body, bounds );
		}

		public function addCircleSkin( body:ShapeBase, bounds:Rectangle ):void {
			if( !_view ) return;
			_view.addCircleSkin( body, bounds );
		}
	}
}
