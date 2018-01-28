state("電車でＤ_BurningStage")
{
	byte stage : 0x16FDA0, 0x44;
	byte cleared : 0x16FDA0, 0x54C;
	byte mode : 0x16FDA0, 0x4;
	// 0 - Menu ; 128 - Cutscene, no control ; 130 - Control ;
	// 131 - Win-Cutscene ; 138 - Exiting from stage (loss) ; 139 - Exiting from stage (win)
}

init
{
	vars.stage_3_fix = false;
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
	if(old.cleared == 3 && current.cleared == 7) {
		vars.stage_3_fix = true;
	}
	
	if(vars.stage_3_fix && old.mode != 130 && current.mode == 130) {
		vars.stage_3_fix = false;
	}	

	if(old.cleared == 15 && current.cleared == 31) {
		vars.stage_5_fix = true;
	}
	
	if(vars.stage_5_fix && old.mode != 130 && current.mode == 130) {
		vars.stage_5_fix = false;
	}	
}

isLoading
{
	return current.mode != 130 || vars.stage_5_fix || vars.stage_3_fix;
}
