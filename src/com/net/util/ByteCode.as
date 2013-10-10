package com.net.util
{
	import flash.utils.ByteArray;
	
	public class ByteCode
	{
		private var head:ByteArray = null;
		private var body:ByteArray = null;
		
		public static var BEGINCHAR:String = "#";
		public static var ENDCHAR:String = "!";
		
		public function getHead():ByteArray
		{
			if(head)
				head.position = 0;
			return head;
		}
		public function getBody():ByteArray
		{
			if(body)
				body.position = 0;
			return body;		
		}
	
		public static function getIntArray(ba:ByteArray):Array
		{
			if(!ba) return null;
			var rt:Array = new Array();
			var op:int = ba.position;
			ba.position = 0;
			while(ba.bytesAvailable>3)
			{
				rt.push(ba.readInt());
			}
			ba.position = op;
			return rt;
		}
		public static function traceByte(ba:ByteArray,str:String ="Send ",radix:int=16):String
		{
			var s:String = str +"("+ba.length+" B)";
			ba.position = 0;
			var tmp:String;
			while(ba && ba.bytesAvailable)
			{
				
				tmp = ("00"+ba.readUnsignedByte().toString(radix).toUpperCase() );
				s+= (" " + tmp.slice(tmp.length-(256/(radix*radix)+1),tmp.length) );
			}
			ba.position = 0;
			return s;
		}
		public static function traceHead(h:ByteArray,str:String="Send "):String
		{
			if(!h) return null;
			h.position = 0;
			var s:String = str;
			while(h.bytesAvailable >3)
			{
				s+=(" " + h.readInt());				
			}
			h.position = 0;
			return s;
		}
	}
}