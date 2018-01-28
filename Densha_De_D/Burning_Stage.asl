// Burning Stage Autosplitter thanks to Jugachi
// Twitter: https://twitter.com/JugachiHD
// Twitch: https://twitch.tv/Jugachi

state("電車でＤ_BurningStage")
{
	byte stage : 0x16FDA0, 0x44;
	byte cleared : 0x16FDA0, 0x54C;
	byte mode : 0x16FDA0, 0x4;
}

init
{
	vars.stage_5_fix = false;
}

start
{
	return current.stage == 0 && current.mode == 130 && old.mode == 128;
}

reset
{
	return current.stage == 0 && current.mode == 130 && old.mode == 128;
}

split
{
	return current.cleared > old.cleared;
}

update
{
	if(old.cleared == 15 && current.cleared == 31) { // Stage 5 fix to pause during the final cutscene
		vars.stage_5_fix = true;
	}
	
	if(vars.stage_5_fix && old.mode != 130 && current.mode == 130) {
		vars.stage_5_fix = false;
	}	
}

isLoading
{
	return current.mode != 130 || vars.stage_5_fix;
}
