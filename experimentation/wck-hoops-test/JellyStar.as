package
{

	import Box2DAS.Dynamics.ContactEvent;

	import shapes.Circle;

	public class JellyStar extends Circle
	{
		public override function create():void {
			type = "Static";
			isSensor = true;
			reportBeginContact = true;
			reportEndContact = true;
			listenWhileVisible( this, ContactEvent.BEGIN_CONTACT, handleContact );
			super.create();
		}

		public function handleContact( e:ContactEvent ):void {
			var gloop:Gloop = e.other.m_userData;
			if( gloop ) {
				// TODO: trigger an event here, or use Util.addChildAtPosOf to replace the body by a sprite animation ( fade out ).
				remove();
			}
		}
	}
}
