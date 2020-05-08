using System;
using raylib_beef.Types;
using raylib_beef;
using System.Collections;

namespace SpaceGame
{
	static class Sounds
	{
		public static Sound sBeepMed;
		public static Sound sBeepHigh;
		public static Sound sBeepHighLong;
		public static Sound sFail;
		public static Sound sLaser;
		public static Sound sExplode;

		static List<Sound> sSounds = new .() ~ delete _;

		public static void Dispose()
		{
			ClearAndDeleteItems(sSounds);
		}

		public static Result<Sound> Load(StringView fileName)
		{
			Sound sound = Raylib.LoadSound(fileName.ToScopeCStr!()); //TODO: check for failure? need delete?
			sSounds.Add(sound);
			return sound;
		}

		public static Result<void> Init()
		{
			sBeepMed = Try!(Load("sounds/beep_med.wav"));
			sBeepHigh = Try!(Load("sounds/beep_high.wav"));
			sBeepHighLong = Try!(Load("sounds/beep_high_long.wav"));
			sFail = Try!(Load("sounds/fail.wav"));
			sLaser = Try!(Load("sounds/laser01.aiff"));
			sExplode = Try!(Load("sounds/explode01.wav"));
			return .Ok;
		}
	}
}
