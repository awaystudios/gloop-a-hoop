package
{

	import shapes.ShapeBase;

	public class Fan extends ShapeBase
	{
		public var fanBox:FanBox;
		public var fanArea:FanArea;

		public override function create():void {
			type = "Static";
			super.create();
			fanBox.create();
			fanArea.create();
			fanArea.fanCenter = fanBox.b2body.GetWorldCenter();
		}
	}
}
