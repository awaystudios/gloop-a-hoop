package
{

	import shapes.Box;

	public class Wall extends Box
	{
		public override function create():void {
			type = "Static";
			restitution = 0.33;
			super.create();
		}
	}
}
