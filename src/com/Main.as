package com
{
	import com.net.core.NetEngine;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import com.net.core.Person;
	import com.net.core.NetEvent;
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
			
			
			//var byte:ByteArray=new ByteArray;
			//msg.writeToDataOutput(byte);//序列化到byte中;
			
			var person:Person = new Person();
			person.id = 1;
			person.name = "Peter";
			
			/*var msg:Msg=new Msg;
			msg.readFromDataOutput(byte);//反序列化message.*/
			
			var netEngine:NetEngine = new NetEngine();
			netEngine.connect("23.88.2.68", 30000 ); 
			
			netEngine.addEventListener(NetEvent.ON_CONNECT,function(ne:NetEvent):void{
				netEngine.call(person);
			});
		} 

	}
	
}