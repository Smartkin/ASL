state("電車でＤ_LightningStage")
{
	byte stage : 0x167EE4, 0x38;
	byte cleared : 0x167EE4, 0x67C;
	byte mode : 0x167EE4, 0x8;
	// 0 - Menu ; 128 - Cutscene, no control ; 130 - Control ;
	// 131 - Win-Cutscene ; 138 - Exiting from stage (loss) ; 139 - Exiting from stage (win)
}

init
{
	vars.nakazato_hotfix = false;
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
	if((old.cleared & 4) == 0 && (current.cleared & 4) == 4) { // Nakazato Hotfix
		vars.nakazato_hotfix = true;
	}

	if(vars.nakazato_hotfix && old.mode != 130 && current.mode == 130) {
		vars.nakazato_hotfix = false;
	}
}

isLoading
{
	return current.mode != 130 || vars.nakazato_hotfix;
}
