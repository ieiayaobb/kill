package com
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.Socket;
	/**
	 * ...
	 * @author NeverBaby
	 */
	public class Main extends Sprite 
	{
		private var socket:Socket; 
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			socket = new Socket(); 
     
			socket.addEventListener( Event.CONNECT, onConnect ); 
     
			socket.connect("23.88.2.68", 30000 ); 
		} 

		private function onConnect( event:Event ):void { 
			trace( "The socket is now connected..." ); 
		} 
	}
	
}