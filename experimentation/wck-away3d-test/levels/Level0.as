package levels
{

	import flash.events.Event;

	import wck.WCK;

	public class Level0 extends WCK
	{
		public function Level0() {
			super();
			addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}

		private function addedToStageHandler( event:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			create();
		}
	}
}
