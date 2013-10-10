package com.net.util
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class MsgUtil
	{
		public static function getTypeId(ba:ByteArray):int
		{
			ba.position = 0;
			return ba.readInt();	
		}
		public static function getHeadData(ba:ByteArray,intindex:int):int
		{
			ba.position = intindex * 4;
			return ba.readInt();
		}
		
		public static function creatByteArray():ByteArray
		{
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			return ba;	
		}
	}
} 
