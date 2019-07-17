state("電車でＤ_BurningStage_Ver1.07")
{
	byte stage : 0x16FDA0, 0x44;
	byte cleared : 0x16FDA0, 0x54C;
	byte mode : 0x16FDA0, 0x4;
	// 0 - Menu ; 128 - Cutscene, no control ; 130 - Control ;
	// 131 - Win-Cutscene ; 138 - Exiting from stage (loss) ; 139 - Exiting from stage (win)
	
	byte pause_state : 0x16FDA0, 0x6DC, 0x30, 0x4, 0x24, 0xC;
	float timer : 0x16FDA0, 0x64, 0x8, 0x48C;
	float game_speed : 0x16FDA0, 0x47C;
}

startup
{
	vars.game_time = 0.0;
	vars.multiplier = 1;
	vars.fps = 60.0f;
}

init
{
	vars.stage_3_fix = false;
	vars.stage_5_fix = false;
}

start
{
	if (current.stage == 0 && current.mode == 130 && old.mode == 128)
	{
		vars.game_time = 0;
		vars.stage_3_fix = false;
		vars.stage_5_fix = false;
	}
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
	
	//Reset variables if timer was reset
	if (timer.CurrentTime.RealTime.HasValue)
	{
		if (timer.CurrentTime.RealTime.Value.Ticks == 0)
		{
			vars.game_time = 0;
		}
	}
	
	if (!(current.mode != 130 || vars.stage_5_fix || vars.stage_3_fix) && current.timer != old.timer)
	{
		if (current.pause_state == 0)
		{
			vars.multiplier = 1/current.game_speed;
			if (current.timer > old.timer)
			{
				vars.game_time += (current.timer-old.timer)*(vars.multiplier/vars.fps);
			}
			else
			{
				vars.game_time += (60 % old.timer+current.timer)*(vars.multiplier/vars.fps);
			}
		}
		else
		{
			vars.game_time += 1/vars.fps;
		}
	}
	//var temp = vars.game_time * 1000;
	//print("Game time: " + temp.ToString());
	//print("Game speed: " + current.game_speed.ToString());
	if (current.cleared > old.cleared)
	{
		print("Old cleared " + old.cleared.ToString());
		print("Current cleared " + current.cleared.ToString());
	}
}

isLoading
{
	return current.mode != 130 || vars.stage_5_fix || vars.stage_3_fix;
}

gameTime
{
	return TimeSpan.FromMilliseconds(vars.game_time * 1000);
}